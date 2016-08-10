function tracklets = convertTracks( trackData, T )
% trackData format: cell, N rows where N is number of track segments.
% Format of each track segment: [trackID time xCoord yCoord  meanIntensity]
% t starts at 0, x and y Coords are doubles.
% T is # of frames in stack
N = length(trackData);
tracklets = zeros(T,2,N);
for n=1:N
    trackSegment = trackData{n};
    trackLength  = size(trackSegment,1);
    for t=1:trackLength
        tracklets(trackSegment(t,2)+1,:,n) = [round(trackSegment(t,3)+1) round(trackSegment(t,4)+1)];
    end
end


end

