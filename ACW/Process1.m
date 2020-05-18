function [finalMask, n] = Process1(path)
    oim = imread(path);
    
    % Denoise and enhance.
    im = Denoise(oim);
    
    % Get channel most suited for binarising and blob detection (inital mask).
    ch = GetOptimalChannel(im, false);
    
    % Binarize.
    mask = ~imbinarize(ch);
    
    % Extract starfish blobs using MSER and region props.
    maskall = MSERIsolateStarfish(mask);

    % Get starfish count.
    [~, n] = bwlabel(maskall);
    
    finalMask = maskall;
end