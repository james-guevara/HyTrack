% trackletVelocities = getTrackletVelocities(tracklets);
% trackletData = [tracklets trackletVelocities];
% gpParameters = getTrajectories(trackletData);
% 
%%
gpCov = [3.8438; -3.6444];
gpLik = -2.0525;
gpParameters.cov = gpCov;
gpParameters.lik = gpLik;

predictionLocs = [];
counter = 1;
for i=50:10:520
    for j=50:10:400
        predictionLocs(counter,:) = [i j];
        counter = counter + 1;
    end
end

[locMeans, locCovs] = computePredictions(gpParameters, trackletData, predictionLocs);