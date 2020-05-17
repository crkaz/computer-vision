% 
% Estimate whether an image is cluttered/occluded by calculating the ...
% ... percentage of black pixels in a mask.
% 
function bool = IsCluttered(bw)
    THRESHOLD = 0.3; % >30% black pixels i
    dims = ndims(bw);
    
    if (dims == 2)
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