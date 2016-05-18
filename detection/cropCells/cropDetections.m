function imageCrops = cropDetections( detectionStack, imageStack, windowSize )
[~,~,T] = size(imageStack);
imageCrops = [];
counter = 1;
for t=1:T
    N = size(detectionStack{t},1);
    for n=1:N
        initialPosition = [detectionStack{t}(n,1) detectionStack{t}(n,2)];
        rect = [initialPosition(1)-floor(windowSize(1)/2) initialPosition(2)-floor(windowSize(2)/2) ...
            windowSize(1) windowSize(2)];
        imageCrops(:,:,counter) = im2double(imcrop(imageStack(:,:,t),rect));
        counter = counter + 1;
    end
end


end

