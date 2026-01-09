%% is the main script to realize the actual target DoAs for the PWE to realize at later stages

%% init params
sdmSize = 0.1;
Rx_size = 10;

%% creating saving directories
currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,"/DoARouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/"));
routeFolder = fullfile(currentFolder,"/DoARouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/");

%% loop

% wavefront info
%wf = readmatrix(""); % where the target wfs are stored
% pwe info
pwe_char = load("C:\Users\statsimp\Documents\Matlab_Code\old_pc\pwe_angles_10.mat");
pwe = pwe_char.angles;

% names info
s = load("names_rotPairs.mat");
finalMat = s.finalMat;
num = size(finalMat,1);

len = sdmSize;
wid = sdmSize;
recSide = 1.5;
rxDim = Rx_size;
        

for i = 1:num
    % name of object
   nameObj = finalMat{i}{1};

    % run the ray-router
    f = "";
    fName = f+"raysOf_"+nameObj+".mat";
    s = load(fName, "results");
    r = s.results;
    
    len_paths = length(r{1});
    if len_paths == 100
        DoA = getInvDoA( pwe, rxDim, recSide, r);
        % save the ray-routing results
        savePath = routeFolder + "DoAOf_"+nameObj+".mat";
        save(savePath, "DoA");
    else 
        disp(i)
        continue
    end

end

