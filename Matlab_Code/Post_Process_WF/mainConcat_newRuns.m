%% Is a script to concatenate the RF-pixel imae with the target DT visual, hence making them ready for the pix2pix model


%% init params
sdmSize = 0.1;
Rx_size = 10;

%% creating saving directories
currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,"/newRuns3_OutputSteering_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/"));
routeFolder = fullfile(currentFolder,"/newRuns3_OutputSteering_sdm_"+num2str(sdmSize)+"_Rx_"+num2str(Rx_size)+"/");

%% loop

f1 = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns2_imgs500\";
d = dir(f1);

iterations = length(d)-2;
names = cell( iterations,1);
for j=1:iterations
    names{j} = d(j+2).name;
end
names = sortrows(names);
clear d;
clear j;


for i = 1:length(names)
    tic;
    % name of object case
    nameObj = names{i}(1:end-4);
        
    im1 = imread(f1+names{i});
    
    % load the DoA info from ray-routing
    direc = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns3_InputSteeringImages_sdm_0.1_Rx_10\";
    nameOfImg = nameObj;
    name2 = direc+nameOfImg+".stl.png";
    if isfile(name2)
        
        im2 = imread(name2);
    
        img = cat(2, im2, im1);
        % save the ray-routing results
        saveImg = routeFolder+nameOfImg+".jpg";
        imwrite(img, saveImg);
        
        toc;
    else 
        continue
    end

end



