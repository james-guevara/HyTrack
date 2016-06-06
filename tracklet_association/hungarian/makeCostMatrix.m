function [ costMat ] = makeCostMatrix( trackletData, imageStack, windowSize )
[T,~,N] = size(trackletData);
costMat = zeros(2*N);

p_init = -log(1/N);
p_term = -log(1/N);

for ii=1:2*N
    for jj=1:2*N
        % Diagonal elements of 1st quadrant of cost matrix
        if (ii == jj && jj <= N)
            costMat(ii,jj) = inf;
        % Affinities between actual tracklets
        elseif (ii <= N && jj <= N && ii ~= jj)
            costMat(ii,jj) = calculateAffinity(trackletData(:,:,ii),trackletData(:,:,jj), ...
                imageStack, windowSize, gpParameters);
        % Cost of initializing tracklet
        elseif (ii == (jj + N))
            costMat(ii,jj) = p_init;
        % Cost of terminating tracklet
        elseif (ii + N == jj)
            costMat(ii,jj) = p_term;
        % 3rd quadrant is all zeros
        elseif (ii > N && jj > N)
            costMat(ii,jj) = 0;
        % Other entries are inf;    
        else
            costMat(ii,jj) = inf;
        end
    end
end


[ASSIGN, COST] = munkres(costMat);


end



function c_ij = calculateAffinity(trackletData1, trackletData2, ...
    imageStack, windowSize, gpParameters)


pos1 = find(trackletData1(:,1));
pos2 = find(trackletData2(:,1));

if (pos2(1) - pos1(end) <= 0 || pos2(1) - pos1(end) > gapThresh)




end









