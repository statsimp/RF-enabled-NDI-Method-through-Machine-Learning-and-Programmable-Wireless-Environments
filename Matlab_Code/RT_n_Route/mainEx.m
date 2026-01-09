%% run variables

numOfDiffractions = 1; % is a variable that defines the number of diffractions in the ray-tracing, suggestions: [0 or 1]
subDiv = 3; % is a variable that defines, suggestions: [1, 2, 2.5, 3]


%% creating saving directories

currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,"/map_Ex22/"));
mapsFolder = fullfile(currentFolder,"/map_Ex22/");

mkdir(fullfile(currentFolder,"/rays_Ex22/"));
raysFolder = fullfile(currentFolder,"/rays_Ex22/");

%% loop

%path = "C:\Users\statsimp\Documents\3D_Models\0_3D_Models_db\medium\";
names = "beagle_dog.stl";

tic;
for i = 1:1 
    % arguments needed in map_generatorname = strsplit(objectsList(i),"."); % cell array name{1} is just the name with no file extension   
    name = strsplit(names{i},".");
    rotObjCount = 1;
    for iter = 1:1 
        objRotationAngle = 203.63; % random angle in [0,360]
        objRotationVector = [0.0996, 0.9284, 0.3581];
      

        len = 0.5;
        wid = 0.5;
        recSide = 1.5;
        rxDim = 30;
        
        run = 1;
        
        [map_path, rx_pos, maxReflections] = map_generatorTrain( rotObjCount, run, {name{1},1,objRotationAngle,objRotationVector}, len, wid, iter, rxDim, recSide, mapsFolder);

        % run the ray-tracer to generate the rays corresponding to the
        % generated map
        % the generated rays and the saving of them with the rx array
        % element positions on both rooms
        %rx_pos = getRandRXEx(rx_pos, subDiv);
        rx_pos = [0;-4;1.5];
        rays = ray_tracingEx(map_path, rx_pos, maxReflections, numOfDiffractions, 5e8);
        rays_path = raysFolder + "raysOf_"+name{1}+"_diff"+num2str(numOfDiffractions)+"_div"+num2str(subDiv)+".mat";
        parsave(rays_path, rays);

        rotObjCount = rotObjCount+1;
    end
end
toc;


