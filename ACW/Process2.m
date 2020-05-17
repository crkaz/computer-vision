function n = Process1(path)
    oim = imread(path);
    imshow(oim);
    title("Original");
    
    im = oim; % For processing
    
    % Denoise and enhance.
    im = Denoise(im);
    imshow(im);
    title("Denoised");
    
    % Binarize and extract starfish.
%     [~,~,ch] = imsplit(im); % RGB
    [ch,~] = GetOptimalChannel(im, true); % HSV
    imshow(ch);
    title("Optimal channel selection");
    
%     level = graythresh(im); %
%     ch = imbinarize(ch,level);
    ch = ~imbinarize(ch);
    imshow(ch);
    title("Binarize");
    
%     if (IsDark(ch))
%         ch = ~ch;
%         imshow(ch);
%         title("Invert dark image");
%     end
    
    mask = bwareafilt(ch, [500,2000000]);
    maskall = MSERIsolateStarfish(mask);

    % DRAW FINAL ROIS
    DrawROIs(oim, maskall);
    
    [~, n] = bwlabel(maskall);
end