function dists = detectionDistances( detection, detectionStack )
T = numel(detectionStack);
dists = [];
counter = 1;
for t=1:T
    N = size(detectionStack{t},1);
    for n=1:N
        dists(counter,1) = pdist2(detection(1:2),detectionStack{t}(n,1:2));
        counter = counter + 1;
    end
end

end

