PARENTFOLDER = "C:\Users\stats\Documents\Forth\0_Forth\MATLAB-Forth\RayTracing Matlab\Example\new_runs_snapshots\";
d = dir(PARENTFOLDER);
num = length(d)-2;

names = cell(num, 1);

for i = 1:num
    names{i} = d(i+2).name;
end
names = sortrows(names);
    

corr_mat = zeros(num, num);
% Compute only upper triangle and mirror it
for i = 1:num
    img1 = imread(PARENTFOLDER + names{i});
    im1 = rgb2gray(img1);
    for j = i:num  % Start from 'i' to avoid redundant computations
        img2 = imread(PARENTFOLDER + names{j});
        im2 = rgb2gray(img2);

        rr = corr2(im1, im2); % compute the correlation

        corr_mat(i, j) = rr;  % Extract correlation value
        corr_mat(j, i) = rr;  % Symmetric assignment
        
    end
    disp(strcat("Finished__", num2str(i)));
end

corr_final = {names, corr};
save("new_runs_corr.mat", "corr_final");
