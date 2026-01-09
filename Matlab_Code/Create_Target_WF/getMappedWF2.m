function doa = getMappedWF2(wf, i, pwe)
% getMappedWF: is a function to return the the mapped angles of the wavefront encoding/ decoding
% based on the f, g functions ( "cdf approach" of the PWE characteristics )
%
% ==============Arguments=====================
%
%    - wf: the [0, 1] wavefront
%
%    - i: 
%
%    - test: whether we take into consideration the azimuth or elevation
%    case
% ==============Return=======================
%
%    - angles: the 
%% getMappedWF2

% init the wf values
numRx = numel(pwe);
doa = zeros(2, numRx);
vector = wf(i,:);
vector = vector(1:end/2);
v1 = vector(1:end/2);
v2 = vector(end/2+1:end);

[ECDFs_az, ECDFs_el] = getCDFs2(pwe, -2);

% Function to map wf to angles
num = length(v1);
mapped_az = zeros(num,1);
mapped_el = zeros(num,1);
for i = 1:num
    mapped_az(i) = interp1(ECDFs_az{i}(:,2), ECDFs_az{i}(:,1), v1(i), 'linear', 'extrap');
    mapped_el(i) = interp1(ECDFs_el{i}(:,2), ECDFs_el{i}(:,1), v2(i), 'linear', 'extrap');
end

% final doas
doa(1,:) = mapped_az;
doa(2,:) = mapped_el;

end
