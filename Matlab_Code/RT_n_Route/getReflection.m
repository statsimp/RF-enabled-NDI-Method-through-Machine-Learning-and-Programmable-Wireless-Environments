function r = getReflection(n, d)
% getReflection: is a function to return the reflected vector based on specular reflection law.
% ==============Arguments===================
%
%   - n: normal plane vector 
%
%   - d: incident vector
%=============Retutn===========================
%
%   - r: reflected vector

r = d - 2*dot(d,n)*n;

end

