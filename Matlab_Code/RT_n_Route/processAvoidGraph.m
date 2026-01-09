function [Graph, map] = processAvoidGraph(G, avoidTiles)
%processAvoidGraph: a function to help avoid certain nodes in the graph routing
%

num = size(avoidTiles,1);
map = containers.Map();

for i =1:num
    

    rxLabel = avoidTiles{i,1};
    tileLabel = avoidTiles{i,2};


    
    % assign infinity weight to important nodes
    n1 = neighbors(G, rxLabel);
    n2 = neighbors(G, tileLabel);

    idx1 = findedge(G, rxLabel, n1);
    map(rxLabel) = G.Edges.Weight(idx1);
    G.Edges.Weight(idx1)=Inf;

    idx2 = findedge(G, tileLabel, n2);
    map(tileLabel) = G.Edges.Weight(idx2);
    G.Edges.Weight(idx2)=Inf;

    
end
Graph = G;

end
