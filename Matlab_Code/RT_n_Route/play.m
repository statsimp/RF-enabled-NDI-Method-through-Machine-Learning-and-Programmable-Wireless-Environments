function vertices = vertices(p, n, len, wid, wall)

% vertices -- is a function to calculate the four vetrices of a rectangle using a
% point of a plane and a normal vector
% 
% Arguments
% 
%  - p: the point of the plane ( center of the rectangle )
%  - n: the normal vector to the plane
%  - len: length of the rectangle
%  - wid: width of the patch
%  - wall: which wall the patch is attached so we have the right
%  orientation



% creating the unit vector of the normal vector
n = n./norm(n);

% normal vector cartesian to spherical

phi  = atand(n(2)/n(1));
theta = atand( sqrt(n(1)^2+n(2)^2) /n(3));


ex = [1, 0, 0];
ey = [0, 1, 0];
ez = [0, 0 ,1];


% defining the original vector vertices, they will be rotated
if wall == "left" | wall == "right"
    
    v1 = [0,0,0] + wid/2*ey + len/2*ez;
    v2 = [0,0,0] + wid/2*ey - len/2*ez;
    v3 = [0,0,0] - wid/2*ey + len/2*ez;
    v4 = [0,0,0] - wid/2*ey - len/2*ez;
end

if wall == "back" | wall == "front"
    v1 = [0,0,0] + wid/2*ex + len/2*ez;
    v2 = [0,0,0] + wid/2*ex - len/2*ez;
    v3 = [0,0,0] - wid/2*ex + len/2*ez;
    v4 = [0,0,0] - wid/2*ex - len/2*ez;
end

if wall == "ceiling"
    v1 = [0,0,0] + wid/2*ex + len/2*ey;
    v2 = [0,0,0] + wid/2*ex - len/2*ey;
    v3 = [0,0,0] - wid/2*ex + len/2*ey;
    v4 = [0,0,0] - wid/2*ex - len/2*ey;

end

% defining the matrix to contain the vertices
vertices = [v1.' v2.' v3.' v4.'];


if not(n == ex) & not(n == -ex) & not(n == -ey) & not(n == -ez)
    % rotation matrices
    Rz = rotz(phi);
    Rx = rotx(theta);
    R = Rx*Rz;
    
    % the real vertices needed   
    vertices = R*vertices;
end

v= zeros(3,4);

for i=1:4
    v(:,i) = vertices(:,i)+p.'; 
end

vertices = v;
end