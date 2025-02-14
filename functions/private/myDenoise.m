% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Conditionally/locally filters the image for smoother images without
% ... sacrificing too much detail.
function imP = myDenoise(im)
    % Scale images according to their range e.g. 0-255 or 0-1.     
    grayscaler = 1;
    if (max(im(:)) <= 1)
        grayscaler = 255; 
    end
    oim = im;
    
    % Create an arbritarily denoised version.
    filtered = MedianFilter(oim, 3);

    % Get diff between filtered image and original. Exploratory work also
    % ... looked at using edge detection and convolutions to obtain this
    % ... 'diffmask', with very similar (not quite as good) effects. 
    diffMask = filtered - oim;

    % Threshold pixels that are significantly different and assume them ...
    % ... to be noise. **
    NOISE_THRESH = 30 / grayscaler;
    [n1,n2,n3] = imsplit(diffMask);
    n1 = n1 > NOISE_THRESH;
    n2 = n2 > NOISE_THRESH;
    n3 = n3 > NOISE_THRESH;

    % Replace noisy pixels with filtered pixels. Conditional filtering ...
    % ... imroves detail retention. **
    [f1,f2,f3] = imsplit(filtered);
    [c1,c2,c3] = imsplit(oim);
    c1(n1) = f1(n1);
    c2(n2) = f2(n2);
    c3(n3) = f3(n3);
    denoised = cat(3, c1,c2,c3);

    % Apply mean filter for additional smoothing. Improves segmentation.
    % 3x3 used as 5x5 blurs image too much and later segmentation falters.
    denoised = MeanFilter(denoised, 3);
    
    % Return processed image.
    imP = denoised;
end