function DoA = getInvDoA( pwe, rxDim, recSide, r)
% getInvDoA: is a function to return the the mapped angles of the wavefront encoding/ decoding
% based on the f, g functions ( "cdf approach" of the PWE characteristics )
%


% pre-process
[rxPoints, ~, ~, ~]= getRXpointsTrain(rxDim, recSide);
angles = exctractDoA(r, rxPoints);

% init the wf values
numRx = numel(pwe);
DoA = zeros(2, numRx);
% vector = wf(row,:);
% vector = vector(1:end/2);
% v1 = vector(1:end/2);
% v2 = vector(end/2+1:end);

[ECDFs_az, ECDFs_el] = getCDFs2(pwe, -2);

% Function to map wf to angles
num = numRx;
mapped_azWF = zeros(num,1);
mapped_elWF = zeros(num,1);
for i = 1:num
    mapped_azWF(i) = interp1(ECDFs_az{i}(:,1), ECDFs_az{i}(:,2), angles(i,1), 'linear', 'extrap');
    mapped_elWF(i) = interp1(ECDFs_el{i}(:,1), ECDFs_el{i}(:,2), angles(i,2), 'linear', 'extrap');
end

% final doas
DoA(1,:) = mapped_azWF;
DoA(2,:) = mapped_elWF;

%a=5;
end

