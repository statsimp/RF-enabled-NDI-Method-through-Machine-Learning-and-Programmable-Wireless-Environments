% the main script to generate the target DT visuals

PARENTFOLDER = ""; % where the DB assets are stored
savePlaceSTL = ""; % where to store the various rotated assets
savePlaceIMG = ""; % where to store the various DT visuals

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
    screenshot(TR, filename, savePlaceIMG);
    saveName = savePlaceSTL+filename+".stl";
    stlwrite(TR, saveName);

    disp(i)

end
    

