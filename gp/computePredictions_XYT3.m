function [ locMeans, locCovs ] = computePredictions_XYT3( gpParams, tracklets, timeWindow, predictionLocs )
% Incorporates temporal information (i.e. a time window) when making
% predictions of the velocity at some spatiotemporal location
% initialPosition.
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
[T,~,N] = size(trackletData);
cgi_x = @covSEiso; cgi_y = @covSEiso; cgi_t = @covSEiso;
covfunc = {@covProd,{cgi_x,cgi_y,cgi_t}};
lik1 = @likGauss; lik2 = @likGauss; lik3 = @likGauss;
likfunc = {@likMix,{lik1,lik2,lik3}};
% hyp0 = []; hyp1 = [];
% mpr = {@meanProd,{'meanZero','meanZero'}}; hypmpr = [hyp0; hyp1];
locMeans = [];
locCovs  = [];
% Obtain subset of trackletData that is nonzero at frames within time
% window
for t=1:T
    t
    locs = [];
    vels = [];
    counter = 1;
    for n=1:N
        for i=t-timeWindow:t+timeWindow
            if i >= 1 && i <= T
                if (trackletData(i,1:2,n) ~= [0 0])
                    locs(counter,1) = trackletData(i,1,n);
                    locs(counter,2) = trackletData(i,2,n);
                    locs(counter,3) = i;
                    vels(counter,1) = trackletData(i,3,n);
                    vels(counter,2) = trackletData(i,4,n);
                    counter = counter + 1;
                end
            end
        end
    end
    currTime = t*ones(size(predictionLocs,1),1);
    % xytLocs = [predictionLocs currTime]; 
    xytLocs = predictionLocs;
    [locMeans(:,1,t), locCovs(:,1,t)] = gp(gpParams, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,1), xytLocs);
    [locMeans(:,2,t), locCovs(:,2,t)] = gp(gpParams, @infExact, [], ...
        covfunc, likfunc, locs, vels(:,2), xytLocs);
end

end

