function [cost, states ] = calculateCost( ii, jj, imageStack, trackletData, ...
    windowSize, gpParams, alpha, timeThreshold, distanceThreshold, maxDistancePerFrame)
% Cost is log of probability. Z is normalization.
tracklet1_data = trackletData(:,:,ii);          tracklet2_data = trackletData(:,:,jj);
tracklet1 = tracklet1_data(:,1:2);              tracklet2 = tracklet2_data(:,1:2);
tracklet1_pos = find(tracklet1_data(:,1));      tracklet2_pos = find(tracklet2_data(:,1));
tracklet1_endTime = find(tracklet1_pos(end));   tracklet2_startTime = find(tracklet2_pos(1));
% tracklet1_len = length(tracklet1_pos);          tracklet2_len = length(tracklet2_pos);

trackletDistance = pdist2(tracklet1(tracklet1_endTime,:),tracklet2(tracklet2_startTime,:));
% Thresholding
if frameGap <= 0
    cost = -inf;
    states = [];
    return;
elseif frameGap > timeThreshold % if the tracklets are too far separated in time
    cost = -inf;
    states = [];
    return;
elseif trackletDistance > distanceThreshold % if the tracklets are too far separated in space
    cost = -inf;
    states = [];
    return;
elseif trackletDistance > frameGap*maxDistancePerFrame
    cost = -inf;
    states = [];
    return;
else
    % Compute appearance affinity, motion affinity, and temporal affinity.
    % Compute appearance affinity.
    avgTemplate1 = averageTemplate(imageStack,tracklet1,windowSize);
    avgTemplate2 = averageTemplate(imageStack,tracklet2,windowSize);
    appearance_affinity = 90 - imagesAngle(avgTemplate1,avgTemplate2)/90;
    % Calculate motion affinity.
    stateOne = tracklet1(tracklet1_endTime,:);
    stateTwo = tracklet2(tracklet2_startTime,:);
    [stateMean, stateCovariance, states] = propagateState(stateOne, tracklet1_end, frameGap, gpParams, trackletData);
    % If stateMean obtained from GP velocity is too big...
    if pdist2(stateMean,stateTwo) > frameGap*maxDistancePerFrame
        cost = -inf;
        states = [];
        return;
    end
    motion_affinity = mvnpdf(stateTwo,stateMean,diag(stateCovariance));
    % Calculate temporal affinity
    temporal_affinity = alpha^(frameGap-1);
    
    % Calculate probability and cost
    % p_link = appearance_affinity*motion_affinity*temporal_affinity;
    cost = log(appearance_affinity) + log(motion_affinity) + log(temporal_affinity);
    
end






end

