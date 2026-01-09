function wf = getReceivingWFnewRuns(rays, DoA, freq)
%getReceivingWFnewRuns: is a function that returns the total receiving wavefront at RX, 
% that contains info regarding the encoded DoA info, plus path loss, plus phase difference
% 
% ==============Arguments=====================
%
%      - r: return argument of "mainWF_newRuns", which contains the routing info,
%      e.g. paths, normals etc.
%
%      - rays: array of interaction points
%
%      - DoA: encoded DoA information
%
%      - freq: frequency of operation
%
% ==============Return=======================
%
%    - wf: total receiving wavefront at RX, that contains info
%    regarding the encoded DoA info, plus path loss, plus phase difference
%
%% getReceivingWFnewRuns


paths = rays{1}; % access the paths of the ray-routing
initPoints = rays{end};

num = numel(paths);


pls = zeros(1,num); % init path loss
dfs = zeros(1,num); % init phase differences
for i = 1:num
    
    interactions = [initPoints{i}; paths{i}];
    d= getOptPathLength(interactions); % get optical path length per routing
    
    pls(i) = FSPL(d, freq);
    dfs(i) = wrapToPi(pathPhaseDiff(d, freq));
end



wf = [DoA, pls, dfs]; % return the receiving final wavefront

end