function [finalMask, regions] = MSERIsolateStarfish(mask)

    [regions,mserCC] = detectMSERFeatures(mask);

    stats = regionprops('table', mserCC,'all');
    % Following values determined by examining the stats table output.     
    prop = stats.MajorAxisLength < 500 ...
        & stats.Solidity > 0.3...
        & stats.Solidity < 0.6...
        & stats.EulerNumber >= 0 ...
        & stats.EulerNumber <= 1 ...
        & stats.Circularity < 0.35 ...
        & stats.Eccentricity > 0.2 ...
        & stats.Eccentricity < 0.8 ...
        & stats.Extent < 0.43;
    
    % Isolate connected components that conform to above metrics.
    regions = regions(prop);
    
    % Create blank mask.
    finalMask = false(size(mask));

    % Set the mask to positive in MSER regions.
    [Nregions, ~] = size(regions);
    for i = 1:Nregions
        [pixels, ~] = size(regions(i).PixelList);
        local = regions(i).PixelList;
        for j = 1:pixels
            x = local(j,1);
            y = local(j,2);
            finalMask(y, x) = true;
        end
    end
end