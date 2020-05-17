% ------------------------------------------------------
% PRIVATE METHODS CALLED FROM FUNCTIONS IN PARENT FOLDER
% ------------------------------------------------------

% Estimate the noise-type/s present in the image based on the histogram of
% the difference between the original iamge and a filtered version.
function noiseType = classifyNoise(im)
    dims = ndims(im); % Get n channels.
    
    if (dims == 2)
            noiseType = classifyNoise2(im);
    elseif (dims == 3)
            [c1Nt, c2Nt, c3Nt] = classifyNoise3(im);
            noiseType = [c1Nt, c2Nt, c3Nt];
    else
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
end

% For 2D arrays.
function noiseType = classifyNoise2(im)
    % Create a filtered version of the image.
    filtered = MeanFilter(im, 5);
    
    % Calculate difference between the original and filtered image.
    diffMask = filtered - im;

    % Get avg gradient of diffMask hist (100 bins) to estimate noise type.     
    myhist = imhist(diffMask,100);
    histAvgGradient = median(myhist);
    if (histAvgGradient < 5)
        noiseType = "Gaussian/No Noise";
    elseif (histAvgGradient  < 150)
        noiseType = "Impulse/Isolated";
    else
        noiseType = "Speckle/Mixed";
    end
end

% For 3D arrays.
function [c1Nt, c2Nt, c3Nt] = classifyNoise3(im)
    % Call 2D operation on each of the channels.
    [c1, c2, c3] = imsplit(im);
    c1Nt = classifyNoise2(c1);
    c2Nt = classifyNoise2(c2);
    c3Nt = classifyNoise2(c3);
end
