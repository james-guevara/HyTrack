function [ locMeans, locCovs ] = computePredictions( gpParameters, trackletData, predictionLocs )
% gpParameters: Nx2 cell array, format: [struct1 struct2], where struct1
% contains hyperparameters (cov and lik) for x, and struct2 contains
% hyperparamters for y
[T,~,N] = size(trackletData);
locMeans = [];
locCovs  = [];
covfunc = @covSEiso;
likfunc = @likGauss;
for t=1:T
    % Obtain subset of trackletData that is nonzero at frame t
    locs = [];
    vels = [];
    counter = 1;
    for n=1:N
        if (trackletData(t,1:2,n) ~= [0 0])
            locs(counter,1) = trackletData(t,1,n);
            locs(counter,2) = trackletData(t,2,n);
            vels(counter,1) = trackletData(t,3,n);
            vels(counter,2) = trackletData(t,4,n);
            counter = counter + 1;
        end
    end
    [locMeans(:,1,t), locCovs(:,1,t)] = gp(gpParameters, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,1), predictionLocs);
    [locMeans(:,2,t), locCovs(:,2,t)] = gp(gpParameters, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,2), predictionLocs);
    
end


end

