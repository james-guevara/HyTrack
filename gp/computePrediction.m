function [ locMean, locCov ] = computePrediction( initialPosition, initialTime, gpParameters, trackletData )
[~,~,N] = size(trackletData);
covfunc = @covSEiso;
likfunc = @likGauss;
locMean = zeros(1,2);
locCov  = zeros(1,2);
% Obtain subset of trackletData that is nonzero at frame t
locs = [];
vels = [];
counter = 1;
for n=1:N
    if (trackletData(initialTime,1:2,n) ~= [0 0])
        locs(counter,1) = trackletData(initialTime,1,n);
        locs(counter,2) = trackletData(initialTime,2,n);
        vels(counter,1) = trackletData(initialTime,3,n);
        vels(counter,2) = trackletData(initialTime,4,n);
        counter = counter + 1;
    end
end
[locMean(1), locCov(1)] = gp(gpParameters, @infExact, [], ...
    covfunc, likfunc, locs, vels(:,1), initialPosition);
[locMean(2), locCov(2)] = gp(gpParameters, @infExact, [], ...
    covfunc, likfunc, locs, vels(:,2), initialPosition);
    


end

