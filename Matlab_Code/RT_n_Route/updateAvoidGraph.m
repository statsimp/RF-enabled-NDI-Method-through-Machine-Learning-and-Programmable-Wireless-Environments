function newNodeInfo = updateAvoidGraph(nodeInfo1, nodeInfo2, totalNodesUsed)
%updateAvoidGraph: is a function to update the PWE graph for oruting purposes

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
