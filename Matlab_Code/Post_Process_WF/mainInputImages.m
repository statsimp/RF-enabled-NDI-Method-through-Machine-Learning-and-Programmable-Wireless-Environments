% The difference of this main function is that it does not normalize the
% wavefront values to span in the [0, 1] range, rather each different trait, i.e., angles,
% pl, df has its own colormap.

%% init params
sdmSize = 0.1;
Rx_size = 10;

%% creating saving directories
currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,""));
routeFolder = fullfile(currentFolder,"");

%% loop

% names info
s = load("names_rotPairs.mat");
finalMat = s.finalMat;
num = size(finalMat,1);


%% image creating iterations

wfs = [];
is = {};
for i = 1:num

    % name of object
    nameObj = finalMat{i}{1};
        
    tic;
    % load the DoA steering info from ray-routing
    direc = ""; % where the input RF-wfs are stored
    fWF = "ReceivingWFOf_";
    nameDoA = direc+fWF+nameObj+".mat";
    if isfile(nameDoA)
        sWF = load(nameDoA);
        wf = sWF.finalVec;
        
        wf = reshape(wf, 1, []); % used only in the steering and not routing case
        
        wfs = [wfs; wf];
        is{length(is)+1} = i;
        toc;
    else
        continue 
    end
    
end

%% normalize the data entries to be more suitable for ML
wfs_1 = wfs(:,1:end/2);
wfs_2 = wfs(:,end/2+1:end);

azs = wfs_1(:,1:end/2);
els = wfs_1(:,end/2+1:end);
pls = wfs_2(:,1:end/2);
dfs = wfs_2(:,end/2+1:end);

max_az = max(azs, [], "all");
min_az = min(azs, [], "all");
max_el = max(els, [], "all");
min_el = min(els, [], "all");
max_pl = max(pls, [], "all");
min_pl = min(pls, [], "all");
max_df = max(dfs, [], "all");
min_df = min(dfs, [], "all");

scalars = [max_az, min_az, max_el, min_el, max_pl, min_pl, max_df, min_df];

%% create the images
iis = cell2mat(is);
iterationTotal = 1;
for i = iis
    % name of object
    nameObj = finalMat{i}{1};
        
    tic;
    finalVec = wfs(iterationTotal,:); % obtain the corresponding wf
    iterationTotal = iterationTotal+1; % update the total iteration for all the data entries

    % image "wavefront"
    img = wf2Img(finalVec, scalars); 

    % save the ray-routing results
    saveImg = routeFolder+nameObj+".png";
    imwrite(img, saveImg);
    toc;
end


