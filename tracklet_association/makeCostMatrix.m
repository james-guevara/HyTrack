function [costMat, state_interpolations, assignments, associations] = makeCostMatrix( trackletData, imageStack, windowSize, gpParams, distanceThreshold, timeThreshold )
[~,~,N] = size(trackletData);
beta  = .9;
eps   = timeThreshold;
alpha = .9;
% Get track lengths
trackLengths = zeros(N,1);
for n=1:N
    trackLengths(n) = length(find(trackletData(:,1,n)));
end
p_init = alpha^(.5*eps);
p_term = alpha^(.5*eps);
Z = zeros(N,1);
% Quadrant 1 (clockwise)
costMat1 = -inf(N);
state_interpolations = {};
counter = 1;
for ii=1:N
    ii
    for jj=ii:N
        % False detections
        if ii == jj
            costMat1(ii,jj) = trackLengths(ii)*log(1-beta);
        else
            [costMat1(ii,jj),Z(ii),states] = calculateAffinity(ii,jj,trackletData,imageStack,windowSize,gpParams,alpha,beta,eps,distanceThreshold,p_init,p_term);
            if ~isempty(states)        
                state_interpolations{counter,1} = ii; state_interpolations{counter,2} = jj; state_interpolations{counter,3} = states;
                counter = counter + 1;
            end
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


costMat = [costMat1 costMat2; costMat4 costMat3];
costMat = -costMat;

[assignments,cost] = munkres(costMat);

associations1 = find(assignments(1:N) <= N)';
associations2 = assignments(associations1)';
associations = [associations1 associations2];

% State interpolation filter
S = size(state_interpolations,1);
new_state_interpolations = {};
counter = 1;
for i=1:S
    track1 = state_interpolations{i,1}; track2 = state_interpolations{i,2}; states = state_interpolations{i,3};
    if (track1 == associations(counter,1) && track2 == associations(counter,2))
        new_state_interpolations{counter,1} = track1; new_state_interpolations{counter,2} = track2;
        new_state_interpolations{counter,3} = states;
        counter = counter + 1;
    end
    % debug
    if counter > size(associations,1)
        break;
    end
end
old_state_interpolations = state_interpolations;
state_interpolations = new_state_interpolations;

end











