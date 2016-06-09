function [newTracklets, trackletIndices] = mergeTracklets( tracklets, assignments )
% [T,~,N] = size(tracklets);
% newAssignment = assignment;
% newTracklets = zeros(size(tracklets));
% counter = 1;
% for n=1:N
%     indexOne = n;
%     indexTwo = newAssignment(n);
%     if (indexTwo > N)
%         newTracklets(:,:,counter) = tracklets(:,:,indexOne);
%         counter = counter + 1;
%     else
%         trackletOne = tracklets(:,:,indexOne);
%         indsOne = find(trackletOne(:,1));
%         newTracklets(indsOne,:,counter) = trackletOne(indsOne,:);
%         trackletTwo = tracklets(:,:,indexTwo);
%         indsTwo = find(trackletTwo(:,1));
%         newTracklets(indsTwo,:,counter) = trackletTwo(indsTwo,:);
%         counter = counter + 1;
%     end
% end
% 
% newTracklets = newTracklets(:,:,1:counter-1);


[T,~,N] = size(tracklets);
trackletIndices = {};
newAssignments = assignments;
% Obtain indices for same tracklets
k = 1;
for n=1:N
    if (newAssignments(n) ~= 0)
        indices = [];
        indices(1) = n;
        prevIndex  = newAssignments(n);
        counter   = 2;
        while (prevIndex < N)
            indices(counter) = prevIndex;
            prevIndex = newAssignments(prevIndex);
            newAssignments(indices(counter)) = 0;
            counter = counter + 1;
        end
        trackletIndices{k,1} = indices;
        k = k + 1;
    end
end
% Build new tracks
counter=-1;
numTracks = length(trackletIndices);
newTracklets = zeros(T,2,numTracks);
for i=1:numTracks
    tmpIndices = trackletIndices{i};
    for j=1:length(tmpIndices)
        tmpTracklet = tracklets(:,:,tmpIndices(j));
        positionIndices = find(tmpTracklet(:,1));
        if counter~=-1
            z2=tmpTracklet(positionIndices(1),:);
            x2=z2(1);
            y2=z2(2);
            gapNum=positionIndices(1)-counter-1;
            for kk=counter+1:positionIndices(1)-1
                uu=kk-counter;
                newTracklets(kk,1,i)=(x2-x1)*uu/gapNum +x1; 
                newTracklets(kk,2,i)=(y2-y1)*uu/gapNum +y1;
            end
        end
        newTracklets(positionIndices,:,i) = tmpTracklet(positionIndices,:);
        counter=positionIndices(end);
        z1=tmpTracklet(counter,:);
        x1=z1(1);
        y1=z1(2);
    end
end









end