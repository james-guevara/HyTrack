function newSamples = drawSamples( positionSamples, stdDev )
numSamples = size(positionSamples,1);
std_xy = diag(stdDev);
newSamples = randn(numSamples, 2)*std_xy + positionSamples;
end

