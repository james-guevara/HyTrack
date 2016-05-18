function [ newImageStack ] = denoiseStack( imageStack, sz, sigma )
% sz is the size of the filter block used to calculate means and variances.
% Must be an odd value. (3 < sz < min(size(Iin)))
% sigma (sigma > 0) is the weighting parameter that defines the standard
% deviation relative to the filter block's standard deviation around which
% the center pixel will be Gaussian weighted.
% As sigma -> inf, Iout = Iin
[~,~,T] = size(imageStack);
newImageStack = zeros(size(imageStack));
for t=1:T
    newImageStack(:,:,t) = relnoise(imageStack(:,:,t),sz,sigma);
end

end

