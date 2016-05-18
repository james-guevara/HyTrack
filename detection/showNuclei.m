function [ I_new ] = showNuclei( I, xyCoords )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N = size(xyCoords,1);
xCoord = xyCoords(:,1); yCoord = xyCoords(:,2);
I_max = zeros(size(I));
for n=1:N
    I_max(yCoord(n),xCoord(n)) = 1;
end
se   = strel('disk', 1);
I_max = logical(imdilate(I_max,se));
I_new = I;
I_new(I_max) = 1;


end

