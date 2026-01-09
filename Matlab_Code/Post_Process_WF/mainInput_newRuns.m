%% a script to create the input RF-wavefronts

%% init params
sdmSize = 0.1;
Rx_size = 10;
freq = 5e9;

%% creating saving directories
currentFolder = pwd;

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
    direc = "";
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
        fRouting = "";
        fNameRouting = fRouting+"raysOf_"+nameObj+".mat";
        sRouting = load(fNameRouting, "results");
        routingRays = sRouting.results;
    
        
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




