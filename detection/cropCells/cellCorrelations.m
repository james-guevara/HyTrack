function [ correlationValues ] = cellCorrelations( imageCrop, imageCrops )
[~,~,T] = size(imageCrops);
correlationValues = zeros(T,1);
for t=1:T
    correlationValues(t,1) = imagesAngle(imageCrop,imageCrops(:,:,t));
end

end

