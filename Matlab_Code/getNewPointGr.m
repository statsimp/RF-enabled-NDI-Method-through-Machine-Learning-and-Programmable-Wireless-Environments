function newPointGr = getNewPointGr(elementPos, lastTile)
%getNewPointGr: is a funcion that finds the last ground point needed to
%steer the last tile in case of ground intersection
% 
% ==============Arguments=====================
%
%      - elementPos: the position of the array element
%       
%      - lastTile: the center of the last tile
% ==============Return=======================
%
%    - newPointGr: the new point in the ground needed for the routing to
%    room2
%
%% getNewPointGr

% based on the reflection vector formula: r = d-2*dot(d,n)*n we will deduce
% the newPointGR = (x, y, 0) => alpha*(x2-x, y2-y, z2) = (x-x1, y-y1, z1) 

p1 = elementPos;
p2 = lastTile;

alpha = p1(3)/p2(3);

x = (alpha*p2(1) + p1(1))/(1+alpha);
y = (alpha*p2(2) + p1(2))/(1+alpha);


newPointGr = [x, y, 0];

end