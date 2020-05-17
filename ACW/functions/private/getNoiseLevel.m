% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Generate a relative value for level of image noise based on the ...
% ... difference between the original and a filtered version.
function noiseLevel = getNoiseLevel(im)
    dims = ndims(im); % Get n channels.
    
    if (dims == 2)
            noiseLevel = getNoiseLevel2(im);
    elseif (dims == 3)
            [ch1Nl, ch2Nl, ch3Nl] = getNoiseLevel3(im);
            noiseLevel = [ch1Nl, ch2Nl, ch3Nl];
    else
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function noiseLevel = getNoiseLevel2(im)
    grayscaler = 1;
    if (max(im(:)) <= 1)
        grayscaler = 255; 
    end
    
    
    % Create a filtered version of the image.
    filtered = MeanFilter(im, 5);
    
    % Calculate difference between the original and filtered image.
    diffMask = filtered - im;

    % If a pixel diff is > noiseThresh, consider it to be noise.
    NOISE_THRESH = 30 / grayscaler;
    noise = diffMask > NOISE_THRESH;

    % Divide num of white pixels by total number of pixels to get a ...
    % ... relative value for comparing overall image noise.
    MULTIPLIER = 4; % Optional; just scales numbers to more readable ranges.
    noiseLevel = (sum(noise(:)) / numel(im)) * MULTIPLIER; 
end

% For 3D arrays.
function [c1Nl, c2Nl, c3Nl] = getNoiseLevel3(im)
    % Call 2D operation on each of the channels.
    [c1, c2, c3] = imsplit(im);
    c1Nl = getNoiseLevel2(c1);
    c2Nl = getNoiseLevel2(c2);
    c3Nl = getNoiseLevel2(c3);
end