function imageMatrix = getImgMatrix(colorMatrix)

    % Size of each color block
    %n = 10;
    n = 25;
    
    % Number of rows in the color matrix (must be a perfect square)
    m = size(colorMatrix, 1);
    
    % Check if m is a perfect square
    if mod(sqrt(m), 1) ~= 0
        error('The number of rows in the color matrix must be a perfect square.');
    end
    
    % Calculate the side length of the square grid
    gridSize = sqrt(m);
    
    % Initialize the image matrix
    imageMatrix = zeros(gridSize * n, gridSize * n, 3);
    
    % Populate the image matrix
    for i = 1:gridSize
        for j = 1:gridSize
            colorIndex = (i-1) * gridSize + j;
            colorBlock = repmat(reshape(colorMatrix(colorIndex, :), 1, 1, 3), n, n);
            rowStart = (i-1) * n + 1;
            colStart = (j-1) * n + 1;
            imageMatrix(rowStart:rowStart+n-1, colStart:colStart+n-1, :) = colorBlock;
        end
    end
    
    % Display the image
    %imshow(imageMatrix);

end
    