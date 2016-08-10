distanceThreshold = 10;
timeThreshold = 30;
alpha = .4;
maxDistancePerFrame = 3;
gpCov = [log(15); log(3)];
gpLik = -7;
gpParams.cov = gpCov; gpParams.lik = gpLik;
windowSize = [6 6];
[ costMat, stateInterpolations, assignments, associations ] = getCostMatrix( tracklets, imageStack, windowSize, gpParams, ...
    distanceThreshold, timeThreshold, maxDistancePerFrame, alpha);

newTracklets = mergeTracklets(tracklets,associations);
newTracklets2 = interpolateTracklets(newTracklets,gpParams);

%%
alpha = .1;
timeThreshold = 80;
[costMat2,stateInterpolations2,assignments2,associations2] = getCostMatrix(newTracklets2,imageStack,windowSize,gpParams,...
    distanceThreshold,timeThreshold,maxDistancePerFrame,alpha);
newTracklets3 = mergeTracklets(newTracklets2,associations2);
newTracklets4 = interpolateTracklets(newTracklets3,gpParams);
trackletMask = getTrackletMask(imageStack,newTracklets4);
% mergeTracklets
% interpolateTracklets

%%
timeThreshold = 120;
[costMat3,stateInterpolations3,assignments3,associations3] = getCostMatrix(newTracklets4,imageStack,windowSize,gpParams,...
    distanceThreshold,timeThreshold,maxDistancePerFrame,alpha);
newTracklets5 = mergeTracklets(newTracklets4,associations3);
newTracklets6 = interpolateTracklets(newTracklets5,gpParams);
trackletMask2 = getTrackletMask(imageStack,newTracklets6);

%%
timeThreshold = 200;
[costMat6,stateInterpolations6,assignments6,associations6] = getCostMatrix(newTracklets6,imageStack,windowSize,gpParams,...
    distanceThreshold,timeThreshold,maxDistancePerFrame,alpha);
newTracklets7 = mergeTracklets(newTracklets6,associations6);
newTracklets8 = interpolateTracklets(newTracklets7,gpParams);
trackletMask3 = getTrackletMask(imageStack,newTracklets8);

