% 
% savePlace = "C:\Users\stats\Desktop\blender_possible\animation_examples\busman\screen\";
% parentFolder = "C:\Users\stats\Desktop\blender_possible\animation_examples\busman\triangles\";
% 
% 
% d = dir(parentFolder);
% 
% names = cell(length(d)-2,1);
% 
% for i =1:length(d)-2
%     names{i} = d(i+2).name;
% end
% 
% for j =1:length(d)-2
% 
%     filename = parentFolder+names{j};
%     TR = stlread(filename);
% 
%     name = strsplit(names{j}, ".stl");
%     %prefix = "damocleus_";
%     prefix = "";
%     screenshot( TR, prefix+name(1), savePlace);
% 
% end




%% rename...

% % Define the folder path
% folderPath = 'C:\Users\stats\Desktop\blender_possible\monster\screen\'; % Replace with the actual path to your folder
% 
% % Get a list of all files in the folder
% fileList = dir(folderPath); % List all files in the folder
% 
% % Loop through each file
% for i = 1:length(fileList)
%     % Get the name of the current file
%     oldName = fileList(i).name;
% 
%     % Ignore '.' and '..' entries and directories
%     if fileList(i).isdir
%         continue;
%     end
% 
%     % Create the new name by prefixing with 'dog_'
%     newName = ['monster_' oldName];
% 
%     % Generate the full paths for the old and new file names
%     oldFilePath = fullfile(folderPath, oldName);
%     newFilePath = fullfile(folderPath, newName);
% 
%     % Rename the file
%     movefile(oldFilePath, newFilePath);
% 
%     % Display the renaming action
%     fprintf('Renamed: %s -> %s\n', oldName, newName);
% end

%% New screenshot main that creates the snapshots of various objects' poses

% 
% savePlace = "C:\Users\stats\Documents\Forth\0_Forth\MATLAB-Forth\RayTracing Matlab\Example\new_runs_objects\";
% parentFolder = "C:\Users\stats\Documents\Forth\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\objects\";
% 
% d = dir(parentFolder);
% namesObjs = cell(length(d)-2,1);
% 
% for i = 1:length(d)-2
%     namesObjs{i} = d(i+2).name;
% end
% namesObjs = sortrows(namesObjs);
% 
% 
% for i = 1:length(d)-2
%     iter = 1;
% 
%     name = namesObjs{i};
%     obj = parentFolder+name;
% 
%     axis1 = [1, -1, 2];
%     axis1 = axis1./norm(axis1);
%     angles1 = linspace(1,360,50);
%     for j = 1:50
%         objRotationAngle = angles1(j); % random angle in [0,360]
%         objRotationVector = axis1; % random axis of rotationobjRotationAngle = angles(i,wfIters(rotObjCount)); % random angle in [0,360]
% 
%         TR = map_Screen({obj,1,objRotationAngle,objRotationVector});
%         filename = name(1:end-4)+"_"+num2str(iter);
% 
%         %screenshot(TR, filename, savePlace);
%         saveName = savePlace+filename+".stl";
%         stlwrite(TR, saveName)
% 
%         iter = iter+1;
%     end
% 
% 
%     axis2 = [-3, 1, -2];
%     axis2 = axis2./norm(axis2);
%     angles2 = linspace(5,360,50);
%     for j = 1:50
%         objRotationAngle = angles2(j); % random angle in [0,360]
%         objRotationVector = axis2; % random axis of rotation
% 
%         TR = map_Screen({obj,1,objRotationAngle,objRotationVector});
%         filename = name(1:end-4)+"_"+num2str(iter);
% 
%         %screenshot(TR, filename, savePlace);
%         saveName = savePlace+filename+".stl";
%         stlwrite(TR, saveName)
% 
%         iter = iter+1;
%     end
% 
% 
% 
% end

%% newRuns2

PARENTFOLDER = "C:\Users\statsimp\Documents\3D_Models\0_3D_Models_db\out_blend\final_option_norm\";
savePlaceSTL = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns2_stls\";
savePlaceIMG = "C:\Users\statsimp\Documents\Matlab_Code\old_pc\newRuns2_imgs\";

d = dir(parentFolder);
num = numel(d)-2;
namesObjs = cell(num,1);

s = load("names_rotPairs.mat");
finalMat = s.finalMat;

for i = 1:num
    
    nameObj = finalMat{i}{1};
    rotVec = finalMat{i}{2};
    rotAngle = finalMat{i}{3};
    
    obj = PARENTFOLDER+nameObj;
    TR = map_Screen({obj,1,rotAngle,rotVec});   
    filename = nameObj(1:end-4);
    r
    screenshot(TR, filename, savePlaceIMG);
    saveName = savePlaceSTL+filename+".stl";
    stlwrite(TR, saveName);

    disp(i)

end
    
