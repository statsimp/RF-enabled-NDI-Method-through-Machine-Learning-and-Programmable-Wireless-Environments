function [ECDFs_az, ECDFs_el] = getCDFs2(pwe, elMin)
% getCDFs: is a function to return the the mapped angles of the wavefront encoding/ decoding
% based on the f, g functions ( "cdf approach" of the PWE characteristics
% ). 
%% getMappedWF

num = numel(pwe);
ECDFs_az = cell(num,1);
ECDFs_el = cell(num,1);

for i = 1:num
    az = pwe{i}(1,:);
    el = pwe{i}(2,:);
    el = el(el>elMin);

    % Step 1: Estimate the PDF of x using KDE
    [f_az, azi] = ksdensity(az);
    [f_el, eli] = ksdensity(el);
    
    % Step 2: Compute the CDF of x
    cdf_az = cumtrapz(azi, f_az); % Numerical integration to get the CDF
    cdf_el = cumtrapz(eli, f_el); % Numerical integration to get the CDF
    
    % Ensure the CDF is within [0, 1] and sorted
    cdf_az = cdf_az / max(cdf_az); % Normalize to range [0, 1]
    %sorted_az = sort(az);
    [azi_sorted, unique_indices_az] = unique(azi);
    cdf_az_sorted = cdf_az(unique_indices_az);

    cdf_el = cdf_el / max(cdf_el); % Normalize to range [0, 1]
    %sorted_el = sort(el);
    [eli_sorted, unique_indices_el] = unique(eli);
    cdf_el_sorted = cdf_el(unique_indices_el);
    
    % Step 3: Create the mapping function f
    % Interpolating the inverse CDF
    % sorted_cdf_az = interp1(azi, cdf_az, sorted_az, 'linear', 'extrap');
    % sorted_cdf_el = interp1(eli, cdf_el, sorted_el, 'linear', 'extrap');
    
    ECDFs_az{i} = [azi_sorted', cdf_az_sorted'];
    ECDFs_el{i} = [eli_sorted', cdf_el_sorted'];

end


    
end