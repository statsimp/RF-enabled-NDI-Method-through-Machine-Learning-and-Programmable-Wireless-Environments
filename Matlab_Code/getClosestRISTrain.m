function centRIS = getClosestRISTrain(point, patches)
%getClosestRIS: is a funcion that finds the RIS on a specific wall that is
%closest to the intersecting point of departure that reaches the array element with the equivalent DoA 
% 
% ==============Arguments=====================
%
%      - point: the point derived from the getIntersecPoint()
%
%      - patches: the patch centers of the corresponding wall of departure
%
% ==============Return=======================
%
%    - label: the label of the departing tile
%% getClosestRISTrain


dist = patches(:,1:end-1) - point';
dist = vecnorm(dist, 2, 2);

idx = find(dist == min(dist));

centRIS = patches(idx, :);

end