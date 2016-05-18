function [ Y_new ] = imadjustStack( Y )
T = size(Y,3);
Y_new = zeros(size(Y));
for t=1:T
    Y_new(:,:,t) = imadjust(Y(:,:,t),[0 .4], [0 1]);
end

end

