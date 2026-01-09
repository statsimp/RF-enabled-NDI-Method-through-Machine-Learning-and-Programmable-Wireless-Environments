function point = getIntersecPoint(linePoint,direcVec,plane)

%getIntersecPoint: is a function that calculates the point that a line
%intersects with a plane
% 
% ==============Arguments=====================
%
%      - linePoint: a point in the line
%
%      - direcVec: the direction vector of the line
%
%      - plane: the plane that the line intersects with ( "plane" is an array with the parameters:[ A B C D ] )
%
% ==============Return=======================
%
%    - point: the point that a line intersects with a plane
%

v = direcVec;
a = v(1);
b = v(2);
c = v(3);

A = plane(1);
B = plane(2);
C = plane(3);
D = plane(4);

x_0 = linePoint(1);
y_0 = linePoint(2);
z_0 = linePoint(3);

% parametric line argument
t = -( A*x_0 + B*y_0 + C*z_0 + D) / (A*a + B*b + C*c);

x = x_0 + a*t;
y = y_0 + b*t;
z = z_0 + c*t;

point = [x y z];
a=5;
end