function [trackletIndices1, trackletIndices2] = getUnlinkedTracklets( tracklets, costMat )
[~,~,N] = size(tracklets);
costMat1 = costMat(1:N,1:N);
counter1 = 1;
trackletIndices1 = [];
counter2 = 1;
trackletIndices2 = [];
for n=1:N
    inds = find(costMat1(n,:) ~= inf);
    if numel(inds) == 1
        trackletIndices1(counter1,1) = n;
        counter1 = counter1 + 1;
    else
        trackletIndices2(counter2,1) = n;
        counter2 = counter2 + 1;
    end
end

end

