intensityThreshold = .12;
distanceThreshold = 3;
[cellDetections,maskStack] = detectCellStack(imageStack,intensityThreshold,distanceThreshold);
detectionStack = cellDetections(:,1);
clear cellDetections;