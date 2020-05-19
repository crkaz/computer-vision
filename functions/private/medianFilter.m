% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Median Filter implementation for the sake of shorthand.
function filtered = medianFilter(im, nhood)
    % Ensure neighbourhood is an odd number > 2.
    if (mod(nhood, 2) == 0 || nhood < 3)
        error("MeanFilter(): nhood must be odd and at least 3");
    end

    dims = ndims(im);
    
    if (dims == 2)
        filtered = medianFilter2(im, nhood);
    elseif (dims == 3)
        filtered = medianFilter3(im, nhood);
    else
        error("MeanFilter(): Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function filtered = medianFilter2(im, nhood)
    filtered = medfilt2(im, [nhood, nhood]);
end

% For 3D arrays.
function filtered = medianFilter3(im, nhood)
    % Call 2D operation on each of the channels.
    [c1,c2,c3] = imsplit(im);
    c1 = medianFilter2(c1, nhood);
    c2 = medianFilter2(c2, nhood);
    c3 = medianFilter2(c3, nhood);
    filtered = cat(3, c1,c2,c3);
end