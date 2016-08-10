function newTracklets = interpolateTracklets( tracklets, gpParams )
[~,~,N] = size(tracklets);
newTracklets = zeros(size(tracklets));
for n=1:N
    n
    newTracklets(:,:,n) = interpolateTracklet(tracklets(:,:,n),gpParams,tracklets);
end
end

