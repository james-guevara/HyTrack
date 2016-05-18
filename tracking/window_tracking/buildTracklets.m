function [trackletStack, newDetectionStack] = buildTracklets( imageStack, detectionStack, thresholdParams, ...
    windowSize, windowSearchSize)
%% Get params
distanceThreshold   = thresholdParams.distanceThreshold;
intensityThreshold  = thresholdParams.intensityThreshold;
angleThreshold      = thresholdParams.angleThreshold;

trackletStack = [];

%% Build tracklets
[~,~,T] = size(imageStack);
newDetectionStack = detectionStack;
counter = 1;
tic
for t=1:T
    t
    detections = newDetectionStack{t};   % x,y,amplitude (sorted by amplitude)
    N = size(detections,1);
    for n=1:N
        initialPosition = detections(n,1:2);
        amplitude = detections(n,3);
        if (~isempty(trackletStack))
            numTracks = size(trackletStack,3);
            for i=1:numTracks
                trackDistance = pdist2(initialPosition,trackletStack(t,:,i));
                if (trackDistance < distanceThreshold)
                    initialPosition = [0 0];
                    break;
                end
            end
        end

        if (initialPosition ~= [0 0] & amplitude >= .13)
            [tracklet, newDetectionStack] = trackCell(imageStack, newDetectionStack, trackletStack, windowSize, ...
                distanceThreshold, intensityThreshold, angleThreshold, ...
                windowSearchSize, t, initialPosition);
            [tracklet, newDetectionStack] = backtrack(imageStack, newDetectionStack, trackletStack, windowSize, ...
                distanceThreshold, intensityThreshold, angleThreshold, ...
                windowSearchSize, tracklet);
            trackletStack(:,:,counter) = tracklet;
            counter = counter + 1;
        end
    end

end
toc
end














