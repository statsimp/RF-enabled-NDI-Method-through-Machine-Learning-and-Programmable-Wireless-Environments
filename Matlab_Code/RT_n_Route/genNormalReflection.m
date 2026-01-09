function normalVector = genNormalReflection(prevTile, centTile, afterTile)

%genNormal: is a function that generates the normal vector of a tile, based
%on the two vectors (DoA, DoD) that should be dichotomized,
% 
% ==============Arguments=====================
%
%      - prevTile: previous tile on the ray-routing
%
%      - centTile: the tile that we want to generate the normal vector for
%
%      - afterTile: the tile that comes after in the ray-routing
% ==============Return=======================
%
%    - normalVector: the normal vector of the tile
%

d = centTile - prevTile;
r = afterTile - centTile;

% normalizing the two rays' vectors
d = (d/norm(d)); d = reshape(d, [3 1]);
r = (r/norm(r)); r = reshape(r, [3 1]);

% total angle between r and d ( the incidenct and reflection angles are equal)
theta = acos(dot(-d, r));

% solving for n in r = d - 2*dot(d,n)*n (dot product is the cos() when they are unit vectors)
normalVector = (r-d)/(2*cos(theta/2));
normalVector = normalVector./norm(normalVector);

%normalVector = (r-d)./norm(r-d);
%normalVector = normalVector./norm(normalVector);

end

