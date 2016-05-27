function [ uvStack ] = computeFlow( imageStack )
[rows,cols,T] = size(imageStack);
uvStack = zeros(rows,cols,2,T-1);
for t=1:T-1
    uvStack(:,:,:,t) = estimate_flow_interface(imageStack(:,:,t),imageStack(:,:,t+1),'classic+nl-fast');
end



end

