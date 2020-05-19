% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Uses MATLAB's adapthisteq() to locally adjust the contrast of the input
% image. This was discovered as the best option (from imadjust, histeq) in
% most cases, although imadjust performs nearly as well
function imP = enhanceContrast(im)
    dims = ndims(im); % Get n channels.
    
    if (dims == 2)
            imP = enhanceContrast2(im);
    elseif (dims == 3)
            imP = enhanceContrast3(im);        
    else
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function imP = enhanceContrast2(im)
    imP = adapthisteq(im);
end

% For 3D arrays.
function imP = enhanceContrast3(im)
    % Call 2D operation on each of the channels.
    [c1, c2, c3] = imsplit(im);
    c1Nl = enhanceContrast2(c1);
    c2Nl = enhanceContrast2(c2);
    c3Nl = enhanceContrast2(c3);
    imP = cat(3, c1Nl, c2Nl, c3Nl);
end