% 
% Denoise() applies the same denoising technique to every image, with
% ... a median filter followed by a mean filter being effective in all
% ... cases for the purposes of segmentation masks. However, the final
% ... denoising step conditionally/locally filteres the image for a slight
% ... improvement in some cases (resulting in better defined masks).
% 
function imP = Denoise(im)
    % Apply median filter; this is a generally good filter for many images.
    % (applying to each channel preserves the original colour).
    % 3x3 used as to not remove too much info.
    im = MedianFilter(im, 3);
    
    % Apply a mean filter; this particularly improves images with gaussian
    % ... and speckle noise. GetNoiseLevel() WAS exeperimentally used to 
    % ... perform this conditionally, but whilst some detail is lost, 
    % ... segmentation almost always improves as a result
    im = MeanFilter(im, 3); % 3x3 used as to not remove too much info.
    
    % Conditional denoising (see private myDenoise function).
    im = myDenoise(im);
    
    % Return processed image.
    imP = im;
end