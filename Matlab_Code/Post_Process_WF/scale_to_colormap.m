function idx = scale_to_colormap(data, N, minV, maxV)
    % Scale data to indices in [1, N] based on its actual range
    min_val = minV;
    max_val = maxV;
    idx = round((data - min_val) / (max_val - min_val + eps) * (N - 1)) + 1;
end
