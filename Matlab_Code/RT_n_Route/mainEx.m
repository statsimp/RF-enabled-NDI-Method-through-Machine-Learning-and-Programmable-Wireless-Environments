%% the script to execute the ray-tracing and routing based on parameter-run.

%% run variables

numOfDiffractions = 1; % is a variable that defines the number of diffractions in the ray-tracing, suggestions: [0 or 1]
subDiv = 3; % is a variable that defines, suggestions: [1, 2, 2.5, 3]


%% creating saving directories

currentFolder = pwd;

% path to create a map folder in the current working directory
mkdir( fullfile(currentFolder,"/asset_maps/"));
mapsFolder = fullfile(currentFolder,"/asset_maps/");

mkdir(fullfile(currentFolder,"/rays/"));
raysFolder = fullfile(currentFolder,"/rays/");


%% loop
graphPath = "C:\Users\stats\Documents\Forth\0_Forth\MATLAB-Forth\RayTracing Matlab\Example\Graphs\"+"graph_"+num2str(0.1)+"_"+num2str(10)+".mat"; 
s=load(graphPath, "G");
G = s.G;

names = cell(40,1);
d = dir(""); % where objects are stored
for j=1:40
    names{j} = d(j+2).name;
end
names = sortrows(names);
clear d;
clear j;

angles = readmatrix("angles.txt");
rotVec = load("rotVec.mat", "r");
rotVec = rotVec.r;

for i = 1:40 
    % arguments needed in map_generatorname = strsplit(objectsList(i),"."); % cell array name{1} is just the name with no file extension   
    name = strsplit(names{i},".");
    rotObjCount = 1;
    r = rotVec{i};
    rotObjCount = 1;
    for iter = 1:100
        objRotationAngle = angles(i,wfIters(rotObjCount)); % random angle in [0,360]
        objRotationVector = r(:,wfIters(rotObjCount)); % random axis of rotation
      

        len = 0.5;
        wid = 0.5;
        recSide = 1.5;
        rxDim = 10;

        run = 1;% distinguishes between Ray-tracing(1) and routing(2).
        
        [map_path, rx_pos, maxReflections] = map_generatorTrain( rotObjCount, run, {name{1},1,objRotationAngle,objRotationVector}, len, wid, iter, rxDim, recSide, mapsFolder);

        % run the ray-tracer to generate the rays corresponding to the generated map
        % the generated rays and the saving of them with the rx array
        rx_pos = [0;-4;1.5];
        rays = ray_tracingEx(map_path, rx_pos, maxReflections, numOfDiffractions, 5e8);
        rays_path = raysFolder + "raysOf_"+name{1}+"_diff"+num2str(numOfDiffractions)+"_div"+num2str(subDiv)+".mat";
        parsave(rays_path, rays);

        rotObjCount = rotObjCount+1;
    end
end

