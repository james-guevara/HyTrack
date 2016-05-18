function [ newImageStack ] = medianFilterStack( imageStack )
[rows,cols,T] = size(imageStack);
newImageStack = zeros(rows,cols,T);
for t=1:T
    newImageStack(:,:,t) = medfilt2(imageStack(:,:,t));
end

end

