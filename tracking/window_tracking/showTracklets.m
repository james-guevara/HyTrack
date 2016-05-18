function trackletMask = showTracklets( imageStack, tracklets )
[~,~,T] = size(imageStack);
trackletMask = zeros(size(imageStack));
[~,~,N] = size(tracklets);
for t=1:T
    for n=1:N
        if (tracklets(t,:,n) ~= [0 0])
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n)),t) = 1;
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n))-1,t) = 1;
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n))+1,t) = 1;
            trackletMask(round(tracklets(t,2,n))-1,round(tracklets(t,1,n)),t) = 1;
            trackletMask(round(tracklets(t,2,n))+1,round(tracklets(t,1,n)),t) = 1;
        end
    end
end



end

