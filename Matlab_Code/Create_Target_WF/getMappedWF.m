function doa = getMappedWF(wf, i, pwe)
% getMappedWF: is a function to return the the mapped angles of the wavefront encoding/ decoding
% based on the f, g functions ( "cdf approach" of the PWE characteristics )
%

% init the wf values
numRx = numel(pwe);
doa = zeros(2, numRx);
vector = wf(i,:);
vector = vector(1:end/2);
v1 = vector(1:end/2);
v2 = vector(end/2+1:end);

[ECDFs_az, ECDFs_el] = getCDFs(pwe);
[cdf_x_az, cdf_y_az] = getMeanCdf(ECDFs_az);
[cdf_x_el, cdf_y_el] = getMeanCdf(ECDFs_el);

% Function to map wf to angles
mapped_az = interp1(cdf_y_az, cdf_x_az, v1, 'linear', 'extrap');
mapped_el = interp1(cdf_y_el, cdf_x_el, v2, 'linear', 'extrap');


% final doas
doa(1,:) = mapped_az;
doa(2,:) = mapped_el;

end

