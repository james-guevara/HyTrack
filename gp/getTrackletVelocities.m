function trackletVelocities = getTrackletVelocities( tracklets )
N = size(tracklets,3);
trackletVelocities = [];
for n=1:N
    trackletVelocities(:,:,n) = getTrackletVelocity(tracklets(:,:,n));
end

end

