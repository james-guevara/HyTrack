function newSamples = resample( currSamples, sampleWeights )
N = size(currSamples,1);    % number of samples
R = cumsum(sampleWeights);
% if (~ismonotonic(R))
% end
T = rand(N,1);              % generate N random numbers between [0,1]

% Resampling
[~, I] = histc(T,R);
newSamples = currSamples(I+1,:);



end

