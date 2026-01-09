function eqRay = getEqRay(rays)
% getEqRay: a function that calculates the equivalent ray info, based on
% the arriving rays
% 
% ==============Arguments=====================
%
%      - rays: the rays arriving at the antenna
%
% ==============Return=======================
%
%    - eqRay: the calculated equivalent ray

%% getEqRay

% from path-loss to amplitude
pathloss = rays(:,1);
power = 10.^(pathloss/10);
amps = sqrt(power);

% init 
dfs = rays(:,2);
azs = rays(:,3);
els = rays(:,4);

% calculate equivalent channel
h_eq = sum(amps .* exp(1j * dfs));
abs_h = abs(h_eq);      % equivalent amplitude
angle_h = angle(h_eq);  % equivalent phase

% calculate equivalent AoA
[x,y,z] = sph2cart(azs, els, ones(length(azs),1));
% doas = zeros(length(azs), 3);
% for iter=1:length(azs)
%     doas(iter,:) = power(iter).*[x(iter), y(iter), z(iter)];
% end
doas = [x, y, z] .* power(:);  % Ensure power is a column vector

doas = sum(doas, 1);

[azimuth, elevation, ~] = cart2sph(doas(1), doas(2), doas(3));


% return equivalent ray info
eqRay = [azimuth, elevation, 10*log10(abs_h),angle_h];

end
