figH = figure; set(figH, 'Name',opticalFlow.Method);
hImObj = image(ones([size(curIm), 3],'single')/2);
axis off;axis image; title(gca,['computer vision toolbox flow: ' opticalFlow.Method]);
g.figH = figH;
%if synthetic video, also setup keyboard callback
if strcmpi(kindOfMovie, 'synthetic')
    set(figH, 'Name',[get(figH, 'Name') ' -- use keys (q,a,w,s,e,d) for lag time and pattern speed --' ],...
              'WindowKeyPressFcn',@myKeypress,'WindowKeyReleaseFcn',@myKeyrelease);
end
 