function [ locMeans, locCovs ] = computePredictions_XYT( gpParameters, tracklets, timeWindow, predictionLocs )
% gpParameters: Nx2 cell array, format: [struct1 struct2], where struct1
% contains hyperparameters (cov and lik) for x, and struct2 contains
% hyperparamters for y
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
[T,~,N] = size(trackletData);
locMeans = [];
locCovs  = [];
covfunc = @covSEard;
likfunc = @likGauss;
for t=1:T
    t
    % Obtain subset of trackletData that is nonzero at frame t
    locs = [];
    vels = [];
    counter = 1;
    for n=1:N
        for i=t-timeWindow:t+timeWindow
            if i >= 1 && i <= T
                if (trackletData(i,1:2,n) ~= [0 0])
                    locs(counter,1) = trackletData(i,1,n);
                    locs(counter,2) = trackletData(i,2,n);
                    locs(counter,3) = i;
                    vels(counter,1) = trackletData(i,3,n);
                    vels(counter,2) = trackletData(i,4,n);
                    counter = counter + 1;
                end
            end
        end
    end
    currTime = t*ones(size(predictionLocs,1),1);
    xytLocs = [predictionLocs currTime];
    [locMeans(:,1,t), locCovs(:,1,t)] = gp(gpParameters, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,1), xytLocs);
    [locMeans(:,2,t), locCovs(:,2,t)] = gp(gpParameters, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,2), xytLocs);
    
end


end

