function d = getOptPathLength(rays)
%getOptPathLength: is a function that returns the total length of the
%optical path, given an array of interaction points
% 
% ==============Arguments=====================
%
%      - rays: array of interaction points
%
% ==============Return=======================
%
%    - d: total length of optical path
%% getOptPathLength

% total interactions for each optical path case
num = size(rays, 1);

% iteratively append the optical path per interaction
sum = 0;
for i = 1:num-1
    v1 = rays(i,:);
    v2 = rays(i+1,:);
    v = v2-v1;
    sum = sum+norm(v);
end

% total final optical path length
d = sum;

end