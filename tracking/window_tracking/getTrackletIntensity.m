function meanIntensity = getTrackletIntensity( tracklet, imageStack, windowSize )
imageCrops = cropTracklet(tracklet, imageStack, windowSize);
[~,~,T] = size(imageCrops);
meanIntensity = zeros(T,1);
for t=1:T
    imageCrop = imageCrops(:,:,t);
    meanIntensity(t) = mean(imageCrop(:));
end

end

