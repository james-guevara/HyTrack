function [ newImageStack ] = thresholdStack( imageStack, thresholdValue )
[rows,cols,T] = size(imageStack);
newImageStack = imageStack;
for t=1:T
    tmp = newImageStack(:,:,t);
    tmp(tmp <= thresholdValue) = 0;
    newImageStack(:,:,t) = tmp;
end

end

