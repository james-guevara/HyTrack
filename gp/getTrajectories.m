function [ gpParameters ] = getTrajectories( trackletData )
%% trackletData format: Tx4xN, where columns are [xCoord yCoord xVel yVel]
[T,~,N] = size(trackletData);
% Covariance function and likelihood function from GPML toolbox
covfunc = @covSEiso;
likfunc = @likGauss;

hypx.cov = [2 ; 0];
hypx.lik = log(0.1);
hypy.cov = [2 ; 0];
hypy.lik = log(0.1);

gpParameters = {};

for t=1:T
    locs = [];
    vels = [];
    counter = 1;
    for n=1:N
        if (trackletData(t,1:2,n) ~= [0 0])
            locs(counter,1) = trackletData(t,1,n);
            locs(counter,2) = trackletData(t,2,n);
            vels(counter,1) = trackletData(t,3,n);
            vels(counter,2) = trackletData(t,4,n);
            counter = counter + 1;
        end
    end
    
    % Optimize hyperparameters for x and y velocities
    hypx = minimize(hypx, @gp, -100, @infExact, [], covfunc, likfunc, locs, vels(:,1));
    hypy = minimize(hypy, @gp, -100, @infExact, [], covfunc, likfunc, locs, vels(:,2));
    
    gpParameters{t,1} = hypx;
    gpParameters{t,2} = hypy;
        
end

end

