% The purpose of compbineOutputs() is to enhance the basic/rough masks ...
% produced by  p1 by isolating the better masks in the noiser p2.
function compositeMask = combineOutputs(p1Mask, p1CC, p2Mask)
    [p2CC, ~] = bwlabeln(p2Mask);
    p1Centroids = regionprops(p1CC, "Centroid");
    p1BBs = regionprops(p1CC,'Boundingbox');
    combinedMask = p1Mask;
    whiteAreas = p1Mask == 1;
    combinedMask(whiteAreas) = 0;
            
    % See if P1 region collides with a P2 region by checking pixel in ...
    % ... P2 at centroid of P1.
    for i = 1:length(p1Centroids)
        centroid = p1Centroids(i).Centroid;
        y = floor(centroid(2));
        x = floor(centroid(1));
        p2PixelValue = p2CC(y,x);
        p1BB = p1BBs(i).BoundingBox;
        p1BBArea = p1BB(3) * p1BB(4);

        if (p2PixelValue > 0) % value > 0 represents blob id from bwlabeln(..).
            % Hit: add the best (largest area up to 100%, at which point ...
            ...assume a erroneous blob in p2) mask to the combined mask.
            p2Region = p2CC == p2PixelValue; % Isolate the blob.
            regionBBs = regionprops(p2Region,'Boundingbox');
            p2BB = regionBBs(1).BoundingBox;
            p2BBArea = p2BB(3) * p2BB(4);

            if (p2BBArea > p1BBArea && p1BBArea * 2.5 > p2BBArea)
                % Keep the p2 mask as it is larger than the p1 mask.
                combinedMask(p2Region) = 1; % Add blob to mask.
            else
                % Keep the p1 mask as it is larger or the p2 mask ...
                ... seems erroneous.
                p1Region = p1CC == i; % Isolate blob.
                combinedMask(p1Region) = 1; % Use blob as index.
            end
        end
    end

    compositeMask = combinedMask;
end