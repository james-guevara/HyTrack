function newDetections = removeDetections( detections, rows, cols )
N = size(detections,1);
counter = 1;
for n=1:N
    if (detections(n,1) < cols-5 && detections(n,1) > 5 ...
            && detections(n,2) < rows-5 && detections(n,2) > 5)
        newDetections(counter,1) = detections(n,1);
        newDetections(counter,2) = detections(n,2);
        newDetections(counter,3) = detections(n,3);
        counter = counter + 1;
    end
end

end

