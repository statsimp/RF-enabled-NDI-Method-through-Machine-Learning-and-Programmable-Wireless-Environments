function G = genRISGraphTrain( patches )

%genRISGraphRX: is a funcion that generates the graph that corresponds to the RIS LoS connections
% 
% ==============Arguments=====================
%
%    - patches: the patches generated in map_generator
%
%    - usedRIS: the labels array of the RIS that are used in the first run,
%    where the conf is for the radiation reaching Rx receiver in room1
%
%    - lenTile: the length of each tile in the map
%
%    -widTile: the width of each tile in the map
%
% ==============Return=======================
%
%    - G: the graph that corresponds to the RIS LoS connections
%
%    - patches: the total RISs' center position and the label
%
%
%% initialize the space dimensions, height/ length/ width of the room and other variables, 
% number of patches on the horizontal and vertical axis
 
% % unit vectors in cartesian space
ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

room_height = 3;
room_length = 8.5;
room_width = 5;


% get the tiles' centers
p_Ceil = patches{1};
p_Left = patches{2};
p_Right = patches{3};
p_Back = patches{4};
p_Front = patches{5};

% acquring the tile centers for each room
room1 = {p_Ceil, p_Left, p_Right, p_Back, p_Front};
%room2 = {p_Ceil(p_Ceil(:,2)<0, :), p_Left(p_Left(:,2)<0, :), p_Right(p_Right(:,2)<0, :), p_Front, p_room2div};

num = length(p_Ceil) + length(p_Left) + length(p_Right) +length(p_Back) +length(p_Front);
AdjMatrix = zeros(num,num);
%% Set the graph edges for the tiles in the same room 

% creating the resultant connection graph after removing the RIS connection
% edges for the tiles in room1 that intersect with the object.
objPoint = [ 0 0 0 ]; % point where the object is centered

% create the "object-defining" planes (cube encapsulating the object)
% each side is 1.5m.
% Points laying on the planes defining the cube
meg = 1.25;
topPoint = objPoint + meg*ez; 
leftPoint = objPoint - meg/2*ex; 
rightPoint = objPoint + meg/2*ex; 
backPoint = objPoint + meg/2*ey; 
frontPoint = objPoint -meg/2*ey; 


testValues = {[leftPoint(1) rightPoint(1)], [frontPoint(2) backPoint(2)], [0, topPoint(3)]};
%testValues = {[0.8 2.3], [1.5 3], [0 1.5]};
objPlanes = {[topPoint;ez], [leftPoint; ex], [rightPoint; ex], [backPoint; ey], [frontPoint; ey]};
tic;
v = 1:5;
toixos = 0;
SDM = 0;
for i = v
    %otherWalls = v(v~=i);
    otherWalls = v(v>i);
    [rows1I,~] = size(room1{i});
    for index1Tile1 = 1:rows1I
        %l = zeros(num,1);
        for iter1Wall = otherWalls
            [rows1IterWall,~] = size(room1{iter1Wall});
            for index1Tile2 = 1:rows1IterWall

                point11 = room1{i}(index1Tile1,:);
                point12 = room1{iter1Wall}(index1Tile2,:);
                label1_1 = int16(point11(end));
                label1_2 = int16(point12(end));
                
                test = intersecCubeTestTrain(point11(1:end-1), point12(1:end-1), objPlanes, testValues);
                dist = norm(point11(1:end-1) - point12(1:end-1));
                AdjMatrix(label1_1, label1_2) =(1-test)*dist; % if test==0, then there is no intersection so 1-test = 1, else 1-test = 0
                AdjMatrix(label1_2, label1_1) =(1-test)*dist;

            end
        end
        disp(SDM)
        SDM = SDM+1;
    end
    disp(toixos)
    toixos = toixos+1;
end  


toc;

% if ismultigraph(G)
%     G = simplify(G);
% end

%% creating the original connection graph
nodeNames = 1:num;
nodeNames = num2cell(nodeNames);
for iteration =1:numel(nodeNames)
    nodeNames{iteration} = num2str(nodeNames{iteration});
end

%G.Nodes.Name = nodeNames';

%% patchesWeight: the matrix containing the tile centers and the labels and normal vectors
% normCeil = zeros(length(p_Ceil),3);
% normCeil(:,3) = -1;
% 
% normLeft = zeros(length(p_Left),3);
% normLeft(:,1) = 1;
% 
% normRight = zeros(length(p_Right),3);
% normRight(:,1) = -1;
% 
% normBack = zeros(length(p_Back),3);
% normBack(:,2) = -1;
% 
% normFront = zeros(length(p_Front),3);
% normFront(:,2) = 1;
% 
% normRoom1Div = zeros(length(p_room1div),3);
% normRoom1Div(:,2) = 1;
% 
% normRoom2Div = zeros(length(p_room2div),3);
% normRoom2Div(:,2) = -1;
% 
% patchesWeight = [p_Ceil normCeil; p_Left normLeft; p_Right normRight; p_Back normBack; p_Front normFront; p_room1div normRoom1Div; p_room2div normRoom2Div];


%% create the graph
G = graph(AdjMatrix, nodeNames);
% G = digraph(AdjMatrix, nodeNames);
%G = addGraphWeights(G, patchesWeight);

% % % creating the resultant connection graph after removing the RIS used in
% % % run=1
% tic;
% usedRIS = num2cell(usedRIS);
% parfor iteration =1:numel(usedRIS)
%     usedRIS{iteration} = num2str(usedRIS{iteration});
% end
% G = rmnode(G, usedRIS);
% toc;

a=5;

end
