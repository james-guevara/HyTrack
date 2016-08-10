function trackletMask = getTrackletMask( imageStack, tracklets )
[rows,cols,T] = size(imageStack);
trackletMask = zeros(size(imageStack));
[~,~,N] = size(tracklets);
for t=1:T
    for n=1:N
        if (tracklets(t,1,n) ~= 0 && tracklets(t,2,n) ~= 0 && tracklets(t,1,n) > 5 && tracklets(t,1,n) < cols-5 && tracklets(t,2,n) > 5 && tracklets(t,2,n) < rows-5)
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n)),t) = 1;
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n))-1,t) = 1;
            trackletMask(round(tracklets(t,2,n)),round(tracklets(t,1,n))+1,t) = 1;
            trackletMask(round(tracklets(t,2,n))-1,round(tracklets(t,1,n)),t) = 1;
            trackletMask(round(tracklets(t,2,n))+1,round(tracklets(t,1,n)),t) = 1;
        end
    end
end



end

