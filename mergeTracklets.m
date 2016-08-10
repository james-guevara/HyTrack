function newTracklets = mergeTracklets( tracklets, associations )
tmpTracklets = tracklets;
[T,~,N] = size(tracklets);
numAssociations = size(associations,1);
for n=1:numAssociations
    trackletOne = tracklets(:,:,associations(n,1));
    trackletTwo = tracklets(:,:,associations(n,2));
    indsOne = find(trackletOne(:,1));
    indsTwo = find(trackletTwo(:,1));
    tmpTracklets(indsOne,:,associations(n,1)) = trackletOne(indsOne,:);
    tmpTracklets(indsTwo,:,associations(n,1)) = trackletTwo(indsTwo,:);
    tmpTracklets(:,:,associations(n,2)) = zeros(T,2);
end
newTracklets = [];
counter = 1;
for n=1:N
    for t=1:T
        if (tmpTracklets(t,:,n) ~= [0 0])
            newTracklets(:,:,counter) = tmpTracklets(:,:,n);
            counter = counter + 1;
            break;
        end
    end
end
end

