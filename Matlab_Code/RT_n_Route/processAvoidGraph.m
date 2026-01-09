function [Graph, map] = processAvoidGraph(G, avoidTiles)
%function nodeInfo = processAvoidGraph(G, avoidTiles)
%processAvoidGraph: 
% 
% ==============Arguments=====================
%
%    - G: the graph
%
%    - avoidTiles:
%
% ==============Return=======================
%
%    - edgeInfo:
%
%% processAvoidGraph

num = size(avoidTiles,1);
map = containers.Map();

%nodeInfo = cell(num,2);

for i =1:num
    
    % rxLabel = avoidTiles{i}{1};
    % tileLabel = avoidTiles{i}{2};

    rxLabel = avoidTiles{i,1};
    tileLabel = avoidTiles{i,2};

    % b = a{i:end};
    % G = rmedge(G, rxLabel,b);
    % G = rmedge(G, tileLabel,b);
    % % remove the edges between the important nodes
    % idxRem1 = findedge(G,rxLabel, totalNodesUsed);
    % idxRem1 = idxRem1(idxRem1>0);
    % G = rmedge(G, idxRem1);
    % 
    % idxRem2 = findedge(G,tileLabel, totalNodesUsed);
    % idxRem2 = idxRem2(idxRem2>0);
    % G = rmedge(G, idxRem2);
    
    % assign infinity weight to important nodes
    n1 = neighbors(G, rxLabel);
    n2 = neighbors(G, tileLabel);

    idx1 = findedge(G, rxLabel, n1);
    map(rxLabel) = G.Edges.Weight(idx1);
    G.Edges.Weight(idx1)=Inf;

    idx2 = findedge(G, tileLabel, n2);
    map(tileLabel) = G.Edges.Weight(idx2);
    G.Edges.Weight(idx2)=Inf;

    % for i3 = 1:numel(n1)
    %     n1{i3} = str2num(n1{i3});
    % end
    % n1= cell2mat(n1);
    % 
    % for i4 = 1:numel(n2)
    %     n2{i4} = str2num(n2{i4});
    % end
    % n2 = cell2mat(n2);

    
    % nodeInfo{i,1} = {rxLabel, n1};
    % nodeInfo{i,2} = {tileLabel, n2};
    
end
Graph = G;
end