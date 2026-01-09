function eq = getEquivalentInfo(rays, heta)
%getEquivalentInfo: is a function that returns the total equivalent RF info, based on rays array
% 
% ==============Arguments=====================
%
%      - rays: array of RF info per row
%
% ==============Return=======================
%
%    - eq: total equivalent RF info, based on rays array
%% getEquivalentInfo

Pt = 0; % 0 dBm trans power
Ae = 1; % effective aperture
num = size(rays, 1);

vecs = zeros(num, 5);
for i =1:num
    % access each ray info
    pathloss = rays(i,1); % pathloss in dB
    phaseChange = rays(i,2);
    k1 = rays(i,3);
    k2 = rays(i,4);
    k3 = rays(i,5);

    p = Pt - pathloss; % received power
    p = 10^( (p-30)/ 10); % dBm to watt
    S = p / Ae; % power density
    E = sqrt(S*heta); % field strength

    vecs(i,:) = [E, wrapTo2Pi(phaseChange), k1, k2, k3];
end

% calculate power and phase info
Ef = vecs(:,1).*exp(1i*vecs(:,2));
Ef = sum(Ef);
Sf = ( norm(Ef)^2 )/ heta;
power = Sf*Ae;
power = 10*log10(power)+30; % eq power in dB 
phase = angle(Ef); % in radians

% calculate DoA info
doas = (vecs(:,1).^2).*vecs(:,end-2:end);
doas = sum(doas, 1);
[az, el, ~] = cart2sph(doas(1), doas(2), doas(3));

eq = [power, wrapTo2Pi(phase), az, el];

end