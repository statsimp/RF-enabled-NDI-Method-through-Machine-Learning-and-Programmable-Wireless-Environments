function newNodeInfo = updateAvoidGraph(nodeInfo1, nodeInfo2, totalNodesUsed)
%updateAvoidGraph: 
% 
% ==============Arguments=====================
%
%    - nodeInfo: 
%
%    - totalNodesUsed:
%
% ==============Return=======================
%
%    - newNodeInfo:
%
%% updateAvoidGraph2

%% palio
% for i =1:numel(nodeInfo)
% 
%     %suc = nodeInfo{i}{2};
%     %pred = nodeInfo{i}{3};
% 
%     [idx1, ~] = find(nodeInfo{i}{2}(:,1) == totalNodesUsed);
% 
%     nodeInfo{i}{2}(idx1,:) = [];
% 
% end
% 
% for i =1:numel(nodeInfo)
% 
%     n = num2cell(nodeInfo{i}{2}(:,1));
%     for i2 = 1:numel(n)
%         n{i2} = num2str(n{i2});
%     end
% 
%     nodeInfo{i} = {nodeInfo{i}{1}, n, nodeInfo{i}{2}(:,2)};
% end
% 
% 
% newNodeInfo = nodeInfo;

%% neo

newNodeInfo = cell(2,1);

[idx1, ~] = find(nodeInfo1{2}(:,1) == totalNodesUsed);
[idx2, ~] = find(nodeInfo2{2}(:,1) == totalNodesUsed);

nodeInfo1{2}(idx1,:) = [];
nodeInfo2{2}(idx2,:) = [];

n1 = num2cell(nodeInfo1{2}(:,1));
for i2 = 1:numel(n1)
    n1{i2} = num2str(n1{i2});
end

n2 = num2cell(nodeInfo2{2}(:,1));
for i3 = 1:numel(n2)
    n2{i3} = num2str(n2{i3});
end

newNodeInfo{1,1} = {nodeInfo1{1}, n1};
newNodeInfo{2,1} = {nodeInfo2{1}, n2};
a=5;
end