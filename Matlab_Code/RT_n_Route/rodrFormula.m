function Rot = rodrFormula(axis, theta)
%rodrFormula: is a funcion that returns the rotation matrix, based on
%rodrigues formula 
% ==============Arguments=====================
%
%    - axis: axis of rotation
%
%    - theta: angle of rotation
%
% ==============Return=======================
%
%    - Rot: rotation matrix
%% rodrFormula

I = eye(3);
Kappa = [ 0 -axis(3) axis(2); axis(3) 0 -axis(1); -axis(2) axis(1) 0];

Rot = I + sind(theta)*Kappa + (1-cosd(theta))*(Kappa^2);

end