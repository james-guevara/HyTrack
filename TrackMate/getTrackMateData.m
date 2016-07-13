function trackData = getTrackMateData( s )
% Gets data from all the tracks in the struct s. Places each in cell.
trackData = {};
sortedSpots = sortSpots(s);
% spots_s  = s.TrackMate.Model.AllSpots;
tracks_s = s.TrackMate.Model.AllTracks.Track;
numTracks = length(tracks_s);
for n=1:numTracks
    tmpTrack = [];
    trackEdges = tracks_s{n}.Edge;
    numEdges = length(trackEdges);
    counter = 1;
    if (numEdges == 1)
        spotSource = str2num(trackEdges.Attributes.SPOT_SOURCE_ID);
        spotTarget = str2num(trackEdges.Attributes.SPOT_TARGET_ID);
        tmpTrack(counter,1) = spotSource; counter = counter + 1;
        tmpTrack(counter,1) = spotTarget; counter = counter + 1;
    else
        for k=1:numEdges
            spotSource = str2num(trackEdges{k}.Attributes.SPOT_SOURCE_ID);
            spotTarget = str2num(trackEdges{k}.Attributes.SPOT_TARGET_ID);
            tmpTrack(counter,1) = spotSource; counter = counter + 1;
            tmpTrack(counter,1) = spotTarget; counter = counter + 1;
        end
    end
    tmpTrack = unique(tmpTrack);
    trackData{n,1} = tmpTrack;
end

% Place spot data (from sorted spots) into track data.
for n=1:numTracks
    tmpTrack = trackData{n};
    numSpots = length(tmpTrack);
    newTrack = zeros(numSpots,5);
    for k=1:numSpots
        spotID = tmpTrack(k);
        ind = find(sortedSpots(:,1) == spotID);
        spotData = sortedSpots(ind,:);
        newTrack(k,:) = spotData;
    end
    trackData{n,1} = newTrack;
end

% Sort each track by frame number
for n=1:numTracks
    tmpTrack = trackData{n};
    [~,inds] = sort(tmpTrack(:,2));
    newTrack = tmpTrack(inds,:);
    trackData{n,1} = newTrack;
end




%% Nested function
    function sortedSpots = sortSpots( s )
        % sortedSpots is a cell array.
        numSpots = str2num(s.TrackMate.Model.AllSpots.Attributes.nspots);
        spots_s = s.TrackMate.Model.AllSpots.SpotsInFrame;
        T = length(spots_s);
        sortedSpots = zeros(numSpots,5);
        counter = 1;
        for t=1:T
            tmpFrame = spots_s{t}.Spot;
            numSpotsInFrame = length(tmpFrame);
            for n=1:numSpotsInFrame
                tmpSpot = tmpFrame{n}.Attributes;
                tCoord = str2num(tmpSpot.FRAME);
                xCoord = str2num(tmpSpot.POSITION_X);
                yCoord = str2num(tmpSpot.POSITION_Y);
                spotID = str2num(tmpSpot.ID);
                % spotQuality = str2num(tmpSpot.QUALITY);
                spotMeanIntensity = str2num(tmpSpot.MEAN_INTENSITY);
                % sortedSpots(spotID+1,:) = [spotID tCoord xCoord yCoord];
                sortedSpots(counter,:) = [spotID tCoord xCoord yCoord spotMeanIntensity];
                counter = counter + 1;
            end
        end
        [~,inds] = sort(sortedSpots(:,1));
        sortedSpots = sortedSpots(inds,:);
    end














end

