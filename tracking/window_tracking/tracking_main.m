%%
thresholdParams = struct;
thresholdParams.distanceThreshold = 3;
thresholdParams.intensityThreshold = 0;
thresholdParams.angleThreshold = 50;
windowSize = [6 6];
windowSearchSize = 3;

[tracklets, newDetectionStack] = buildTracklets(imageStack, detectionStack, thresholdParams, ...
    windowSize, windowSearchSize);

trackletMask2 = showTracklets(imageStack,tracklets);