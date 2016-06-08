function G = createFlowGraph( tracklets, distanceThreshold, timeThreshold )
% G is acyclic directed graph. 
[T,~,N] = size(tracklets);
G = zeros(N+2);

% Construct G
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
                elseif ((indsTwo(1) - indsOne(end)) > timeThreshold)
                    break;
                end
            end
        end
    end
end


% G(end-1) is the s node. G(end) is the t node
for i=1:N
    G(end-1,i) = 1;
    G(i,end) = 1;
end

G = sparse(G);


end

