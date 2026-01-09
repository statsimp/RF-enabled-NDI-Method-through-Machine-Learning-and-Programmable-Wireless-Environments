function [paths, maxReflections] = getPathsWF(G, lastConn, objPoints, patches_Mat, DoA, label_SDM)
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


num = numel(lastConn);
paths = cell(num,1);

% the positions of array elements on room1
rx_pos1 = label_SDM;

totalNodesUsed = [];
% put an "A" in front of every variable name for debugging
avoidTiles = cell(num-1,1);
for iter =1:num
    % % finding the label of the rx_pos(i)
    % Amembers = ismembertol( patches_Mat(:,end), rx_pos1(iter),"Byrows", 10^-4);
    % AidxRxPos = find(Amembers);
    % AlabelRxPos = num2str( patches_Mat(AidxRxPos,end) ); % node name of the rx_pos(i)
    % totalNodesUsed = [totalNodesUsed patches_Mat(AidxRxPos,end)];
    AlabelRxPos = num2str( rx_pos1(iter) ); % node name of the rx_pos(i)
    totalNodesUsed = [totalNodesUsed rx_pos1(iter)];

    % finding the label of the last tile
    AlastTile = lastConn{iter}(2,:);
    Amembers = ismembertol( patches_Mat(:,1:end-1), AlastTile,"Byrows", 10^-4);
    AidxLastTile = find(Amembers);
    AlabelLastTile = num2str( patches_Mat(AidxLastTile,end) ); % node name of the last tile
    totalNodesUsed = [totalNodesUsed patches_Mat(AidxLastTile,end)];

    avoidTiles{iter} = {AlabelRxPos , AlabelLastTile};

end

% acquire information about the temporarily deleted nodes of the graph
tic;
nodeInfo = processAvoidGraph(G, avoidTiles);
toc;
% temporarily delete the significant nodes
tic;
for epanal = 1:numel(avoidTiles)
    G = rmnode(G, avoidTiles{epanal});
end
toc;

totalNodesUsed = totalNodesUsed(3:end);

for i =1:num
    % update the node information about connections, by taking into
    % cosnideration the total used nodes
    tic;
    newNodeInfo = updateAvoidGraph(nodeInfo{i,1}, nodeInfo{i,2}, totalNodesUsed);

    G = addedge(G,newNodeInfo{1}{1},newNodeInfo{1}{2});
    toc;
    tic;
    G = addedge(G,newNodeInfo{2}{1},newNodeInfo{2}{2});
    toc;
    
    if ismultigraph(G)
        G = simplify(G);
    end

    % finding the label of the rx_pos(i)
    % members = ismembertol( patches_Mat(:,1:end-1), rx_pos1(:,i)',"Byrows", 10^-4);
    % idxRxPos = find(members);
    % labelRxPos = num2str( patches_Mat(idxRxPos,end) ); % node name of the rx_pos(i)
    labelRxPos = num2str(rx_pos1(i));

    % finding the label of the last tile
    lastTile = lastConn{i}(2,:);
    members = ismembertol( patches_Mat(:,1:end-1), lastTile,"Byrows", 10^-4);
    idxLastTile = find(members);
    labelLastTile = num2str( patches_Mat(idxLastTile,end) ); % node name of the last tile
    
    % get subgraph in order to reduce running time
    %H = getSubGraph(G, labelRxPos, labelLastTile);    
    % getting the shortest path
    tic;
    P = shortestpath(G, {labelRxPos}, {labelLastTile});
    toc;
    % total, so far, used nodes
    totalNodesUsed = addNodesUsed(totalNodesUsed, P);

    % updating the connection graph by removing the paths
    G = rmnode(G, P);
    
    % making the cell array containing the names of the RIS labels into an
    % array of the labels
    for j = 1:numel(P)
        P{j} = str2num(P{j});
    end
    P = cell2mat(P);
    
    % creating the path with the tile centers
    
    % "going" from "label-paths" to "center-paths" ( original variable "P"
    % contains the path in labels )
    temp_path = [];
    for k =1:numel(P)
        label = P(k);
        melos = ismembertol( patches_Mat(:,end), label,"Byrows", 10^-4);
        index = find(melos);
        temp_path = [temp_path; patches_Mat(index,1:end-1)];
    end

    % create the last row that will contain an arbitrary point in the
    % direction of the equivalent DoA. So that the equivalent wavefront of
    % room1 can be routed to room2;
    % vec = zeros(1,3);
    % az = deg2rad(run1Rays(i).AngleOfArrival(1));
    % el = deg2rad(run1Rays(i).AngleOfArrival(2));
    % [vec(1),vec(2),vec(3)] = sph2cart( az, el, 1); 
    % vec = vec./norm(vec);
    % members = ismembertol( patches_Mat(:,end), rx_pos1(i),"Byrows", 10^-4);
    % idxRxPos = find(members);
    % RxPos = patches_Mat(idxRxPos,1:end-1); % node name of the rx_pos(i)
    % arbitraryPoint = RxPos + 2*vec;
    arbitraryPoint = objPoints(i,:);


    paths{i} = [arbitraryPoint; temp_path; lastConn{i}(1,:)];
    %a=5;
end

% get maxReflections
arithmosMonopatiou = [];
for jj = 1:numel(paths)
    arithmosMonopatiou = [arithmosMonopatiou length(paths{jj})];
end

maxReflections = max(arithmosMonopatiou) - 2;

end

