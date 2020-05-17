% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Estimate whether an image is low contrast by checking the range of ...
% ... n% of the distribution, centred around the mean.
function bool = isLowContrast(im)
    dims = ndims(im);
    
    if (dims == 2)
            bool = isLowContrast2(im);
    elseif (dims == 3)
            [c1Lc, c2Lc, c3Lc] = isLowContrast3(im);
            bool = [c1Lc, c2Lc, c3Lc];
    else
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function bool = isLowContrast2(im)
    % Thresholds explained: if 85% of the pixels are within 100px range ...
    % ... centred around the mean, assume low contrast.
    PERCENTAGE_THRESHOLD = 0.85;
    RANGE_THRESHOLD = 50;
    
    % Calculate range of pixel values; small range suggests low contrast.
    theMin = min(im(:));
    theMax = max(im(:));
    theRange = theMax - theMin;
    
    % Calculate bounds for a window centred around the mean.
    theMean = mean(im(:));
    upperBound = theMean + RANGE_THRESHOLD;
    lowerBound = theMean - RANGE_THRESHOLD;
    
    % Calculate the percentage of all pixels in this window/range.
    totalPixels = numel(im(:));
    pixelsInBounds = im >=lowerBound & im <= upperBound;
    nPixelsInBounds = sum(pixelsInBounds(:));
    percentageInBounds = roundn(nPixelsInBounds / totalPixels, -2);

    % If most pixels (PERCENTAGE_TRHESHOLD) fall into this range...
    % ... assume the image is low contrast.
    bool = false; % Contrast is OK.
    if (theRange <= RANGE_THRESHOLD || percentageInBounds >= PERCENTAGE_THRESHOLD)
        bool = true; % Low contrast.
    end
end

% For 3D arrays.
function [c1Lc, c2Lc, c3Lc] = isLowContrast3(im)
    % Call 2D operation on each of the channels.
    [c1, c2, c3] = imsplit(im);
    c1Lc = isLowContrast2(c1);
    c2Lc = isLowContrast2(c2);
    c3Lc = isLowContrast2(c3);
end