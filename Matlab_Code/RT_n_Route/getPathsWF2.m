function [paths, initPoints, maxReflections] = getPathsWF2(G, lastConn, objPoints, patches_Mat, label_SDM, txs)
%getPathsTrain: a function to acquire the path of the ray-routing process 
% corresponding to each rx array element
% 
% ==============Arguments=====================
%
%      - G: the RIS connectivity graph
%
%      - last_Tiles: the last tiles in the ray-routing process
%
%      - rx_pos: the positions of the rx receiver array elements on both
%      rooms
%
% ==============Return=======================
%
%    - path: the path of the ray-routing process corresponding to each rx array
%    element

% set the graph edges weights
% numEdges = numedges(G);
% weights = ones(numEdges,1);
% G.Edges.Weight = weights;

num = numel(lastConn);
paths = cell(num,1);
initPoints = cell(num,1);

% the positions of array elements on room1
rx_pos1 = label_SDM;

%totalNodesUsed = {};
% put an "A" in front of every variable name for debugging
avoidTiles = cell(num,2);
for iter =1:num
    % % finding the label of the rx_pos(i)
    % Amembers = ismembertol( patches_Mat(:,end), rx_pos1(iter),"Byrows", 10^-4);
    % AidxRxPos = find(Amembers);
    % AlabelRxPos = num2str( patches_Mat(AidxRxPos,end) ); % node name of the rx_pos(i)
    % totalNodesUsed = [totalNodesUsed patches_Mat(AidxRxPos,end)];
    AlabelRxPos = num2str( rx_pos1(iter) ); % node name of the rx_pos(i)
    avoidTiles{iter,1} = AlabelRxPos ;
    %numer = numer+1;
    %totalNodesUsed{length(totalNodesUsed)+1} = [totalNodesUsed rx_pos1(iter)];
    %totalNodesUsed{length(totalNodesUsed)+1} = num2str(rx_pos1(iter));

    % finding the label of the last tile
    AlastTile = lastConn{iter}(2,:);
    Amembers = ismembertol( patches_Mat(:,1:end-1), AlastTile,"Byrows", 10^-4);
    AidxLastTile = find(Amembers);
    AlabelLastTile = num2str( patches_Mat(AidxLastTile,end) ); % node name of the last tile
    avoidTiles{iter,2} = AlabelLastTile ;
    %numer = numer+1;
    %totalNodesUsed = [totalNodesUsed patches_Mat(AidxLastTile,end)];
    %totalNodesUsed{length(totalNodesUsed)+1} = num2str(patches_Mat(AidxLastTile,end));

    %avoidTiles{iter} = {AlabelRxPos , AlabelLastTile};

end

% acquire information about the temporarily deleted nodes of the graph
[G, map] = processAvoidGraph(G, avoidTiles);
% temporarily delete the significant nodes

%totalNodesUsed = totalNodesUsed(3:end);
a = reshape(avoidTiles, 2*num,1);

for i =1:num
    
    % update the node information about connections, by taking into
    % cosnideration the total used nodes
    rxLabel = avoidTiles{i,1};
    tileLabel = avoidTiles{i,2};
    
    n1 = neighbors(G, rxLabel);
    n2 = neighbors(G, tileLabel);

    idx1 = findedge(G, rxLabel, n1);
    G.Edges.Weight(idx1)=map(rxLabel);
    idx11 = findedge(G, rxLabel, a);
    idx11 = idx11(idx11>0);
    G.Edges.Weight(idx11)=Inf;
    
    idx2 = findedge(G, tileLabel, n2);
    G.Edges.Weight(idx2)=map(tileLabel);
    idx22 = findedge(G, tileLabel, a);
    idx22 = idx22(idx22>0);
    G.Edges.Weight(idx22)=Inf;

    % finding the label of the rx_pos(i)
    labelRxPos = num2str(rx_pos1(i));

    % finding the label of the last tile
    lastTile = lastConn{i}(2,:);
    members = ismembertol( patches_Mat(:,1:end-1), lastTile,"Byrows", 10^-4);
    idxLastTile = find(members);
    labelLastTile = num2str( patches_Mat(idxLastTile,end) ); % node name of the last tile


    % getting the shortest path
    P = shortestpath(G, {labelRxPos}, {labelLastTile}, "Method", "positive");

    % updating the connection graph by removing the paths
    %G = rmnode(G, P);

    
    %add the path nodes to "ignore me"
    for pp=1:length(P)-2
        a = [a; P{2+pp}];
    end
    
    for aporipsi=1:length(P)-2
        neigh = neighbors(G, P{aporipsi+1});
        idxApor = findedge(G, P{aporipsi+1}, neigh);
        G.Edges.Weight(idxApor) = Inf;
    end
    % reset the important nodes weights to "ignore me"
    G.Edges.Weight(idx1)=Inf;
    G.Edges.Weight(idx2)=Inf;
    


    % making the cell array containing the names of the RIS labels into an
    % array of the labels
    for j = 1:numel(P)
        P{j} = str2double(P{j});
    end
    P = cell2mat(P);
    % creating the path with the tile centers
    
    % "going" from "label-paths" to "center-paths" ( original variable "P"
    % contains the path in labels )
    temp_path = zeros(numel(P), 3);
    for k =1:numel(P)
        label = P(k);
        melos = ismembertol(patches_Mat(:,end), label,"Byrows", 10^-4);
        index = find(melos);
        temp_path(k,:) = patches_Mat(index,1:end-1);
    end

    % create the last row that will contain an arbitrary point in the
    % direction of the equivalent DoA. So that the equivalent wavefront of
    % room1 can be routed to room2;
    arbitraryPoint = objPoints(i,:);

    paths{i} = [arbitraryPoint; temp_path; lastConn{i}(1,:)];
    initPoints{i} = txs(i,:);
end

% get maxReflections
arithmosMonopatiou = zeros(numel(paths),1);
for jj = 1:numel(paths)
    arithmosMonopatiou(jj,:) = length(paths{jj});
end

maxReflections = max(arithmosMonopatiou) - 2;

end

