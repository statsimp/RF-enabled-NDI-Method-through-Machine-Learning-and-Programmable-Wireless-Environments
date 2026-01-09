function [tile, test] = getLastTileRay(elementPos, patches, reflVec, usedRIS)
%getLastTileRay: is a funcion that finds the tile that is the last to
%connect the ray routing process to the Rx receiver array element in the
%training phase
% 
% ==============Arguments=====================
%
%      - elementPos: the position of the array element in room2
%
%      - totalDoA: the az, el values corresponding to the resultant wavefront
%      that reaches an element
%
%      - patches: the total set of RISs' positions and labels
%
%      - run: a variable concerning the recursion!
%
% ==============Return=======================
%
%    - tile: the last tile to the ray routing process (label of the tile
%    ). Cell array => {1}: test, wheter is tile or wall/ ground. {2}: tile
%    label, or path.
%
%% getLastTileRay

%total cuboid room dimensions
room_height = 3;
room_length = 8.5;
room_width = 5;

ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

% getting rid of the usedRIS
for i =1:5
    t = (patches{i}(:, end) ~= usedRIS);
    [rows,~] = find(t==0);
    patches{i}(rows,:) = []; 
end


% centers of tiles on each wall
p_Ceil = patches{1};
p_Left = patches{2};
p_Right = patches{3};
p_Back = patches{4};
p_Front = patches{5};

%% calculate the parametric equation of the line of the DoA
% the direction vector
direcVec = reflVec./norm(reflVec);

% a point on the line/ element position
r_0 = [elementPos(1), elementPos(2), elementPos(3)];

%% plane equations
% planes equations that are coated with RIS
planes = [0 0 1 -room_height; % plane ceiling
           1 0 0 room_width/2; % plane left wall
          1 0 0 -room_width/2; % plane right wall
          0 1 0 -room_length/2; % plane back
          0 1 0 room_length/2; % plane front
          0 0 1 0 % plane ground
          ];

%% getting the intersection point for each wall and determine from which wall the ray must arrive

intersecPoints = zeros(length(planes), 3);
ts = zeros(1,6);
for i =1:length(planes)
    [intersecPoints(i,:), ts(i)] = getIntersecPointRay(r_0, direcVec, planes(i,:));
end

%% based on the point find the last tile

pointCeil = intersecPoints(1,:);
pointLeft = intersecPoints(2,:); 
pointRight = intersecPoints(3,:); 
pointBack = intersecPoints(4,:); 
pointFront = intersecPoints(5,:); 
pointGround = intersecPoints(6,:);

if ((pointRight(2) >= -room_length/2) && (pointRight(2) <= room_length/2 )) && ((pointRight(3) >= 0) && (pointRight(3) <= room_height)) && (ts(1) >= 0)
    tile = getClosestRISTrain(pointRight', p_Right);
    %test = testLastRIS(pointRight', tile(1:end-1));
    test=1;
    %disp("Right")
elseif ((pointBack(1) >= -room_width/2)&&(pointBack(1) <= room_width/2))  && ((pointBack(3) >= 0) && (pointBack(3) <= room_height)) && (ts(2) >= 0)
    tile = getClosestRISTrain(pointBack', p_Back);
    %test = testLastRIS(pointBack', tile(1:end-1));
    test=1;
    %disp("Back")
elseif ((pointLeft(2) >= -room_length/2) && (pointLeft(2) <= room_length/2 )) && ((pointLeft(3) >= 0) && (pointLeft(3) <= room_height)) && (ts(3) >= 0)
    tile = getClosestRISTrain(pointLeft', p_Left);
    %test = testLastRIS(pointLeft', tile(1:end-1));
    test=1;
    %disp("Left")
elseif ((pointCeil(1) >= -room_width/2)&&(pointCeil(1) <= room_width/2)) && ((pointCeil(2) >= -room_length/2)&&(pointCeil(2) <= room_length/2)) && (ts(4) >= 0) 
    tile = getClosestRISTrain(pointCeil', p_Ceil);
    %test = testLastRIS(pointCeil', tile(1:end-1));
    test=1;
    %disp("Ceil")
elseif ((pointFront(1) >= -room_width/2)&&(pointFront(1) <= room_width/2))  && ((pointFront(3) >= 0) && (pointFront(3) <= room_height)) && (ts(5) >= 0)
    tile = getClosestRISTrain(pointFront', p_Front);
    %test = testLastRIS(pointFront', tile(1:end-1));
    test=1;
    %disp("Front")
else
    % disp(pointRight);
    % disp(pointBack);
    % disp(pointLeft);
    % disp(pointCeil);
    % disp(pointFront);
    %error("Houston we have a problem... (get last tile ""else"" problem)");
    %disp("Hit the ground");
    %tile = [];
    tile = [pointGround 1];
    test = 0;
    %disp("Ground")
end


end
