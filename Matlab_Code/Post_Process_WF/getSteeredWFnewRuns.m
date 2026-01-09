function wf = getSteeredWFnewRuns(rayPaths, freq)
% getSteeredWFnewRuns: based on the results stemming from the mainSteering
% the rays paths are transformed to received wavefront
% 
% ==============Arguments=====================
%
%      - rayPaths: the paths of rays, returned by mainSteering
%
%      - freq: frequency of operation
%
% ==============Return=======================
%
%    - wf: the final received wavefront at the receiver

%% getSteeredWFnewRuns


num = numel(rayPaths);
azimuths = zeros(num,1);
elevations = zeros(num,1);
pathloss = zeros(num, 1);
phase = zeros(num,1);
for i=1:num

    % get the number of receiving rays per antenna and init the eq
    paths = rayPaths{i};
    numOfRays = numel(paths);
    Rays = zeros(numOfRays, 4);

    if numOfRays ~= 0
        for j=1:numOfRays
    
            path = paths{j}; % get the j-th path
            d= getOptPathLength(path); % get optical path length per routing
        
            pl = FSPL(d, freq); % calculate the path-loss of the j-th path
            df = wrapToPi(pathPhaseDiff(d, freq)); % calculate the phase difference of the j-th path
            
            % calculate the AoA of the j-th path
            AoA = path(end-1,:) - path(end,:);
            AoA = AoA./norm(AoA);
            [az, el, ~] = cart2sph(AoA(1), AoA(2), AoA(3));
            
            Rays(j, :) = [pl, df, az, el];
            eqRay = getEqRay(Rays);
        end
        
        
        % update the equivalent info per antenna
        azimuths(i) = eqRay(1);
        elevations(i) = eqRay(2);
        pathloss(i) = eqRay(3);
        phase(i) = eqRay(4);

    else
        % update the equivalent info per antenna
        azimuths(i) = 0;
        elevations(i) = 0;
        pathloss(i) = 0;
        phase(i) = 0;
    end


end

% return the final estimated wavefront at the receiver
wf = [azimuths, elevations, pathloss, phase];

end