function n = Process1(path)
    original = imread(path);
    oim = original; % For processing
    
    % % Denoise and enhance.
    im = Denoise(oim);
    
    % Binarize and extract starfish.
    [~,~,ch3] = imsplit(im);
    ch3 = ~imbinarize(ch3);
    mask = bwareafilt(ch3, [500,2000000]);
    maskall = MSERIsolateStarfish(mask);

    % DRAW FINAL ROIS
    DrawROIs(original, maskall);
    
    [~, n] = bwlabel(maskall);
end