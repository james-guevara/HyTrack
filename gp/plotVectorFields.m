function plotVectorFields( imageStack, predictionLocs, locMeans, trackletData )
[T,~,N] = size(trackletData);

for t=1:T
    % Obtain subset of trackletData that is nonzero at frame t
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
    
    h = figure;
    imshow(imageStack(:,:,t)); truesize(h); hold on;
    quiver(predictionLocs(:,1),predictionLocs(:,2),locMeans(:,1,t),locMeans(:,2,t));
    quiver(locs(:,1),locs(:,2),vels(:,1),vels(:,2));
    set(gca,'YDir','reverse');
    % Save image
    filename = ['imagesDir/' num2str(t, '%04d'), '.jpg'];
    saveas(h,filename);
    close(h);
end



end

