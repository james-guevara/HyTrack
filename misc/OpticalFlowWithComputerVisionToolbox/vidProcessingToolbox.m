% Authors:
% Stefan M. Karlsson AND Josef Bigun 
function [curIm, V] = vidProcessingToolbox(movieType, opticalFlow,sc,spdFactor, lagTime)
% quick usage:
% vidProcessing(); - displays a sequence of test images
% vidProcessing(movieType); - same as above, but on video source indicated by the
% argument. movieType can be:
% 'synthetic' - generates a synthetic video on the fly
% 'camera' - generates video through a connected camera (requires image acquisition toolbox)
% 'cameraX' - where X is number indicating which of system cameras to use
% (default is 1). This is to be input into the string, such as e.g.: 
%         vidProcessing('camera1','edge');
% filename - name of video file in the current folder.
% example: vidProcessing('lipVid.avi'); - assumes an avi file is in the current folder
%
% explicit usage:
% [curIm, V] = vidProcessing(movieType);
% output current image and optical flow estimate at the time the figure is closed
%
% vidProcessing(movieType, opticalFlow); displays the same sequence, but
% with a method selected for analyzing the sequence. Send in an optical
% flow object of type "vision.OpticalFlow"
%
% 
% sc - used to scale the flow for visualization. Increase this one if you
% see very little color.
%
% spdFactor -
% additionally sets a speed factor (spdFactor) to change the speed of the
% synthetic video generation (if spdFactor=2, then the synthetic sequence 
% is twice as fast)
%
% "lagTime" is an optional additional lag-time in seconds,
% added as a pause between each frame updates

%ensure access to functions and scripts in the folder "helperFunctions"
addpath('helperFunctions');
global g; %contains shared information, ugly solution, but the fastest

ParseAndSetupScript; %script for parsing input and setup environment

%a function that sets up the video:
vid =  myVidSetup(kindOfMovie,movieType,128,128,camID);

% index variable for time:
t=1;

%from this point on, we handle the video by the object 'vid'. This is how
%we get the first frame:
curIm = generateFrame(vid, t,kindOfMovie,g.spdFactor,g.arrowKey);

V = step(opticalFlow,curIm);
setupGraphicsScript;

while 1 %%%%%% MAIN LOOP, runs until user shuts down the figure  %%%%%
    tic; %time each loop iteration;
    t=t+1;
    curIm = generateFrame(vid, t,kindOfMovie,g.spdFactor,g.arrowKey);

    V = step(opticalFlow,curIm);

    if ishandle(figH)%check if the figure is still open
        colIm(:,:,1) = (angle(V)+ pi+0.000001)/(2*pi+0.00001);
        colIm(:,:,2) = min(1,abs(V)*sc);
        colIm(:,:,3) = max(colIm(:,:,2),curIm);
        set(hImObj ,'cdata',hsv2rgb(colIm));

    else%user has killed the main figure, break the loop and exit
        break;
    end

	%if paused, stay here:
    while (g.bPause && ishandle(figH)), pause(0.3);end

    % Pause to achieve target framerate, with some added lag time:
    timeToSpare = max(0.001, (1/targetFramerate) - toc + g.lagTime); 
    pause( timeToSpare); 

end  %%%%%%% END MAIN LOOP  %%%%%%%%%


% Clean up:
if strcmpi(kindOfMovie,'file')
    delete(vid);   
elseif strcmpi(kindOfMovie,'camera')
  if vid.bUseCam ==2
      vi_stop_device(vid.camIn, vid.camID-1);
      vi_delete(vid.camIn);
  else
      delete(vid.camIn); 
  end
end 
