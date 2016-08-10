function tracklets = buildTracks( file, imageStack )
[~,~,T] = size(imageStack);
s = xml2struct(file);
trackData = getTrackMateData(s);    
tracklets = convertTracks(trackData,T); % Converts trackData to appropriate format
tracklets = filterTracks(tracklets); % Removes tracklets with all-zeros
% Extend tracks obtained from TrackMate
tracklets = extendTracks(tracklets,intensityThreshold,angleThreshold);
end

% imageStack = tiff_read('testing2_stack.tif');
% s = xml2struct('testing2.xml');
% trackData = getTrackMateData(s);
% tracklets = convertTracks(trackData,size(imageStack,3));
% tracklets = tracklets(1:1000,:,:);
% tracklets = filterTracklets(tracklets);
% imageStack = imageStack(:,:,1:1000);