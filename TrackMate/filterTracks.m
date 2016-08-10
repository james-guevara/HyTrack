function newTracklets = filterTracks( tracklets )
% Gets nonzero tracklets
[T,~,N] = size(tracklets);
newTracklets = [];
counter = 1;
for n=1:N
    for t=1:T
        if (tracklets(t,:,n) ~= [0 0])
            newTracklets(:,:,counter) = tracklets(:,:,n);
            counter = counter + 1;
            break;
        end
    end
end

end

