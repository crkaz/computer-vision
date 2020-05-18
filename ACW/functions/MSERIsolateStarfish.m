function maskall = MSERIsolateStarfish(mask)

    [regions,mserCC] = detectMSERFeatures(mask);
    figure;
    imshow(mask);
    hold on;
    plot(regions,'showPixelList',true,'showEllipses',true);

    stats = regionprops('table',mserCC,'all');
    prop = stats.MajorAxisLength < 500 ...
        & stats.Solidity > 0.3...
        & stats.Solidity < 0.6...
        & stats.EulerNumber >= 0 ...
        & stats.EulerNumber <= 1 ...
        & stats.Circularity < 0.35 ...
        & stats.Eccentricity > 0.2 ...
        & stats.Eccentricity < 0.8 ...
        & stats.Extent < 0.45;

    regions = regions(prop);
    
    imshow(mask);
    hold on;
    plot(regions,'showPixelList',true,'showEllipses',false);

    % GET MASK WITH ONLY MSER DETECTIONS.
    maskall = false(size(mask));

    [Nregions, ~] = size(regions);
    for i = 1:Nregions
        [pixels, ~] = size(regions(i).PixelList);
        local = regions(i).PixelList;
        for j = 1:pixels
            x = local(j,1);
            y = local(j,2);
            maskall(y, x) = true;
        end
    end
end