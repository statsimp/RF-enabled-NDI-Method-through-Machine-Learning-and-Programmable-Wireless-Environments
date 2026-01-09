function tile = getLastTileGroundTrain( elementPos, pointGround,newDoA, patches, usedRIS, run)

%getLastTile: is a funcion that finds the tile that is the last to
%connect the ray routing process to the Rx receiver array element in room2
% 
% ==============Arguments=====================
%
%      - pointGround: the position of the intesecting point with the ground
%      plane
%
%      - newDoA: the az, el values corresponding to the resultant wavefront
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

%% init


tile = cell(2,1);


%total cuboid room dimensions
room_height = 3;
room_length = 8.5;
room_width = 5;

%ex = [1 0 0];
%ey = [0 1 0];
%ez = [0 0 1];

% getting rid of the usedRIS
for i =1:4
    t = patches{i}(:,end) ~= usedRIS;
    [rows,~] = find(t==0);
    patches{i}(rows,:) = []; 
end


% centers of tiles on each wall
p_Ceil = patches{1};
p_Left = patches{2};
p_Right = patches{3};
p_Back = patches{4};

%% cube stuff
% % Points laying on the planes defining the cube
% objPoint = [ 0 0 0 ];
% meg = 1.25;
% topPoint = objPoint + meg*ez; 
% leftPoint = objPoint - meg/2*ex; 
% rightPoint = objPoint + meg/2*ex; 
% backPoint = objPoint + meg/2*ey; 
% frontPoint = objPoint -meg/2*ey; 
% 
% 
% testValues = {[leftPoint(1) rightPoint(1)], [frontPoint(2) backPoint(2)], [0, topPoint(3)]};
% %testValues = {[0.8 2.3], [1.5 3], [0 1.5]};
% objPlanes = {[topPoint;ez], [leftPoint; ex], [rightPoint; ex], [backPoint; ey], [frontPoint; ey]};
%% calculate the parametric equation of the line of the DoA
% the direction vector

az = newDoA(1); 
el = newDoA(2);

% if ( az == pi/2 || az == -pi/2 || el == pi/2 || el == -pi/2 ) && (run  == 1)
%     error("Houston we have a problem... (ray arriving on bad angles)");
% end

[xx,yy,zz] = sph2cart(az, el, 1);
direcVec = [xx, yy, zz];
direcVec = direcVec./norm(direcVec);

% a point on the line/ element position
r_0 = [pointGround(1), pointGround(2), pointGround(3)];


%% plane equations
% planes equations that are coated with RIS
% planes = [0 0 1 -room_height; % plane ceiling
%           1 0 0 room_width/2; % plane left wall
%           0 1 0 room_length/2; % plane front
%           0 1 0 0.075; % plane wall
%           %-1 0 0 -room_width/2; % plane right wall
%           ];

% planes equations that are coated with RIS
planes = [0 0 1 -room_height; % plane ceiling
           1 0 0 room_width/2; % plane left wall
          1 0 0 -room_width/2; % plane right wall
          0 1 0 -room_length/2; % plane back
          ];
%% getting the intersection point for each wall and determine from which wall the ray must arrive

intersecPoints = zeros(length(planes), 3);

for i =1:length(planes)
    intersecPoints(i,:) = getIntersecPoint(r_0, direcVec, planes(i,:));
end

%% based on the point find the last tile

pointCeil = intersecPoints(1,:);
pointLeft = intersecPoints(2,:); 
pointRight = intersecPoints(3,:); 
pointBack = intersecPoints(4,:); 


if ((pointCeil(1) >= -room_width/2)&&(pointCeil(1) <= room_width/2)) && ((pointCeil(2) >= -room_length/2)&&(pointCeil(2) <= room_length/2)) 
    %tile{1} = {"Τ"};
    lastTile = getClosestRIS(pointCeil', p_Ceil);
    newPointGr = getNewPointGr(elementPos, lastTile);
    tile{2} = {newPointGr, lastTile};

elseif ((pointRight(2) >= -room_length/2) && (pointRight(2) <= room_length/2 )) && ((pointRight(3) >= 0) && (pointRight(3) <= room_height))
    % in that case use recursion and try to find the next tile. Use law of
    %tile{1} = {"Τ"};
    lastTile = getClosestRIS(pointRight', p_Right);
    newPointGr = getNewPointGr(elementPos, lastTile);
    tile{2} = {newPointGr, lastTile};

elseif ((pointLeft(2) >= -room_length/2) && (pointLeft(2) <= room_length/2 )) && ((pointLeft(3) >= 0) && (pointLeft(3) <= room_height))
    %tile{1} = {"Τ"};
    %tile{2} = getClosestRIS(pointLeft', p_Left);
    lastTile = getClosestRIS(pointLeft', p_Left);
    newPointGr = getNewPointGr(elementPos, lastTile);
    tile{2} = {newPointGr, lastTile};

elseif ((pointBack(1) >= -room_width/2)&&(pointBack(1) <= room_width/2))  && ((pointBack(3) >= 0) && (pointBack(3) <= room_height))
    %tile{1} = {"Τ"};
    lastTile = getClosestRIS(pointBack', p_Back);
    newPointGr = getNewPointGr(elementPos, lastTile);
    tile{2} = {newPointGr, lastTile};
    
else

    error("Houston we have a problem... (last tile GROUND ""else"" problem)");
end






end