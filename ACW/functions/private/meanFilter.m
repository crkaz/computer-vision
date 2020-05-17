% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Mean Filter implementation. Could add padding parameter but no need for
% anything other than same right now, and no default params make it
% tedious.
function filtered = MeanFilter(im, nhood)
    % ensure neighbourhood is an odd number > 1.
    if (mod(nhood, 2) == 0 || nhood < 3)
        error("MeanFilter(): nhood must be odd and greater than 3");
    end

    dims = ndims(im);
    
    if (dims == 2)
        filtered = meanFilter2(im, nhood);
    elseif (dims == 3)
        filtered = meanFilter3(im, nhood);
    else
        error("MeanFilter(): Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function filtered = meanFilter2(im, nhood)
    div = nhood^2;
    filtered = imfilter(im,ones(nhood)/div, 'same');
end

% For 3D arrays.
function filtered = meanFilter3(im, nhood)
    % Call 2D operation on each of the channels.
    [c1,c2,c3] = imsplit(im);
    c1 = meanFilter2(c1, nhood);
    c2 = meanFilter2(c2, nhood);
    c3 = meanFilter2(c3, nhood);
    filtered = cat(3, c1,c2,c3);
end