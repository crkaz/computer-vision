function [finalMask, n] = Process(path, outputs)
    addpath('./functions/');
    
    oim = imread(path);
    
    % Run p2 on all images.
    [p2Mask, ~] = p2(path, outputs); % Pipeline 2 : good/inaccurate masks.
    finalMask = p2Mask; % If no blobs detected in p1 we just use p2 mask.
    
    
    % Run p1 on non-cluttered/occluded images, then combine with output
    % ... of p2..
    runP1 = not(IsCluttered(oim));
    if (runP1)
        [p1Mask, ~] = p1(path, outputs);

        % Combine outputs of P1 and P2 (if there are any blobs in p1).
        [p1CC, p1NBlobs] = bwlabeln(p1Mask);
        if (p1NBlobs > 0)
            finalMask = combineOutputs(p1Mask, p1CC, p2Mask);
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