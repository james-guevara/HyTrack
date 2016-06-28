function [cost, Z, states] = calculateAffinity( ii, jj, trackletData, imageStack, windowSize, gpParams, alpha, beta, eps, distanceThreshold, p_init, p_term)
% Cost is log of probability. Z is normalization.
tracklet1_data = trackletData(:,:,ii); tracklet1 = tracklet1_data(:,1:2); tracklet1_pos = find(tracklet1_data(:,1)); tracklet1_end   = tracklet1_pos(end); tracklet1_len = length(tracklet1_pos);
tracklet2_data = trackletData(:,:,jj); tracklet2 = tracklet2_data(:,1:2); tracklet2_pos = find(tracklet2_data(:,1)); tracklet2_start = tracklet2_pos(1);   tracklet2_len = length(tracklet2_pos);
frameGap = tracklet2_start - tracklet1_end;

p_init_x=p_init();
p_term_x=p_term();

if (ii == 411)
    2
end
if frameGap == 0
    cost = -inf;
    Z = p_init_x + p_term_x;
    states = [];
    return;
elseif frameGap > eps
    cost = -inf;
    Z = p_init_x + p_term_x;
    states = [];
    return;
elseif pdist2(tracklet1(tracklet1_end,:),tracklet2(tracklet2_start,:)) > distanceThreshold
    cost = -inf;
    Z = p_init_x + p_term_x;
    states = [];
    return;
else
    if (ii == 1)
        2
    end
    % Calculate appearance affinity (i.e. probability)
    avgTemplate1 = averageTemplate(imageStack, tracklet1, windowSize);
    avgTemplate2 = averageTemplate(imageStack, tracklet2, windowSize);
    appearance_affinity = 90 - imagesAngle(avgTemplate1,avgTemplate2)/90;
    % Calculate motion affinity
    stateOne = tracklet1(tracklet1_end,:);
    stateTwo = tracklet2(tracklet2_start,:);
    [stateMean, stateCovariance, states] = propagateState(stateOne,tracklet1_end,frameGap,gpParams,trackletData);
    motion_affinity = mvnpdf(stateTwo,stateMean,diag(stateCovariance));
    % Calculate temporal affinity
    temporal_affinity = alpha^(frameGap-1);
    
    % Total probability
    p_link = appearance_affinity*motion_affinity*temporal_affinity;
    Z = (p_link + p_init_x + p_term_x);
    p_link = p_link/Z;
    % True detection probabilities
    true_detection_1 = 0.95+0.05*tracklet1_len/T;%beta^(tracklet1_len);
    true_detection_2 = 0.95+0.05*tracklet2_len/T;%beta^(tracklet2_len);
    % Component cost
    cost = log(p_link) + .5*(log(true_detection_1) + log(true_detection_2));
end






end