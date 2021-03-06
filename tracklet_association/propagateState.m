function [ finalState, stateCovariance, states ] = propagateState( initialState, initialTime, numTimes, gpParameters, trackletData)
% initialState corresponds to tail of an initial tracklet.
% numTimes is how many times you want to propagate the state into the
% future.
temporaryState = initialState;
stateCovariance = [1 1];
states = [];
states(1,:) = initialState;
counter = 2;
for t=initialTime:initialTime+numTimes-1
    [velocityMean, velocityCovariance] = computePrediction(temporaryState,t,gpParameters,trackletData);
    temporaryState = temporaryState + velocityMean;
    stateCovariance = stateCovariance + velocityCovariance;
    states(counter,:) = temporaryState;
    counter = counter + 1;
end
finalState = temporaryState;

end

