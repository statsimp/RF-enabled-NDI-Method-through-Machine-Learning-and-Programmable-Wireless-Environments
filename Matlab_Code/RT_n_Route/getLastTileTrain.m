function tile = getLastTileTrain(elementPos,totalDoA, patches, usedRIS, run)

%getLastTileTrain: is a funcion that finds the tile that is the last to
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


tile = cell(2,1);


%total cuboid room dimensions
room_height = 3;
room_length = 8.5;
room_width = 5;

ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

% getting rid of the usedRIS
for i =1:4
    t = (patches{i}(:,end) ~= usedRIS);
    [rows,~] = find(t==0);
    patches{i}(rows,:) = []; 
end


% centers of tiles on each wall
p_Ceil = patches{1};
p_Left = patches{2};
p_Right = patches{3};
p_Back = patches{4};

%% cube stuff
% Points laying on the planes defining the cube
objPoint = [ 0 0 0 ];
meg = 1.25;
topPoint = objPoint + meg*ez; 
leftPoint = objPoint - meg/2*ex; 
rightPoint = objPoint + meg/2*ex; 
backPoint = objPoint + meg/2*ey; 
frontPoint = objPoint -meg/2*ey; 


testValues = {[leftPoint(1) rightPoint(1)], [frontPoint(2) backPoint(2)], [0, topPoint(3)]};
%testValues = {[0.8 2.3], [1.5 3], [0 1.5]};
objPlanes = {[topPoint;ez], [leftPoint; ex], [rightPoint; ex], [backPoint; ey], [frontPoint; ey]};

%% calculate the parametric equation of the line of the DoA
% the direction vector

az = totalDoA(1); 
el = totalDoA(2);

if ( az == pi/2 || az == -pi/2 || el == pi/2 || el == -pi/2 ) && (run  == 1)
    error("Houston we have a problem... (ray arriving on bad angles)");
end

az = deg2rad(az);
el = deg2rad(el);
[xx,yy,zz] = sph2cart(az, el, 1);
direcVec = [xx, yy, zz];
direcVec = direcVec./norm(direcVec);

% a point on the line/ element position
r_0 = [elementPos(1), elementPos(2), elementPos(3)];


%% plane equations
% planes equations that are coated with RIS
planes = [0 0 1 -room_height; % plane ceiling
           1 0 0 room_width/2; % plane left wall
          1 0 0 -room_width/2; % plane right wall
          0 1 0 -room_length/2; % plane back
          0 0 1 0 % plane ground
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
pointGround = intersecPoints(5,:); 

if ((pointRight(2) >= -room_length/2) && (pointRight(2) <= room_length/2 )) && ((pointRight(3) >= 0) && (pointRight(3) <= room_height))
    foundPoint = getClosestRISTrain(pointRight', p_Right);
    test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    while test == 1
        t = (p_Right(:,end) ~= foundPoint(end));
        [rows,~] = find(t==0);
        p_Right(rows,:) = [];
        foundPoint = getClosestRISTrain(pointRight', p_Right);
        test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    end
    tile{1} = 1;
    tile{2} = {elementPos, foundPoint(1:end-1)};
elseif ((pointBack(1) >= -room_width/2)&&(pointBack(1) <= room_width/2))  && ((pointBack(3) >= 0) && (pointBack(3) <= room_height))
    foundPoint = getClosestRISTrain(pointBack', p_Back);
    test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    while test == 1
        t = (p_Back(:,end) ~= foundPoint(end));
        [rows,~] = find(t==0);
        p_Back(rows,:) = [];
        foundPoint = getClosestRISTrain(pointBack', p_Back);
        test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    end
    tile{1} = 1;
    tile{2} = {elementPos, foundPoint(1:end-1)};
elseif ((pointLeft(2) >= -room_length/2) && (pointLeft(2) <= room_length/2 )) && ((pointLeft(3) >= 0) && (pointLeft(3) <= room_height))
    foundPoint = getClosestRISTrain(pointLeft', p_Left);
    test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    while test == 1
        t = (p_Left(:,end) ~= foundPoint(end));
        [rows,~] = find(t==0);
        p_Left(rows,:) = [];
        foundPoint = getClosestRISTrain(pointLeft', p_Left);
        test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    end
    tile{1} = 1;
    tile{2} = {elementPos, foundPoint(1:end-1)};
elseif ((pointCeil(1) >= -room_width/2)&&(pointCeil(1) <= room_width/2)) && ((pointCeil(2) >= -room_length/2)&&(pointCeil(2) <= room_length/2))  
    foundPoint = getClosestRISTrain(pointCeil', p_Ceil);
    test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    while test == 1
        t = (p_Ceil(:,end) ~= foundPoint(end));
        [rows,~] = find(t==0);
        p_Ceil(rows,:) = [];
        foundPoint = getClosestRIS(pointCeil', p_Ceil);
        test = intersecCubeTestTrain(foundPoint(1:end-1), elementPos, objPlanes, testValues);
    end
    tile{1} = 1;
    tile{2} = {elementPos, foundPoint(1:end-1)};
elseif ((pointGround(1) >= -room_width/2) && (pointGround(1) <= room_width/2)) && ( (pointGround(2) >= -room_length/2) && (pointGround(2) <= room_length/2)) 
    % in that case use recursion and try to find the next tile. Use law of
    % reflection for the new DoA and as elementPos is the pointWall
    elementPos = reshape(elementPos, 1,3);
    pointGround = reshape(pointGround,1,3);
    % d = (elementPos - pointGround)./norm(elementPos - pointGround);
    % normalGround = ez;
    % newDoA = getNewDoA(-d, normalGround);

    vec = (elementPos - pointGround)./norm(elementPos - pointGround);
    cosine = dot(vec, ez);
    theta = acosd(cosine);
    axis = cross(vec, ez);
    axis = axis./norm(axis);

    vec = (pointGround - elementPos)./norm(pointGround - elementPos);
    vec = reshape(vec, 3,1);
    U = rodrFormula(axis, 2*theta);
    rot = U*vec;
    [az, el, ~] = cart2sph(rot(1), rot(2), rot(3));
    newDoA = [az, el];

    newTile = getLastTileGroundTrain(elementPos, pointGround, newDoA, patches, usedRIS, run+1);
    newPointGr = newTile{2}{1};
    lastTile = newTile{2}{2};
    test1 = intersecCubeTestTrain(newPointGr, elementPos, objPlanes, testValues);
    test2 = intersecCubeTestTrain(lastTile, newPointGr, objPlanes, testValues);

    transIter = 1;
    while not( ((test1 == 0) && (test2 == 0)) )

        pointGround = translatePointGr(newPointGr, ey, ex, transIter);

        elementPos = reshape(elementPos, 1,3);
        pointGround = reshape(pointGround,1,3);

        vec = (elementPos - pointGround)./norm(elementPos - pointGround);
        cosine = dot(vec, ez)/(norm(vec)*norm(ez));
        theta = acosd(cosine);
        axis = cross(vec, ez);
        axis = axis./norm(axis);
    
        vec = (pointGround - elementPos)./norm(pointGround - elementPos);
        vec = reshape(vec, 3,1);
        U = rodrFormula(axis, theta);
        rot = U*vec;
        [az, el, ~] = cart2sph(rot(1), rot(2), rot(3));
        newDoA = [az, el];
    
        newTile = getLastTileGroundTrain(elementPos, pointGround, newDoA, patches, usedRIS, run+1);
        newPointGr = newTile{2}{1};
        lastTile = newTile{2}{2};
        test1 = intersecCubeTestTrain(newPointGr, elementPos, objPlanes, testValues);
        test2 = intersecCubeTestTrain(lastTile, newPointGr, objPlanes, testValues);

        transIter = transIter + 1;
    end
    tile{1} = 2;
    tile{2} = newTile{2};

else
    disp(pointCeil);
    disp(pointFront);
    disp(pointWall);
    disp(pointLeft);
    disp(pointGround);
    error("Houston we have a problem... (get last tile ""else"" problem)");

end



end

