%% init params
sdmSize = 0.1;
Rx_size = 10;

%% creating saving directories
currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,"/newRuns3_DoARouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/"));
routeFolder = fullfile(currentFolder,"/newRuns3_DoARouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/");

%% loop

% wavefront info
%wf = readmatrix("C:\Users\stats\Documents\Forth\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\wavefront.txt");
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
    tic;
    f = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns3_final_routing_sdm_0.1_Rx_10\";
    fName = f+"raysOf_"+nameObj+".mat";
    s = load(fName, "results");
    r = s.results;
    
    len_paths = length(r{1});
    if len_paths == 100
        DoA = getInvDoA( pwe, rxDim, recSide, r);
        % save the ray-routing results
        savePath = routeFolder + "DoAOf_"+nameObj+".mat";
        save(savePath, "DoA");
        toc;
    else 
        disp(i)
        continue
    end

end
