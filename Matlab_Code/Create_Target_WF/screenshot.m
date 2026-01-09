function screenshot(TR_obj, filename,savePlace)

% screenshot() -- is a function to save the rotated object as an image
%
% ==============Arguments===================
%
%  - TR_obj: the object in a triangulation from so it can be "rendered"
%  
%  - filename: the name of the object in the file
%  
%  - iter: iteration, different rotation of the object 
%
%  - savePlace: directory to save the generated image 
%
%=============Retutn===========================
%
%   



fig = figure('visible','off');
%set(fig, 'Position', [100, 100, 600, 600]); % Setting the figure size to 600x600 pixels
set(fig, 'Units', 'pixels', 'Position', [100, 100, 600, 600]); % Setting the figure size to 600x600 pixels

tri = trisurf(TR_obj);
ax = gca;

% clearing the graph so it appears as a photo
set(ax,'xtick',[],"YTick",[],"ZTick",[])
ax.XAxis.Visible="off";
ax.YAxis.Visible = "off";
ax.ZAxis.Visible = "off";

% making the object appear better
set(tri, "edgealpha",0)
colormap gray

% handling the color of gca and gcf so the colormap is better distinctable
% from the background
set(fig, 'InvertHardCopy', 'off');
set(fig,"Color","g")
set(ax,"Color","g")


% lighting for better view, something like "rendering"
axis equal
camlight("right");
camlight("left");
%view(25,60);
view(35,45);

% saving the generated figure as an image
saveFile = savePlace+filename+".png";
%saveas(fig,saveFile);
set(fig, 'PaperPositionMode', 'auto'); % Ensure the paper position mode is auto
print(fig, saveFile, '-dpng', '-r100'); % Save the figure with the specified resolution
close(fig);

end