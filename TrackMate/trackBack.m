function newTracklet = trackBack( imageStack, tracklets, windowSize, ...
    distanceThreshold, intensityThreshold, angleThreshold, ...
    windowSearchSize, tracklet )
%% Initialization
t_initial = find(tracklet,1,'first');
initialPosition = [tracklet(t_initial,1) tracklet(t_initial,2)];
[rows,cols,T] = size(imageStack);
if (t_initial == 1)
    newTracklet = tracklet;
    return;
end
N = size(tracklets,3);
% newDetectionStack = detectionStack;
numObservations = windowSearchSize*windowSearchSize;
% Initialize template
rect = [initialPosition(1)-floor(windowSize(1)/2) initialPosition(2)-floor(windowSize(2)/2) ...
    windowSize(1) windowSize(2)];
templateImage = im2double(imcrop(imageStack(:,:,t_initial),rect));
[templateHeight,templateWidth] = size(templateImage);
newTracklet = tracklet;
correlationValues = zeros(t_initial,1); intensityValues = zeros(t_initial,1);
%% Tracking
for t=t_initial-1:-1:1
    % Crop observation windows (using window search)
    observationWindows = zeros(templateHeight,templateWidth,numObservations);
    positionSamples = zeros(numObservations,2);
    sampleWeights = zeros(numObservations,1);
    angles = zeros(numObservations,1);
    counter = 1;
    searchWindow = floor(windowSearchSize/2);
    for c=-searchWindow:searchWindow
        for r=-searchWindow:searchWindow
            positionSamples(counter,:) = [newTracklet(t+1,1)+c newTracklet(t+1,2)+r];
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
            else % Stop tracking
                % sampleWeights(counter) = 0;
                % counter = counter + 1;
                newTracklet(t,:) = [0 0];
                return;
            end
        end
    end
    [correlationValues(t),ind] = max(sampleWeights);
    observationWindow = observationWindow(:,:,ind);
    intensityValues(t) = mean(observationWindow(:));
    newTracklet(t,:) = positionSamples(ind,:);
    
    %% Break tracklet if it doesn't satisfy criteria:
    % Correlation threshold: angleThreshold
    if (correlationValues(t) < angleThreshold)
        newTracklet(t,:) = [0 0];
        return;
    end
    
    % Intensity threshold: intensityThreshold
    if (intensityValues(t) < intensityThreshold)
        newTracklet(t,:) = [0 0];
        return;
    end
    
    %% Break tracklet if it is too close to a previous tracklet coordinate at time t
    if (~isempty(tracklets))
        for n=1:N
            trackDistance = pdist2(newTracklet(t,:),tracklets(t,:,n));
            if (trackDistance < distanceThreshold)
                newTracklet(t,:) = [0 0];
                return;
            end
        end
    end
        
end


end

