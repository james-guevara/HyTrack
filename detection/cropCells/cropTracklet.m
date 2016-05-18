function [ imageCrops ] = cropTracklet( tracklet, imageStack, windowSize )
imageCrops = [];
counter = 1;
timeIndices = find(tracklet(:,1));
for t=timeIndices(1):timeIndices(end)
    if (tracklet(t,:) ~= [0 0])
        rect = [tracklet(t,1)-floor(windowSize(1)/2) tracklet(t,2)-floor(windowSize(2)/2) ...
            windowSize(1) windowSize(2)];
        imageCrops(:,:,counter) = im2double(imcrop(imageStack(:,:,t),rect));
        counter = counter + 1;
    end
end

end

