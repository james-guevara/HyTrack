function [ avgTemplate ] = averageTemplate( imageStack, tracklet, windowSize )
[rows,cols] = size(imageStack);
imageCrops = [];
imageCrops = zeros(windowSize(1)+1,windowSize(2)+1);
counter = 1;
trackletIndices = find(tracklet(:,1));
N = numel(trackletIndices);
for i=1:N
    trackletIndex = trackletIndices(counter);
    xyCoordinates = [tracklet(trackletIndex,1) tracklet(trackletIndex,2)];
    if (xyCoordinates(1) > windowSize(2) + 1 && xyCoordinates(2) > windowSize(1) + 1 && xyCoordinates(1) < cols-windowSize(2)-1 && xyCoordinates(2) <  rows-windowSize(1)-1)
        rect = [xyCoordinates(1)-floor(windowSize(1)/2) xyCoordinates(2)-floor(windowSize(2)/2) ...
            windowSize(1) windowSize(2)];
        imageCrops(:,:,counter) = im2double(imcrop(imageStack(:,:,trackletIndex),rect));
        counter = counter + 1;
    end
end

avgTemplate = sum(imageCrops,3)/N;



end

