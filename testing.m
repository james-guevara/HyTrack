nei = {};
counter = ones(N,1);
for n=1:N
    n
    tmpTracks = G(n,:);
    tmpInds   = find(tmpTracks);
    numTracks = numel(find(tmpTracks));
    for i=1:numTracks
        if ( tmpInds(i) ~= n && tmpInds(i) <= N )
            nei{tmpInds(i),counter(tmpInds(i))} = n;
            counter(tmpInds(i)) = counter(tmpInds(i)) + 1;
        end
    end
end