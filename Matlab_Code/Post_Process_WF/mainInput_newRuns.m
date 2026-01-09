%% init params
sdmSize = 0.1;
Rx_size = 10;
freq = 5e9;

%% creating saving directories
currentFolder = pwd;

% path to create a map folder in the current working directory
% mkdir( fullfile(currentFolder,"/newRuns_Input_sdm_"+num2str(sdmSize)+"_Rays_"+num2str(rayResolution)+"_Rx_"+num2str(Rx_size)+"/"));
% routeFolder = fullfile(currentFolder,"/newRuns_Input_sdm_"+num2str(sdmSize)+"_Rays_"+num2str(rayResolution)+"_Rx_"+num2str(Rx_size)+"/");

mkdir( fullfile(currentFolder,"/newRuns3_InputRouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/"));
routeFolder = fullfile(currentFolder,"/newRuns3_InputRouting_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/");

%% loop

% useful info for the final vec

% names info
s = load("names_rotPairs.mat");
finalMat = s.finalMat;
num = size(finalMat,1);

% image creating iterations

for i = 1:num
    % name of object
    nameObj = finalMat{i}{1};

    
    tic;
    % load the DoA steering info from ray-routing
    direc = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns3_DoARouting_sdm_0.1_Rx_10\";
    fSteer = "DoAOf_";
    nameDoA = direc+fSteer+nameObj+".mat";
    if isfile(nameDoA)
        sSteer = load(nameDoA);
        DoA = sSteer.DoA;
        az = DoA(1,:);
        el = DoA(2,:);
        % acquire DoA info
        idx_az = find(az<0);
        idx_el = find(el<0);
        az(idx_az) = 0;
        el(idx_el) = 0;
    
        % load the routing info from ray-routing
        fRouting = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns3_final_routing_sdm_0.1_Rx_10\";
        fNameRouting = fRouting+"raysOf_"+nameObj+".mat";
        sRouting = load(fNameRouting, "results");
        routingRays = sRouting.results;
    
        
        % % obtain wavefront
        % finalVec = [az, el, az, el];
        % 
        % % image "wavefront"
        % img = wf2Img4(finalVec); 
        % 
        % % save the ray-routing results
        % saveImg = routeFolder+name{1}+"_iter"+num2str(iter)+".tiff";
        % imwrite(img, saveImg);
    
    
        % obtain wavefront
        DoAinfo  = [az, el];
        finalVec = getReceivingWFnewRuns(routingRays, DoAinfo, freq);
        
        % save the ray-routing results
        saveReceivingWF = routeFolder+"ReceivingWFOf_"+nameObj+".mat";
        save(saveReceivingWF, "finalVec");
        
        toc;
    else
        continue
    end

end



