function [ uvStackNew ] = resizeFlowStack( uvStack )
[rows,cols,~,T] = size(uvStack);
uvStackNew = zeros(rows,cols,T*2);
for t=1:T
    uvStackNew(:,:,2*t-1)   = uvStack(:,:,1,t);
    uvStackNew(:,:,2*t)     = uvStack(:,:,2,t);
end

end

