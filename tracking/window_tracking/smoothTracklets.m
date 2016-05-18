function newTracklets = smoothTracklets( tracklets )
[~,~,N] = size(tracklets);
newTracklets = zeros(size(tracklets));
for n=1:N
    inds = find(tracklets(:,1,n));
    newTracklets(inds,1,n) = smooth(tracklets(inds,1,n));
    newTracklets(inds,2,n) = smooth(tracklets(inds,2,n));
end

end

