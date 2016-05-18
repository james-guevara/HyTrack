function newTracklets = removeTracklets( tracklets, trackletThreshold )
[T,~,N] = size(tracklets);
counter = 1;
for n=1:N
    inds = find(tracklets(:,1,n));
    if (numel(inds) >= trackletThreshold)
        newTracklets(:,:,counter) = tracklets(:,:,n);
        counter = counter + 1;
    end
end

end

