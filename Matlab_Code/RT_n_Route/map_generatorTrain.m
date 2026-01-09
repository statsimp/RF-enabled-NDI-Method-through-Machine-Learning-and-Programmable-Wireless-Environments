function [map_path, rx_pos, maxReflections] = map_generatorTrain( rotObjCount, run, object_cell, lenTile, widTile, iteration, rxDim, recSide, savePlace)
%======!!!!!!!!!!!!!!!!!!======== It will need a "run" argument update for
%the ray-tracing/ ray-routing phases !!!

% map_generatorTrain: is a new version of the original function "map_generatorFinal" to create 
% the map with ris in configs. This version is used for the training phase
% of an iCopywaves project, where the RIS are configured to create the
% Wavefront Encoding.
% 
% ==============Arguments===================
%
%   - lenTile: length of the tile
%
%   - widTile: width of the tile
%
%   - rxDim: dimension of one side of the receiver array
%
%   - recSide: side of the RX array rectangle
%
%   - iter: iteration of random DoAs on a specific geometry
%=============Retutn===========================
%
%   - map_path: path to the file that has been created from stlread()
%
%   - rx_pos: the positions of array elements. Depending on run{1} value
%   there might be both the elements concerning room1 Rx receiver and room2
%

%%  init basic variables/cell-arrays/vectors

% unit vectors in cartesian space
ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

points_ceil = {};
ConnL_ceil = {};
 
points_left = {};
ConnL_left = {};
 
points_right = {};
ConnL_right = {};
 
points_back = {};
ConnL_back = {};

points_front = {};
ConnL_front = {};

% points_box1 = {};
% ConnL_box1 = {};
% 
% points_box2 = {};
% ConnL_box2 = {};
% 
% points_box3 = {};
% ConnL_box3 = {};
% 
% points_box4 = {};
% ConnL_box4 = {};
% 
% points_box5 = {};
% ConnL_box5 = {};
% sum init used for the conn_lists
sum = 0;

%% ris-dimensions, initialize the space dimensions, height/ length/ width of the room and other variables,
% number of patches on the horizontal and vertical axis

len = lenTile;
wid = widTile;

hspacing = len/5;
vspacing = wid/5;
  
room_height = 3;
room_length = 8.5;
room_width = 5;


%%
[rxPoints, ~, ~, centRoom1Left]= getRXpointsTrain(rxDim, recSide);

room1BackBoundary = centRoom1Left(1) + recSide/2;
room1FrontBoundary = centRoom1Left(1) - recSide/2;
room1TopBoundary = centRoom1Left(3) + recSide/2;
room1BottomBoundary = centRoom1Left(3) - recSide/2;

%%

frontLen1 = abs(room_width/2 - room1BackBoundary);
frontLen2 = abs(room1FrontBoundary + room_width/2);
frontLen3 = abs(room1BackBoundary - room1FrontBoundary);
frontVer1 = abs(room_height - room1TopBoundary);
frontVer2 = room1BottomBoundary;


num_frontLen1 = fix(frontLen1/(len+hspacing));
num_frontLen1_rem = rem(frontLen1,(len+hspacing));

num_frontLen2 = fix(frontLen2/(len+hspacing));
num_frontLen2_rem = rem(frontLen2,(len+hspacing));

num_frontLen3 = fix(frontLen3/(len+hspacing));
num_frontLen3_rem = rem(frontLen3,(len+hspacing));

num_frontVer1 = fix(frontVer1/(wid+vspacing));
num_frontVer1_rem = rem(frontVer1,(wid+vspacing));

num_frontVer2 = fix(frontVer2/(wid+vspacing));
num_frontVer2_rem = rem(frontVer2,(wid+vspacing));


num_Hor_len = fix(room_length/(len+hspacing)); %number of patches on the horizontal axis ( "length room axis" )
num_len_rem = rem(room_length,(len+hspacing));
num_Hor_wid = fix(room_width/(len+hspacing)); %number of patches on the horizontal axis ( "width room axis" )
num_wid_rem = rem(room_width,(len+hspacing));
num_Ver = fix(room_height/(wid+vspacing)); %number of patches on the vertical axis
num_ver_rem = rem(room_height,(wid+vspacing));


% center point translators
ceilTrans = -ex*(num_wid_rem/2) - ey*(num_len_rem/2);
%
leftTrans = +ez*(num_ver_rem/2) - ey*(num_len_rem/2);
%
% leftTrans1 = +ez*(num_ver_rem/2) - ey*(num_leftLen1_rem/2);
% leftTrans2 = +ez*(num_leftVer2_rem/2) - ey*(num_leftLen3_rem/2);
% leftTrans3 = +ez*(num_leftVer1_rem/2) - ey*(num_leftLen3_rem/2);
% leftTrans4 = +ez*(num_ver_rem/2) - ey*(num_leftLen2_rem/2);
%
rightTrans = +ez*(num_ver_rem/2) - ey*(num_len_rem/2);
%
% rightTrans1 = +ez*(num_ver_rem/2) - ey*(num_rightLen1_rem/2);
% rightTrans2 = +ez*(num_rightVer2_rem/2) - ey*(num_rightLen3_rem/2);
% rightTrans3 = +ez*(num_rightVer1_rem/2) - ey*(num_rightLen3_rem/2);
% rightTrans4 = +ez*(num_ver_rem/2) - ey*(num_rightLen2_rem/2);
%
backTrans = -ex*(num_wid_rem/2) + ez*(num_ver_rem/2);
%
%frontTrans =  -ex*(num_wid_rem/2) + ez*(num_ver_rem/2);
frontTrans1 = +ez*(num_ver_rem/2) - ex*(num_frontLen1_rem/2);
frontTrans2 = +ez*(num_frontVer2_rem/2) - ex*(num_frontLen3_rem/2);
frontTrans3 = +ez*(num_frontVer1_rem/2) - ex*(num_frontLen3_rem/2);
frontTrans4 = +ez*(num_ver_rem/2) - ex*(num_frontLen2_rem/2);


% room1Trans = -ex*(num_wid_div_rem/2) + ez*(num_Ver_div_rem/2);
% room2Trans = -ex*(num_wid_div_rem/2) + ez*(num_Ver_div_rem/2);


%% insert object

objectTR = stlread(object_cell{1}+".stl");

% getting the points and connectivity list of the triangulation object
object = objectTR.Points;
Cl_obj = objectTR.ConnectivityList;


% volume-wise object scaling
room_vol = room_height*room_length*room_width;

% object "dimensions"
obj_x =max(object(:,1)) - min(object(:,1));
obj_y =max(object(:,2)) - min(object(:,2));
obj_z =max(object(:,3)) - min(object(:,3));

obj_vol = obj_x*obj_y*obj_z;

% I want obj_vol/ room_vol = , so scalar 
wanted_obj_vol = 0.25;
ratio_vol = wanted_obj_vol / room_vol;

scalar = nthroot((ratio_vol*room_vol)/obj_vol, 3); % 3-rd root of the volume scalar

% final object "dimensions", scales the object in order to fit in the right way into the map
object = object*scalar;

% quaternion rotation
if object_cell{2} == 1
    
    % quaternion
    axis = object_cell{4};
    axis = axis./norm(axis);
    
    theta = object_cell{3};
    a = cosd(theta/2);
    b = sind(theta/2)*axis(1);
    c = sind(theta/2)*axis(2);
    d = sind(theta/2)*axis(3);
    quat = quaternion(a,b,c,d);
    
    % rotation
    rotObject = rotatepoint(quat, object);
    object = rotObject;
end


% translate to origin
moveX = mean(object(:,1));
moveY = mean(object(:,2));
moveZ = mean(object(:,3));
movingPoint = [moveX moveY moveZ];

object = object - movingPoint;


% translate to an aribtrary point in space you choose
%movingPoint = [ 1.55 2.25 0 ];
%object = object + movingPoint;


% vertical translation
minimum = min(object(:,3));
object = object + [ 0 0 -minimum]; % vertical translation

points_obj = object;

%% tile centers
label = 1;

% creating the patches on the ceiling
p_Ceil = zeros(num_Hor_len*num_Hor_wid,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Hor_wid-1
        p = [ room_width/2-(len/2+j*len+j*hspacing), room_length/2-(len/2+i*len+i*hspacing) , room_height] + ceilTrans;
        p_Ceil(iter,:) = [p, label];
        iter = iter+1;
        label=label+1;
    end
end

% creating the patches on the ceiling on the left
p_Left = zeros(num_Hor_len*num_Ver,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Ver-1
        p = [-room_width/2 , room_length/2-(len/2+i*len+i*hspacing) , j*vspacing+j*wid+wid/2] + leftTrans; 
        p_Left(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end


% creating the patches on the right
p_Right = zeros(num_Hor_len*num_Ver,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Ver-1
        p = [room_width/2 , room_length/2-(len/2+i*len+i*hspacing) , j*vspacing+j*wid+wid/2] + rightTrans; 
        p_Right(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the back wall
p_Back = zeros(num_Hor_wid*num_Ver,4);
iter = 1;
for i =0:num_Hor_wid-1
    for j = 0:num_Ver-1
        p = [room_width/2-(len/2+i*len+i*hspacing), room_length/2 , j*vspacing+j*wid+wid/2] +backTrans;
        p_Back(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front1 = zeros(num_frontLen1*num_Ver,4);
iter = 1;
for i =0:num_frontLen1-1
    for j = 0:num_Ver-1
        p = [room_width/2-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans1;
        p_Front1(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front2 = zeros(num_frontLen3*num_frontVer2,4);
iter = 1;
for i =0:num_frontLen3-1
    for j = 0:num_frontVer2-1
        p = [room1BackBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans2;
        p_Front2(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front3 = zeros(num_frontLen3*num_frontVer1,4);
iter = 1;
for i =0:num_frontLen3-1
    for j = 0:num_frontVer1-1
        p = [room1BackBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2 + room1TopBoundary] + frontTrans3;
        p_Front3(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front4 = zeros(num_frontLen2*num_Ver,4);
iter = 1;
for i =0:num_frontLen2-1
    for j = 0:num_Ver-1
        p = [room1FrontBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans4;
        p_Front4(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end
p_Front = [p_Front1; p_Front2; p_Front3; p_Front4];

rx = zeros(rxDim^2,4);
for i =1:rxDim^2
    rx(i,:) = [rxPoints(:,i)' label];
    label = label+1;
end

% total number of tiles
patches_Mat = [p_Ceil; p_Left; p_Right; p_Back; p_Front; rx];
%[num,~] = size(patches_Mat);

%% RIS connectivity graph

% folder = "C:\Users\stats\Documents\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\graphs\";
% graphFile = "graph_"+num2str(lenTile)+"_"+num2str(rxDim)+".mat";
% s=load(folder+graphFile, "G");
% G = s.G;

% patches = {p_Ceil; p_Left; p_Right; p_Back; p_Front};
% RIS = 123;
% visualizeRISGraphTrain(patches, RIS, patches_Mat)
%% creating the map

if run == 1
    % creating the patches on the ceiling
    for i = 1:length(p_Ceil)
        p = p_Ceil(i ,1:end-1);
        n = -ez;
        v = play(p,n,len,wid, "ceiling");
    
        % enter the vertices two the ceiling points matrix
        epanal = 1;
        for k = 1+length(points_ceil):4+length(points_ceil)
            vertices = v.';
            points_ceil{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end
    
        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 3 4]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_ceil{length(ConnL_ceil)+1,1} = triangles(iter,:) + length(points_ceil) - 4;
        end
    
    
    end
    
    points_ceil = cell2mat(points_ceil);
    sum = sum+length(points_obj);
    ConnL_ceil = cell2mat(ConnL_ceil)+sum;
    
    
    % creating the patches on the left
    for i = 1:length(p_Left)
        p = p_Left(i ,1:end-1);
        n = ex;
        v = play(p,n,len,wid, "left");
    
        % enter the vertices two the left points matrix
        epanal = 1;
        for k = 1+length(points_left):4+length(points_left)
            vertices = v.';
            points_left{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end
    
        % connectivity list matrix for the left patches         
        triangles = [1 2 4; 1 3 4]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_left{length(ConnL_left)+1,1} = triangles(iter,:) + length(points_left) - 4;
        end
    
    end
    
    points_left = cell2mat(points_left);
    sum = sum+length(points_ceil);
    ConnL_left = cell2mat(ConnL_left)+sum;
    
    
    % creating the patches on the right
    for i = 1:length(p_Right)
        p = p_Right(i ,1:end-1);
        n = ex;
        v = play(p,n,len,wid, "right");
    
        % enter the vertices two the right points matrix
        epanal = 1;
        for k = 1+length(points_right):4+length(points_right)
            vertices = v.';
            points_right{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end
    
        % connectivity list matrix for the right patches         
        triangles = [1 2 4; 1 3 4]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_right{length(ConnL_right)+1,1} = triangles(iter,:) + length(points_right) - 4;
        end
    
    
    end
    
    points_right = cell2mat(points_right);
    sum = sum+length(points_left);
    ConnL_right = cell2mat(ConnL_right)+sum;  
    
    
    % creating the patches on the back
    for i = 1:length(p_Back)
        p = p_Back(i ,1:end-1);
        n = -ey;
        v = play(p,n,len,wid, "back");
    
        % enter the vertices two the back points matrix
        epanal = 1;
        for k = 1+length(points_back):4+length(points_back)
            vertices = v.';
            points_back{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end
    
        % connectivity list matrix for the back patches         
        triangles = [1 2 4; 1 3 4]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_back{length(ConnL_back)+1,1} = triangles(iter,:) + length(points_back) - 4;
        end
    end
    
    points_back = cell2mat(points_back);
    sum = sum+length(points_right);
    ConnL_back = cell2mat(ConnL_back)+sum;
    
    % creating the patches on the front
    for i = 1:length(p_Front)
        p = p_Front(i ,1:end-1);
        n = ey;
        v = play(p,n,len,wid, "front");
    
        % enter the vertices two the back points matrix
        epanal = 1;
        for k = 1+length(points_front):4+length(points_front)
            vertices = v.';
            points_front{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end
    
        % connectivity list matrix for the back patches         
        triangles = [1 2 4; 1 3 4]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_front{length(ConnL_front)+1,1} = triangles(iter,:) + length(points_front) - 4;
        end
    end
    
    points_front = cell2mat(points_front);
    sum = sum+length(points_back);
    ConnL_front = cell2mat(ConnL_front)+sum;
    
    
    % The ground and total TR arguments
    % defining the ground "patch"
    v1 = [ room_width/2, room_length/2, 0 ];
    v2 = [ room_width/2, -room_length/2, 0 ];
    v3 = [ -room_width/2, room_length/2, 0 ];
    v4 = [ -room_width/2, -room_length/2, 0 ];
    points_gr = [v1 ; v2; v3; v4];
    
    ConnL_gr = [1 2 4; 1 3 4];
    sum = sum + length(points_front);
    ConnL_gr = ConnL_gr + sum;
    
    
    % The ground and total TR arguments
    % defining the ground "patch"
    % zero = [0 0 0];
    % 
    % meg = 1.25;
    % 
    % v11 = zero -meg/2*ey -meg/2*ex;
    % v21 = zero -meg/2*ey +meg/2*ex;
    % v31 = zero -meg/2*ey -meg/2*ex + meg*ez;
    % v41 = zero -meg/2*ey +meg/2*ex + meg*ez;
    % 
    % v12 = zero +meg/2*ey -meg/2*ex;
    % v22 = zero +meg/2*ey +meg/2*ex;
    % v32 = zero +meg/2*ey -meg/2*ex + meg*ez;
    % v42 = zero +meg/2*ey +meg/2*ex + meg*ez;
    % 
    % v13 = zero -meg/2*ey -meg/2*ex;
    % v23 = zero +meg/2*ey -meg/2*ex;
    % v33 = zero -meg/2*ey -meg/2*ex + meg*ez;
    % v43 = zero +meg/2*ey -meg/2*ex + meg*ez;
    % 
    % v14 = zero -meg/2*ey +meg/2*ex;
    % v24 = zero +meg/2*ey +meg/2*ex;
    % v34 = zero -meg/2*ey +meg/2*ex + meg*ez;
    % v44 = zero +meg/2*ey +meg/2*ex + meg*ez;
    % 
    % v15 = zero -meg/2*ey -meg/2*ex+ meg*ez;
    % v25 = zero -meg/2*ey +meg/2*ex+ meg*ez;
    % v35 = zero +meg/2*ey -meg/2*ex + meg*ez;
    % v45 = zero +meg/2*ey +meg/2*ex + meg*ez;
    % 
    % points_box1 = [v11 ; v21; v31; v41]; 
    % points_box2 = [v12; v22; v32; v42]; 
    % points_box3=[v13; v23; v33; v43];
    % points_box4=[ v14; v24; v34; v44];
    % points_box5=[v15; v25; v35; v45];
    % 
    % ConnL_box1 = [1 2 4; 1 3 4];
    % sum = sum + length(points_gr);
    % ConnL_box1 = ConnL_box1 + sum;
    % 
    % ConnL_box2 = [1 2 4; 1 3 4];
    % sum = sum + length(points_box1);
    % ConnL_box2 = ConnL_box2 + sum;
    % 
    % ConnL_box3 = [1 2 4; 1 3 4];
    % sum = sum + length(points_box2);
    % ConnL_box3 = ConnL_box3 + sum;
    % 
    % ConnL_box4 = [1 2 4; 1 3 4];
    % sum = sum + length(points_box3);
    % ConnL_box4 = ConnL_box4 + sum;
    % 
    % ConnL_box5 = [1 2 4; 1 3 4];
    % sum = sum + length(points_box4);
    % ConnL_box5 = ConnL_box5 + sum;

    % creating the total Points/ Connectivity List needed for the STL map
    % creation
    points = [points_obj; points_ceil; points_left; points_right; points_back; points_front; points_gr];
    ConnL = [Cl_obj; ConnL_ceil; ConnL_left; ConnL_right; ConnL_back; ConnL_front; ConnL_gr];
    %points = [points_obj; points_ceil; points_left; points_right; points_back; points_front];
    %ConnL = [Cl_obj; ConnL_ceil; ConnL_left; ConnL_right; ConnL_back; ConnL_front];
    
    %points = points_obj;
    %ConnL = Cl_obj;

    patches_Mat = [p_Ceil; p_Left; p_Right; p_Back; p_Front];
    rx_pos = patches_Mat(:,1:end-1)';
    maxReflections = 0;
end


if run == 2
    
    % rx_pos
    rx_pos = rxPoints;
    numRx = rxDim^2;

    % graph info
    graphPath = "C:\Users\stats\Documents\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\graphs\"+"graph_"+num2str(lenTile)+"_"+num2str(rxDim)+".mat"; 
    s=load(graphPath, "G");
    G = s.G;

    % rays of run 1
    raysPath = "C:\Users\stats\Documents\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\rays_TrainToy3\"+"raysOf_"+object_cell{1}+"_"+num2str(iteration)+".mat";
    s = load(raysPath, "rays");
    r = s.rays;
    [run1Rays, SDMs] = getIntRays(r); % labels of the SDMs/ RISs that are sensing from the object
    [label_SDM, Rays] = getSDMLabels(SDMs, numRx, run1Rays);

    % information about the wanted DoAs
    wf = readmatrix("C:\Users\stats\Documents\0_Forth\MATLAB-Forth\RayTracing Matlab\functions\Wavefront_mix_Greedy_Serially_func3_L_Toy.txt");
    DoA = getDoA(wf, rotObjCount, numRx);


    %get the last tile information
    patches_Cell = {p_Ceil, p_Left, p_Right, p_Back};
    usedRIS = [1];
    last_Tiles = cell(numRx, 1);
    for i =1:numRx
        last_Tiles{i} = getLastTileTrain(rx_pos(:,i)', DoA(:,i), patches_Cell, usedRIS, 1);
        member  = ismembertol( patches_Mat(:,1:end-1), last_Tiles{i}{2}{end},"Byrows", 10^-4);
        idx = find(member);
        usedRIS = [usedRIS patches_Mat(idx, end)]; % put the last_Tile in used RISs
    end
     
     
    % get the last connections
    lastConn = cell(numRx,1);
    for i =1:numRx
        lastConn{i} = [last_Tiles{i}{2}{1}; last_Tiles{i}{2}{2}];
    end

     
    % get the ray-routing paths
    [paths, maxReflections]= getPathsTrain(G, lastConn, Rays, patches_Mat, DoA, label_SDM);

    % ============= !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! =====================
    % ============= !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! =====================
    % generating the normal vectors and the indicies for the RISs that contribute to the
    % ray-routing process
    labels = {};
    normals = {};
    for i =1:numRx
        singlePath = paths{i};
        for j = 1:length(singlePath)-2
            
            prevTile = singlePath(j,:);
            centTile = singlePath(j+1,:);
            afterTile = singlePath(j+2,:);
            
            RowIdx = find(ismembertol(patches_Mat(:,1:end-1), centTile,"Byrows", 10^-4));
            labels{length(labels)+1} = patches_Mat(RowIdx,end);
            normals{length(normals)+1} = genNormalReflection(prevTile, centTile, afterTile)';
        end
        a=5;
    end
    
    labels = reshape(labels, length(labels), 1);
    labels = cell2mat(labels);
    
    normals = reshape(normals, length(normals), 1);
    normals = cell2mat(normals);
        
    % We use the labels of the RIS we want in order to create a pair of RIS
    % center index and normal vector for the corresponding Tile.

    % Auto poy kanoume katw einai to exis: dimiourgoume ena cell array opou
    % kathe cell value exei ena allo cell array. To deutero auto cell array
    % exei ws prwti timi tin timi twn deiktwn twn tiles poy xrhsimopoiountai sto 
    % ray- routing gia ton antistoixo toixo. H deuteri timi exei to katallilo
    % normal vector gia to antistoixo tile.

    patches_Cell = {p_Ceil, p_Left, p_Right, p_Back, p_Front};
    indiciesConf2 = cell(5,1);
    
    for i=1:5
        [rows, cols] = find(patches_Cell{i}(:,end) == labels');
        indiciesConf2{i} = {rows, normals(cols,:)}; 
    end


        % create the patches used in Conf2/ ray-routing

    % init cell arrays
    points_ceil2 = {};
    ConnL_ceil2 = {};
     
    points_left2 = {};
    ConnL_left2 = {};
     
    points_right2 = {};
    ConnL_right2 = {};
     
    points_back2 = {};
    ConnL_back2 = {};
    
    points_front2 = {};
    ConnL_front2 = {};


    % creating the tiles on the ceiling, used for ray-routing
    iteration = 1;
    for i = (indiciesConf2{1}{1})'
        p = patches_Cell{1}(i, 1:end-1);
        n = indiciesConf2{1}{2}(iteration,:);
        iteration = iteration+1;
        v = play2(p, n, len, wid, "ceiling");

        epanal = 1;
        for k = 1+length(points_ceil2):4+length(points_ceil2)
            vertices = v.';
            points_ceil2{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end

        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 4 3]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_ceil2{length(ConnL_ceil2)+1,1} = triangles(iter,:) + length(points_ceil2) - 4;
        end
    end

    points_ceil2 = cell2mat(points_ceil2);
    sum = sum+length(points_obj);
    ConnL_ceil2 = cell2mat(ConnL_ceil2)+sum;
    
    % creating the tiles on the left, used for ray-routing
    iteration = 1;
    for i = (indiciesConf2{2}{1})'
        p = patches_Cell{2}(i, 1:end-1);
        n = indiciesConf2{2}{2}(iteration,:);
        iteration = iteration+1;
        v = play2(p, n, len, wid, "left");

        epanal = 1;
        for k = 1+length(points_left2):4+length(points_left2)
            vertices = v.';
            points_left2{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end

        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 4 3]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_left2{length(ConnL_left2)+1,1} = triangles(iter,:) + length(points_left2) - 4;
        end
    end

    points_left2 = cell2mat(points_left2);
    sum = sum+length(points_ceil2);
    ConnL_left2 = cell2mat(ConnL_left2)+sum;

    % creating the tiles on the right, used for ray-routing
    iteration = 1;
    for i = (indiciesConf2{3}{1})'
        p = patches_Cell{3}(i, 1:end-1);
        n = indiciesConf2{3}{2}(iteration,:);
        iteration = iteration+1;
        v = play2(p, n, len, wid, "right");

        epanal = 1;
        for k = 1+length(points_right2):4+length(points_right2)
            vertices = v.';
            points_right2{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end

        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 4 3]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_right2{length(ConnL_right2)+1,1} = triangles(iter,:) + length(points_right2) - 4;
        end
    end

    points_right2 = cell2mat(points_right2);
    sum = sum+length(points_left2);
    ConnL_right2 = cell2mat(ConnL_right2)+sum;

    % creating the tiles on the back, used for ray-routing
    iteration = 1;
    for i = (indiciesConf2{4}{1})'
        p = patches_Cell{4}(i, 1:end-1);
        n = indiciesConf2{4}{2}(iteration,:);
        iteration = iteration+1;
        v = play2(p, n, len, wid, "back");

        epanal = 1;
        for k = 1+length(points_back2):4+length(points_back2)
            vertices = v.';
            points_back2{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end

        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 4 3]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_back2{length(ConnL_back2)+1,1} = triangles(iter,:) + length(points_back2) - 4;
        end
    end

    points_back2 = cell2mat(points_back2);
    sum = sum+length(points_right2);
    ConnL_back2 = cell2mat(ConnL_back2)+sum;

    % creating the tiles on the front, used for ray-routing
    iteration = 1;
    for i = (indiciesConf2{5}{1})'
        p = patches_Cell{5}(i, 1:end-1);
        n = indiciesConf2{5}{2}(iteration,:);
        iteration = iteration+1;
        v = play2(p, n, len, wid, "front");

        epanal = 1;
        for k = 1+length(points_front2):4+length(points_front2)
            vertices = v.';
            points_front2{k,1}= vertices(epanal,:);
            epanal = epanal +1;
        end

        % connectivity list matrix for the ceiling patches         
        triangles = [1 2 4; 1 4 3]; % combinations of triangles to insert in connectivity list
        for iter=1:2 % for practical reasons according to the cell indexing ( iter 2:3 )
            ConnL_front2{length(ConnL_front2)+1,1} = triangles(iter,:) + length(points_front2) - 4;
        end
    end

    points_front2 = cell2mat(points_front2);
    sum = sum+length(points_back2);
    ConnL_front2 = cell2mat(ConnL_front2)+sum;


        
    % defining the ground "patch"
    v1 = [ room_width/2, room_length/2, 0 ];
    v2 = [ room_width/2, -room_length/2, 0 ];
    v3 = [ -room_width/2, room_length/2, 0 ];
    v4 = [ -room_width/2, -room_length/2, 0 ];
    points_gr = [v1 ; v2; v3; v4];
    
    ConnL_gr = [1 2 4; 1 4 3];
    sum = sum + length(points_front2);
    ConnL_gr = ConnL_gr + sum;

    % creating the total Points/ Connectivity List needed for the STL map
    %  creation
    % total TR arguments ======== !!!!!!!! prosoxi ti tha mpei telika
    % !!!!!!!!! ========

    points = [points_obj; points_ceil2; points_left2; points_right2; points_back2; points_front2; points_gr];
    ConnL = [Cl_obj; ConnL_ceil2; ConnL_left2; ConnL_right2; ConnL_back2; ConnL_front2; ConnL_gr];

end


%% creating the stl file
TR = triangulation(ConnL, points);
filename =  savePlace + object_cell{1}+"_"+num2str(iteration)+".stl";

stlwrite(TR, filename,"binary");
% return argument
map_path = filename;

end