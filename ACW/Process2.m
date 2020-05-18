function [finalMask, n] = Process2(path)
    figure
    oim = imread(path);
    imshow(oim);
    title("Original");

    imArea = numel(oim(:,:,1));
    maxBlobSize = imArea * 0.025;%0.015
    minBlobSize = imArea * 0.0015;%0.006

    % Orientate landscape for morphological ops.
%     [h,w,~] = size(oim);
%     if (h > w)
%         oim = rot90(oim);
%         oim = rot90(oim);
%         oim = rot90(oim);
%     end

    % % Denoise.
    im = oim;
    [c1,c2,c3] = imsplit(im);
    c1 = medfilt2(c1);
    c2 = medfilt2(c2);
    c3 = medfilt2(c3);
    im = cat(3, c1,c2,c3);
    im = MeanFilter(im, 3);
    % im = DenoiseIsolated(im, "medianfilter");
    im = Denoise(im);
    imshow(im);
    title("denoised");

    
    if(IsLowContrast(im))
        % Enhance low-contrast images.
        [c1,c2,c3] = imsplit(im);
        c1 = adapthisteq(c1);
        c2 = adapthisteq(c2);
        c3 = adapthisteq(c3);
        im = cat(3, c1,c2,c3);
        imshow(im);
        title("contrast enhanced");
    end

    % Threshold the image to get a rough mask with candidate blobs.
    mask = logical(ThresholdRGB(im));
    imshow(mask);
    title("colour thresholded");

    if (IsDark(im))
        disp("DARK IMAGE");
       	mask = ~mask;
    end
%     mask = imfill(mask, 'holes');
%     imshow(mask);
%     title("holes filled");

    % % Morph
    noiseLevel = mean2(GetNoiseLevel(oim))
    if(noiseLevel > 0.50)
        disp("MORPHING NOISY IMAGE");
        se = strel('disk', 2);
        mask = imopen(mask, se);
%         imshow(mask);
        se = strel('line', 4, 0);
        mask = imclose(mask, se);
%         imshow(mask);
        se = strel('diamond', 1);
        mask = imerode(mask, se);
        se = strel('line', 4, 45);
        mask = imclose(mask, se);
%         imshow(mask);
        se = strel('diamond', 1);
        mask = imerode(mask, se);
        se = strel('line', 2, 90);
        mask = imclose(mask, se);
%         imshow(mask);
        se = strel('diamond', 1);
        mask = imerode(mask, se);
        se = strel('line', 4, 135);
        mask = imclose(mask, se);
        imshow(mask);
        se = strel('line', 2, 0);
        mask = imopen(mask, se);
        imshow(mask);
        title("noisy morphs");
    else
        disp("MORPHING OK IMAGE");
        se = strel('line', 2, 0);
        mask = imerode(mask, se);
%         imshow(mask);
        se = strel('line', 4, 0);
        mask = imclose(mask, se);
        imshow(mask);
        title("OK morphs");
    end
    
        if (IsCluttered(oim))
            disp("DILATING CLUTTERED IMAGE");
            se = strel('line', 3, 0);
            mask = imdilate(mask, se);
    %         imshow(mask);
            se = strel('diamond', 1);
            mask = imclose(mask, se);
            se = strel('line', 3, 45);
            mask = imdilate(mask, se);
    %         imshow(mask);
            se = strel('diamond', 1);
            mask = imclose(mask, se);
            se = strel('line', 3, 90);
            mask = imdilate(mask, se);
    %         imshow(mask);
            se = strel('diamond', 1);
            mask = imclose(mask, se);
            se = strel('line', 3, 135);
            mask = imdilate(mask, se);
            imshow(mask);
            title("cluttered morphs");
        end


%     % Remove large blobs (preserve small "noise" in case they are fragments)
%     properties_table = regionprops('table', mask, 'all');
%     areas = properties_table.Area;
% %     minBlobArea = min(areas)
%     maxBlobArea = max(areas)
% %     medianBlobArea = mean2(areas)
%     stdBlobArea = std2(areas)
%     if ((stdBlobArea * 1.5) > maxBlobSize)
%         maxBlobSize = maxBlobArea;
%     end
%     mask = bwareafilt(mask, [0 maxBlobSize]);
%     imshow(mask);
%     title("bwareafilt final");

% Remove noise
%     finalMask = bwareafilt(mask, [minBlobSize maxBlobSize]);
%     imshow(finalMask);
%     title("bwareafilt denoise")
%     % If we removed all items, reduce small threshold until objects found or
%     % max attempts tried.
%     finalMask = mask;
%     [~, nCC] = bwlabel(finalMask);
%     attempts = 0;
%     maxAttempts = 5;
%     while (nCC == 0 && attempts < maxAttempts)
%         attempts = attempts + 1
%         minBlobSize = imArea * (0.0015 * attempts);
%         finalMask = bwareafilt(mask, [minBlobSize maxBlobSize]);
%         imshow(finalMask);
%         title("bwareafilt denoise")
%         [~, nCC] = bwlabel(finalMask);
%     end
    
    finalMask = mask;
    imshow(mask);
    title("finalmask");

%     maskall = MSERIsolateStarfish(finalMask);
    maskall = finalMask;

%     % DRAW FINAL ROIS
%     DrawROIs(oim, maskall);

    [~, n] = bwlabel(maskall);
    finalMask = maskall;
end