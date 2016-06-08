%%
thresholdParams = struct;
thresholdParams.distanceThreshold = 2.5;
thresholdParams.intensityThreshold = .04;
thresholdParams.angleThreshold = 50;
windowSize = [6 6];
windowSearchSize = 4;

[tracklets, newDetectionStack] = buildTracklets(imageStack, detectionStack, thresholdParams, ...
    windowSize, windowSearchSize);

trackletMask = showTracklets(imageStack,tracklets);