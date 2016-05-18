function [ tracklet, k ] = getTracklet( tracklets, xyt, distanceThreshold )
x = xyt(1); y = xyt(2); t= xyt(3);
[~,~,N] = size(tracklets);
tracklet = [];
k = 0;
for n=1:N
    if (pdist2([tracklets(t,1,n) tracklets(t,2,n)], [x y]) < distanceThreshold)
        tracklet = tracklets(:,:,n);
        k = n;
        return;
    end
end

end

