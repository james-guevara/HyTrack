function h = testingAssignments(tracklets,associations,imageStack)

A = [];
for i=1:size(associations,1)
    A(:,:,2*i-1:2*i) = cat(3,tracklets(:,:,associations(i,1)),tracklets(:,:,associations(i,2)));
end
trackletMask = getTrackletMask(imageStack,A);
h = imtool3D(imageStack,[],[],[],[],trackletMask);

end