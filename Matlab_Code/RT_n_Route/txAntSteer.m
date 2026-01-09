function txangles = txAntSteer( txpos, objPoint)

% % unit vectors in cartesian space
ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];


%% azimuth rotation angle

% Projecting onto a 2D plane for ease

vec_txAz = [txpos(1) txpos(2)]; 
vec_objAz = [objPoint(1) objPoint(2)];

helper = vec_objAz - vec_txAz;
helper = helper./norm(helper);

azimuth = acosd( dot(helper, [1 0]) );

%% elevation rotation angle

diff = objPoint - txpos';
diff = diff./norm(diff);

helper = [helper 0];


elevation = acosd( dot(helper, diff) );

%% return argument/ txangles

txangles = [-azimuth; -elevation];

end


