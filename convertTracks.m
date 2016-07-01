function tracklets = convertTracks( imageStack, xmlFile )
[trackMateTracks, ~] = importTrackMateTracks(xmlFile);
[rows,cols,T] = size(imageStack);
N = numel(trackMateTracks);
tracklets = zeros(T,2,N);
for n=1:N
    tmpTrack = trackMateTracks{n};
    tmpTrack(:,1:3) = tmpTrack(:,1:3) + 1;
    tracklets(tmpTrack(:,1),:,n) = round(tmpTrack(:,2:3));
end

for n=1:N
    for t=1:T
        if (tracklets(t,1,n) > rows+5 || tracklets(t,2,n) > cols+5 || ...
            tracklets(t,1,n) < 5 || tracklets(t,2,n) < 5)
            tracklets(t:T,:,n) = repmat([0 0],T-t+1,1);
        end
    end
end
counter1=0;
counter2=0;
for n=1:N
    trkStart=find(tracklets(:,1,n)); 
    for t=trkStart(1):trkStart(end)
        if tracklets(t,1,n)==0 && counter2==0;
            counter1=t;
            counter2=-1;
        end
        if counter1~=0 &&tracklets(t,1,n)~=0
            counter2=t;
            r33=counter2-counter1;
            r11=tracklets(counter1-1,1,n);
            r12=tracklets(counter2,1,n);
            r21=tracklets(counter1-1,2,n);
            r22=tracklets(counter2,1,n);
            for h=counter1:counter2-1
                r44=h-counter1+1;
                tracklets(counter1-1,1,n)=(r12-r11)*r44/r33 +r12;
                tracklets(counter1-1,2,n)=(r22-r21)*r44/r33 +r22;
            end
            counter1=0;
            counter2=0;
        end
        
        
        
    end
end


end