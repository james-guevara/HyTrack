function [ newDetections ] = mergeDetections( detections, distanceThreshold )
[rows,cols] = size(detections);
xyCoords = detections(:,1:2);
amps     = detections(:,3);
for i=1:rows
    if (xyCoords(i,:) == [0 0])
        continue;
    else
        for j=i+1:rows
            if (dist(xyCoords(i,:),xyCoords(j,:)) < distanceThreshold)
                if (amps(i) > amps(j))
                    xyCoords(j,:) = [0 0];
                else
                    xyCoords(i,:) = [0 0];
                    continue;
                end
            end
        end
    end
end

counter = 1;
for i=1:rows
    if (xyCoords(i,:) ~= [0 0])
        newDetections(counter,1:2) = xyCoords(i,:);
        newDetections(counter,3)   = amps(i,:);
        counter = counter + 1;
    end
end

    function distance = dist(a,b)
        distance = sqrt((a(1)-b(1))^2 + (a(2)-b(2))^2);
    end




end

