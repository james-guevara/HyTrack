function tracklets = convertTracks( imageStack, xmlFile )
[trackMateTracks, ~] = importTrackMateTracks(xmlFile);
[rows,cols,T] = size(imageStack);
N = numel(trackMateTracks);
tracklets = zeros(T,2,N);
for n=1:N
    tmpTrack = trackMateTracks{n};
    tmpTrack(:,1:3) = tmpTrack(:,1:3) + 1;
    tracklets(tmpTrack(:,1),:,n) = round(tmpTrack(:,2:3));
end

for n=1:N
    for t=1:T
        if (tracklets(t,1,n) > rows+5 || tracklets(t,2,n) > cols+5 || ...
            tracklets(t,1,n) < 5 || tracklets(t,2,n) < 5)
            tracklets(t:T,:,n) = repmat([0 0],T-t+1,1);
        end
    end
end


end