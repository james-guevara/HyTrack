function [costMat, state_interpolations, assignments, associations] = makeCostMatrix( tracklets, imageStack, windowSize, gpParams, distanceThreshold, timeThreshold )
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
[T,~,N] = size(trackletData);
beta  = .999999;
eps   = timeThreshold;
alpha = .9;
% Get track lengths
trackLengths = zeros(N,1);
for n=1:N
    trackLengths(n) = length(find(trackletData(:,1,n)));
end
% p_init = alpha^(.5*eps);
% p_term = alpha^(.5*eps);

p_init = zeros(T,1);
p_term= zeros(T,1);

for uu=1:T
    p_init(uu,1)=-uu/t+1;
    p_term(uu,1)=uu/t;
end

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
    tracklet1_data = trackletData(:,:,ii);
    tracklet1_pos = find(tracklet1_data(:,1)); 
    tracklet1_end   = tracklet1_pos(end); 
    tracklet1_start = tracklet1_pos(1); 
    if (Z(ii) == 0)
        Z(ii) = p_init(tracklet1_start) + p_term(tracklet1_end);
        costMat2(ii,ii) = log(p_term(tracklet1_end)/Z(ii));
    else
        costMat2(ii,ii) = log(p_term(tracklet1_end)/Z(ii));
    end
end
% Quadrant 3
costMat3 = zeros(N);
% Quadrant 4
costMat4 = -inf(N);
for ii=1:N
    tracklet1_data = trackletData(:,:,ii);
    tracklet1_pos = find(tracklet1_data(:,1)); 
    tracklet1_end   = tracklet1_pos(end); 
    tracklet1_start = tracklet1_pos(1); 
     if (Z(ii) == 0)
        Z(ii) = p_init(tracklet1_start) + p_term(tracklet1_end);
        costMat4(ii,ii) = log(p_init(tracklet1_start)/Z(ii));
    else
        costMat4(ii,ii) = log(p_init(tracklet1_start)/Z(ii));
    end
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



