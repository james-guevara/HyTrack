function G = createArborescence( tracklets, distanceThreshold, timeThreshold )
% G is arborescence. Creating arborescence (first, without weights; will
% add weights later)
[T,~,N] = size(tracklets);
G = zeros(N);                   % adjacency matrix

% Construct adjacency matrix G (unity edge weights for now)
for i=1:N-1
    i
    trackletOne = tracklets(:,:,i);
    indsOne = find(trackletOne(:,1));
    coordsOne = trackletOne(indsOne,:);
    if (numel(indsOne) < T)
        for j=i+1:N
            trackletTwo = tracklets(:,:,j);
            indsTwo = find(trackletTwo(:,1));
            coordsTwo = trackletTwo(indsTwo,:);
            % If there is no conflict in time between the two tracklets
            if (isempty(intersect(indsOne,indsTwo)))
                % If the two tracklets are within a distance threshold and time
                % threshold
                if ((pdist2(coordsOne(end,:),coordsTwo(1,:)) < distanceThreshold) && ...
                        ((indsTwo(1) - indsOne(end)) < timeThreshold))
                    G(i,j) = 1;
                % If the two tracklets are far separated in time, break    
                elseif ((indsTwo(1) - indsOne(end)) > timeThreshold)
                    break;
                end
            
            end
        end
    end
end
% For the P_initialize
for i=1:N
    G(i,i) = 1;
end

G = sparse(G);


end

