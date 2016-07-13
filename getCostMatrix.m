function [ costMat, state_interpolations, assignments, associations ] = getCostMatrix( tracklets, imageStack, windowSize, gpParams, ...
    distanceThreshold, timeThreshold, maxDistancePerFrame)
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
[T,~,N] = size(trackletData);
alpha = .75;        
% Get track lengths
trackLengths = zeros(N,1);
for n=1:N
    trackLengths(n) = length(find(trackletData(:,1,n)));
end
% Probability of initialization/termination of tracklet scales linearly
% with time.
% p_term = ((0:T)/T)';
% p_init = 1 - p_term;
% As time threshold increases, p_init_term decreases.
p_init_term = alpha^(.5*timeThreshold); % probability of initialization and termination of tracklet
Z = zeros(N,1);

% Quadrant 1 (clockwise)
costMat1 = -inf(N);
state_interpolations = {};
counter = 1;
for ii=1:N
    for jj=ii+1:N
        [costMat1(ii,jj),states] = calculateCost(ii,jj,imageStack,trackletData,...
            windowSize,gpParams,alpha,timeThreshold,distanceThreshold,maxDistancePerFrame);
        if ~isempty(states)
            state_interpolations{counter,1} = ii; state_interpolations{counter,2} = jj; state_interpolations{counter,3} = states;
            counter = counter + 1;
        end
    end
end
% Quadrant 2
costMat2 = -inf(N);
for ii=1:N
    costMat2(ii,ii) = log(p_term/Z(ii));
end
% Quadrant 3
costMat3 = zeros(N);
% Quadrant 4
costMat4 = -inf(N);
for ii=1:N
    costMat4(ii,ii) = log(p_init/Z(ii));
end
% Combine cost matrices
costMat = -[costMat1 costMat2; costMat4 costMat3];

% Normalize cost matrix (rows and columns each sum to 1)



% Run Hungarian algorithm and obtain assignments
[assignments,~] = munkres(costMat);
% Tracklet links
associations_ii = find(assignments(1:N) <= N)'; associations_jj = assignments(associations_ii)';
associations  = [associations_ii associations_jj];





end






























