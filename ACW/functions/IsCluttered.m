% 
% Estimate whether an image is cluttered/occluded by calculating the ...
% ... percentage of black pixels in a Otsu's Thresholded mask of the ...
% ... original image.
% 
function bool = IsCluttered(im)
    THRESHOLD = 0.37; % >37% black pixels
    dims = ndims(im);
    
    if (dims == 3 || dims == 2)
        
        level = graythresh(im);
        bw = imbinarize(im, level);
        
        nWhitePixels = sum(bw(:));
        nBlackPixels = numel(bw(:)) - nWhitePixels;
        percentage = (nBlackPixels / numel(bw(:)));
                
        bool = false;
        if (percentage >= THRESHOLD)
            bool = true;
        end
    else
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end