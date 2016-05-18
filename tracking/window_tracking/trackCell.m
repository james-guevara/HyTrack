function [cellPositions, newDetectionStack] = trackCell( imageStack, detectionStack, trackletStack, windowSize, ...
    distanceThreshold, intensityThreshold, angleThreshold, ...
    windowSearchSize, t_curr, initialPosition )
%   INPUTS:
%   detectionStack: cell array, format:  [xCoordinates yCoordinates amplitudes]
%   trackStack: previous tracks, format: row is time, col one is
%   xCoordinate, col two is yCoordinate, page is track
%   windowSize: [width height]
%   distanceThreshold: distance threshold between track position and
%   detection
%   motionThreshold: motion threshold of tracks (so track doesn't "jump")
%   smoothnessThreshold: dot product between velocity vectors at time t and
%   time t-1. Usually set to 0
%   initialPosition: initial xyCoordinates [x y] (centered)
%   numSamples: number of samples of particle filter
%   windowSearchSize: how far to search (1 ~ no move, 3 ~ 3x3 box around
%   initial position, 5 ~ 5x5 box around initial position, must be odd
%% Initialization
[rows,cols,T] = size(imageStack);
N = size(trackletStack,3);
newDetectionStack = detectionStack;
numObservations = windowSearchSize*windowSearchSize;
% Initialize template
rect = [initialPosition(1)-floor(windowSize(1)/2) initialPosition(2)-floor(windowSize(2)/2) ...
    windowSize(1) windowSize(2)];
templateImage = im2double(imcrop(imageStack(:,:,t_curr),rect));
[templateHeight,templateWidth] = size(templateImage);
cellPositions = zeros(T,2);
cellPositions(t_curr,:) = initialPosition;
correlationValues = zeros(T,1);
%% Tracking
for t=t_curr+1:T
    % Crop observation windows (using window search)
    observationWindows = zeros(templateHeight,templateWidth,numObservations);
    positionSamples = zeros(numObservations,2);
    sampleWeights = zeros(numObservations,1);
    angles = zeros(numObservations,1);
    counter = 1;
    searchWindow = floor(windowSearchSize/2);
    for c=-searchWindow:searchWindow
        for r=-searchWindow:searchWindow
            positionSamples(counter,:) = [cellPositions(t-1,1)+c cellPositions(t-1,2)+r];
            tmpRect = [positionSamples(counter,1)-floor(windowSize(1)/2) positionSamples(counter,2)-floor(windowSize(2)/2) ...
                windowSize(1) windowSize(2)];
            if (tmpRect(1) > 0 && tmpRect(2) > 0 && tmpRect(1)+tmpRect(3) < cols && tmpRect(2)+tmpRect(4) < rows)
                observationWindows(:,:,counter) = imcrop(imageStack(:,:,t),tmpRect);
                angles(counter) = imagesAngle(observationWindows(:,:,counter),templateImage);
                sampleWeights(counter) = 90 - angles(counter);
                if (isnan(sampleWeights(counter)))
                    sampleWeights(counter) = 0;
                end
                counter = counter + 1;
            else
                sampleWeights(counter) = 0;
                counter = counter + 1;
            end
            
        end
    end
    
    [correlationValues(t),ind] = max(sampleWeights);
    cellPositions(t,:) = positionSamples(ind,:);

    %% Break tracklet if it doesn't satify criteria:
    % Correlation threshold: angleThreshold
    if (correlationValues(t) < angleThreshold)
        cellPositions(t,:) = [0 0];
        return;
    end


    
    %% Break tracklet if it is too close to a previous tracklet coordinate at time t
    if (~isempty(trackletStack))
        for n=1:N
            trackDistance = pdist2(cellPositions(t,:),trackletStack(t,:,n));
            if (trackDistance < distanceThreshold)
                cellPositions(t,:) = [0 0];
                return;
            end
        end
    end
    
    %% Remove detections at time t (from detectionStack)
    detections = detectionStack{t};
    R = size(detections,1);
    for r=1:R
        detectionDistance = pdist2(cellPositions(t,:),detections(r,1:2));
        if (detectionDistance < distanceThreshold)
            detections(r,:) = [0 0 0];
            break; % maybe not break?
        end
    end
    newDetectionStack{t,1} = detections;
    
    


    
end


end

