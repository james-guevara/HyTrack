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
for i=10:10:160
    for j=10:10:160
        predictionLocs(counter,:) = [i j];
        counter = counter + 1;
    end
end

[locMeans, locCovs] = computePredictions(gpParameters, trackletData, predictionLocs);

plotVectorFields(imageStack,predictionLocs,locMeans,trackletData);

%% S2 parameters
gpCov = [1.1176; -1.1311];
gpLik = -7.7531;
gpParameters.cov = gpCov;
gpParameters.lik = gpLik;

predictionLocs = [];
counter = 1;
for i=10:10:160
    for j=10:10:160
        predictionLocs(counter,:) = [i j];
        counter = counter + 1;
    end
end

[locMeans, locCovs] = computePredictions(gpParameters, trackletData, predictionLocs);

plotVectorFields(imageStack,predictionLocs,locMeans,trackletData);









