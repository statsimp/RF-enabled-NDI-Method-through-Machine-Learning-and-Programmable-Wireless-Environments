function imageMatrix = getImgMatrix2(colorMatrix)

    % Size of each color block
    n = 50;
    
    % Number of rows in the color matrix
    m = size(colorMatrix, 1);
    
    % Determine the grid size
    rows = ceil(sqrt(m));
    cols = ceil(m / rows);
    
    % Initialize the image matrix
    imageMatrix = zeros(rows * n, cols * n, 3);
    
    % Populate the image matrix
    for i = 1:rows
        for j = 1:cols
            colorIndex = (i-1) * cols + j;
            if colorIndex <= m
                colorBlock = repmat(reshape(colorMatrix(colorIndex, :), 1, 1, 3), n, n);
                rowStart = (i-1) * n + 1;
                colStart = (j-1) * n + 1;
                imageMatrix(rowStart:rowStart+n-1, colStart:colStart+n-1, :) = colorBlock;
            end
        end
    end

% Display the image
%imshow(imageMatrix);


end
