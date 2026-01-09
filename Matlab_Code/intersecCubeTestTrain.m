function bool = intersecCubeTestTrain(l0, l1, planes, testValues)

% intersecCubeTest: is a funcion that takes two center tiles of room1 as inputs and test whether the line connecting them
% intersects with the cube encapsulating the object.
% 
% ==============Arguments=====================
%
%    - p1: point one
%
%    - p2: point two
%
%    - planes: planes to test the intersection with
%
% ==============Return=======================
%
%    - bool: 1 if it intersects with the cube, 0 if not

%% intersecCubeTest


bool = 0;

% parametric line arguments
v = l1-l0;

% planes' coefficients

p1 = planes{1}(1,:);
n1 = planes{1}(2,:);

p2 = planes{2}(1,:);
n2 = planes{2}(2,:);

p3 = planes{3}(1,:);
n3 = planes{3}(2,:);

p4 = planes{4}(1,:);
n4 = planes{4}(2,:);

p5 = planes{5}(1,:);
n5 = planes{5}(2,:);

% parametric line argument "t"
t1 = dot(p1 - l0, n1)/dot(v,n1);

t2 = dot(p2 - l0, n2)/dot(v,n2);

t3 = dot(p3 - l0, n3)/dot(v,n3);

t4 = dot(p4 - l0, n4)/dot(v,n4);

t5 = dot(p5 - l0, n5)/dot(v,n5);

% intersection points

int1 = l0 + v*t1;

int2 = l0 + v*t2;

int3 = l0 + v*t3;

int4 = l0 + v*t4;

int5 = l0 + v*t5;

% test whether there are any instersection points with every wall plane

% test values for the planes defining the "encapsulating-cube"
xL = testValues{1}(1); % x-left
xR = testValues{1}(2); % x-right

yF = testValues{2}(1); % y-front
yB = testValues{2}(2); % y-back

zG = 0; % z-ground
zT = testValues{3}(2); % z-top

%% do some stuff for floating points and "<=" comparison operator

xL = round(xL, 7);
int1(1) = round(int1(1), 7);
int4(1) = round(int4(1), 7);
int5(1) = round(int5(1), 7);

yF = round(yF, 7);
int1(2) = round(int1(2),7);
int2(2) = round(int2(2),7);
int3(2) = round(int3(2),7);
%% test
if ((xL <= int1(1)) && (int1(1) <= xR )) && ((yF <= int1(2)) && (int1(2) <= yB))
    bool = 1;
end

if ((yF <= int2(2)) && (int2(2) <= yB)) && ((zG <= int2(3) ) && (int2(3) <= zT))
    bool=1;
    return
end

if ((yF <= int3(2)) && (int3(2) <= yB)) && ((zG <= int3(3)) && (int3(3) <= zT))
    bool=1;
    return
end

if ((xL <= int4(1)) && (int4(1) <= xR)) && ((zG <= int4(3)) && (int4(3) <= zT))
    bool=1;
    return
end

if ((xL <= int5(1)) && (int5(1) <= xR)) && ((zG <= int5(3)) && (int5(3) <= zT))
    bool=1;
    return
end

% test1 = (((xL <= int1(1)) && (int1(1) <= xR )) && ((yF <= int1(2)) && (int1(2) <= yB)));
% test2 = (((yF <= int2(2)) && (int2(2) <= yB)) && ((zG <= int2(3) ) && (int2(3) <= zT)));
% test3 = (((yF <= int3(2)) && (int3(2) <= yB)) && ((zG <= int3(3)) && (int3(3) <= zT)));
% test4 = (((xL <= int4(1)) && (int4(1) <= xR)) && ((zG <= int4(3)) && (int4(3) <= zT)));
% test5 = (((xL <= int5(1)) && (int5(1) <= xR)) && ((zG <= int5(3)) && (int5(3) <= zT)));
% 
% bool = test1 || test2 || test3 || test4 || test5;

%a=5;

end