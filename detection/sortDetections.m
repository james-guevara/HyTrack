function [ newDetections ] = sortDetections( detections )
%% Sorts detections by amplitude
% detections: [xCoordinate yCoordinate amplitude]
[~,inds] = sort(detections(:,3),'descend');
newDetections = detections(inds,:);


end

