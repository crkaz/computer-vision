function [finalMask, n] = Process(path, outputs)
    addpath('./functions/');
    
    oim = imread(path);
    
    % Run p2 on all images.
    [p2Mask, ~] = p2(path, outputs); % Pipeline 2 : good/inaccurate masks.
    finalMask = p2Mask; % If no blobs detected in p1 we just use p2 mask.
    
    % Only run p1 on non-cluttered/occluded images, then combine ...
    ... with output of p2.
    runP1 = not(IsCluttered(oim));
    if (runP1)
        [p1Mask, ~] = p1(path, outputs);

        % Combine outputs of P1 and P2 (if there are any blobs in p1).
        [p1CC, p1NBlobs] = bwlabeln(p1Mask);
        if (p1NBlobs > 0)
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

            finalMask = combinedMask;
        end
    end

    % Output all steps in one figure.
    if (outputs)
        if (runP1)
            outputProcess(2,3, oim, p1Mask, p2Mask, finalMask);
        else
            outputProcess(2,3, oim, "null", p2Mask, finalMask);
        end
    end
    
    % Get final mask and number of detections.
    [finalMask, n] = bwlabel(finalMask);
end