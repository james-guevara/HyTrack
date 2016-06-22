function [ finalState, stateCovariance, states ] = propagateStateGP( initialState, initialTime, finalTime, gpParameters, trackletData )
temporaryState = initialState;
stateCovariance = [1 1];
states = [];
states(1,:) = initialState;
counter = 2;
if (initialTime > finalTime)
    for t=initialTime:-1:finalTime+1
        [velocityMean, velocityCovariance] = computePrediction(temporaryState,t,gpParameters,trackletData);
        temporaryState = temporaryState - velocityMean;
        stateCovariance = stateCovariance + velocityCovariance;
        states(counter,:) = temporaryState;
        counter = counter + 1;
    end
else
    for t=initialTime:finalTime-1
        [velocityMean, velocityCovariance] = computePrediction(temporaryState,t,gpParameters,trackletData);
        temporaryState = temporaryState + velocityMean;
        stateCovariance = stateCovariance + velocityCovariance;
        states(counter,:) = temporaryState;
        counter = counter + 1;
    end
end
finalState = temporaryState;

end

