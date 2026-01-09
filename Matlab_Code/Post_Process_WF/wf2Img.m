function image_matrix = wf2Img_newRuns(vec, scalars)
    
    max_az = scalars(1);
    min_az = scalars(2);
    max_el = scalars(3);
    min_el = scalars(4);
    max_pl= scalars(5);
    min_pl = scalars(6);
    max_df = scalars(7);
    min_df = scalars(8);

    vec_ang = vec(1:end/2);
    vec_em = vec(end/2+1:end);

    azs = vec_ang(1:end/2);
    els = vec_ang(end/2+1:end);
    pls = vec_em(1:end/2);
    dfs = vec_em(end/2+1:end);
    
    % Step 2: Create a custom colormap with more colors (e.g., 1024 colors)
    num_colors = 3000;
    cmap_az = jet(num_colors);  % You can replace 'parula' with other colormaps like 'jet', 'hsv', etc.
    cmap_el = parula(num_colors);
    cmap_pl = turbo(num_colors);
    cmap_df = cool(num_colors);
    
    % Step 3: Map the normalized values to the custom colormap
    %color_indices = round(normalized_vec * (num_colors - 1)) + 1;  % Get indices for colormap
    idx_az = scale_to_colormap(azs, num_colors, min_az, max_az); % Get indices for colormap az
    idx_el = scale_to_colormap(els, num_colors, min_el, max_el); % Get indices for colormap az
    idx_pl = scale_to_colormap(pls, num_colors, min_pl, max_pl); % Get indices for colormap az
    idx_df = scale_to_colormap(dfs, num_colors, min_df, max_df); % Get indices for colormap az
    
    % Step 4: Create a colormap encoding of the vector
    %colormap_encoded = cmap(color_indices, :);  % This will be a 3600x3 matrix
    encoded_az = cmap_az(idx_az, :);
    encoded_el = cmap_el(idx_el, :);
    encoded_pl = cmap_pl(idx_pl, :);
    encoded_df = cmap_df(idx_df, :);

    colormap_encoded = [encoded_az; encoded_el; encoded_pl; encoded_df];
    
    image_matrix = getImgMatrix(colormap_encoded);

end

