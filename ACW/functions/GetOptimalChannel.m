% 
% Gets the HSV image channel which best isolates objects in the image,...
% ... determined by selecting the channel with the lowest value of ...
% ... 'noise level' - variance.
%
% RETURNS: selected image channel, channel number
function [chArr, chNum] = GetOptimalChannel(im, hsv)
    % Validate args: must be 3D array.
    dims = ndims(im);
    if (dims < 3 || dims > 4)
        error("Unsupported number of dimensions. Expected a 2D or 3D array.");
    end
    
    %
    % [Experimental work in SelectOptimalChannel.mlx and AllChHists.mlx in ...
    % ... /appendices) found 1/3 of HSV channels tend to isolate objects ...
    % ... quite well (first pass) and my 'noise value' - variance ...
    % ... successfully selected the 'best' channel in all given test images.]
    % A similar effect was observed with the RGB colour model, taking ...
    % ... but by taking the channel with the highest variance.
    %
    if (hsv)
        im = rgb2hsv(im);
    else % RGB.
        im = im2double(im);
    end
    
    % Get individual 'noise level' and variance for each channel.
    [c1, c2, c3] = imsplit(im);
    c1v = var(c1(:));
    c1n = GetNoiseLevel(c1);
    c2v = var(c2(:));
    c2n = GetNoiseLevel(c2);
    c3v = var(c3(:));
    c3n = GetNoiseLevel(c3);
    
    % Calculate difference between noise level and variance for each.
    if(hsv)
        c1x = roundn(c1n - c1v, -3);
        c2x = roundn(c2n - c2v, -3);
        c3x = roundn(c3n - c3v, -3);
    else % RGB.
        c1x = roundn(c1v, -3);
        c2x = roundn(c2v, -3);
        c3x = roundn(c3v, -3);
    end
    
    % Select the channel with the lowest (HSV) or highest (RGB) value.
    if (hsv)
        X = min([c1x,c2x,c3x]);
    else % RGB
        X = max([c1x,c2x,c3x]);
    end
    
    % Select/return appropriate channel (where there are duplicate values ...
    % ... the higher channel is preferred based off of experimantal findings.
    if (X == c3x)
        chArr = c3;
        chNum = 3;
    elseif (X == c2x)
        chArr = c2;
        chNum = 2;
    elseif (X == c1x)
        chArr = c1;
        chNum = 1;
    end
end

