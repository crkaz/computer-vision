% 
% Estimate whether an image appears dark or not, by counting the number ...
% ... of pixels above and below a the threshold.
% 
function bool = IsDark(im)
    THRESHOLD = 165;

    bool = false;
    
    % Count the number of pixels with intensities above/below threshold.
    darkPixels = im(:) < THRESHOLD;
    nDarkPixels = sum(darkPixels(:));
    lightPixels = im(:) >= THRESHOLD;
    nLightPixels = sum(lightPixels(:));
    
    % Consider image to be 'dark' if there are more dark pixels than light.
    if (nDarkPixels > nLightPixels)
        bool = true;
    end
end