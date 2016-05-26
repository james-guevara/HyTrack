function [ tracklets ] = extendTrack( imageStack, trackMateTracks )
[rows,cols,T] = size(imageStack);
N = numel(trackMateTracks);
tracklets=zeros(T,2,N);
for n=1:N
    z=trackMateTracks{n,1}(1,1);
    [zz,r]=size(trackMateTracks{n,1});
    for m=1:zz
        tracklets(m+z,:,n)=trackMateTracks{n,1}(m,2:3); 
    end
end

end

