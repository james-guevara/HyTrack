function [ locMean, locCov ] = computePrediction_XYT( initialPosition, initialTime, gpParameters, trackletData, timeWindow )
% Incorporates temporal information (i.e. a time window) when making
% predictions of the velocity at some spatiotemporal location
% initialPosition.
initialXYT = [initialPosition initialTime];
[T,~,N] = size(trackletData);
covfunc = @covSEard;
likfunc = @likGauss;
locMean = zeros(1,2);
locCov  = zeros(1,2);
% Obtain subset of trackletData that is nonzero at frame t
locs = [];
vels = [];
counter = 1;
for n=1:N
    for t=initialTime-timeWindow:initialTime+timeWindow
        if t >= 1 && t <= T
            if (trackletData(t,1:2,n) ~= [0 0])
                locs(counter,1) = trackletData(t,1,n);
                locs(counter,2) = trackletData(t,2,n);
                locs(counter,3) = t;
                vels(counter,1) = trackletData(t,3,n);
                vels(counter,2) = trackletData(t,4,n);
                counter = counter + 1;
            end
        end
    end
end
[locMean(1), locCov(1)] = gp(gpParameters, @infExact, [], ...
    covfunc, likfunc, locs, vels(:,1), initialXYT);
[locMean(2), locCov(2)] = gp(gpParameters, @infExact, [], ...
    covfunc, likfunc, locs, vels(:,2), initialXYT);
    

end

