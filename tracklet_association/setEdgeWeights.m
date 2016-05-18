function newG = setEdgeWeights( G, imageStack, trackletData, ... 
    gpParameters, entranceProbability, windowSize, maskStack )
% entranceProbability is vector with T elements, either uniform or
% decreasing (as you reach later portion of movie, probability of entrance
% goes to 0)
newG = G;
N = size(newG,1);

for i=1:N-1
    i
    for j=i+1:N
        if (newG(i,j) == 1)
            trackletTemplateOne = averageTemplate(imageStack, trackletData(:,1:2,i), windowSize);
            trackletTemplateTwo = averageTemplate(imageStack, trackletData(:,1:2,j), windowSize);
            newG(i,j) = log((90 - imagesAngle(trackletTemplateOne,trackletTemplateTwo))/90);
%             if (isnan(G(i,j)))
%                 G(i,j) = 0;
%             end
            % Propagate final state of trackletOne
            indicesOne = find(trackletData(:,1,i));
            indexOne = indicesOne(end);
            stateOne = trackletData(indexOne,1:2,i);
            indicesTwo = find(trackletData(:,1,j));
            indexTwo = indicesTwo(1);
            stateTwo = trackletData(indexTwo,1:2,j);
            timeDifference = indexTwo - indexOne;
            [stateMean, stateCovariance] = propagateState(stateOne,indexOne,timeDifference,gpParameters,trackletData);
            newG(i,j) = newG(i,j) + log(mvnpdf(stateTwo,stateMean,diag(stateCovariance)));
        end
    end
end


for i=1:N
    newG(i,i) = log(entranceProbability);
end



end

