%
% ThresholdRGB dynamically threshols an RGB image based on the ...
% distribution of its colour channels. The skeleton of the function is
% derived from the MATLAB colour thresholding app, but all conditional
% beheaviours (and values) are implemented after analysing the differences
% between the distributions of colour channels in images.
% The values are otherwise random/as determined by trial and error to
% acheive the best segmentations.
% 
function [BW,maskedRGBImage] = ThresholdRGB(RGB)
[r,g,b] = imsplit(RGB);
rMean = mean2(r);
gMean = mean2(g);
gStd = std2(g);
bMean = mean2(b);
bStd = std2(b);
bLogStd = log(bStd);

bVal = 255;
gVal = 255;
bStdMultiplier = round(((bLogStd * 0.1) * (bLogStd * 0.45)),2,'significant');
gStdMultiplier = bStdMultiplier * 0.5;
if (min([rMean, bMean, gMean]) == rMean)
    bStdMultiplier = bStdMultiplier * 2;
end

if ((gMean + 5)< bMean && gMean)
    % Mostly reduce green channel.
    gVal = max(gMean - (gStd * gStdMultiplier), 0);
    if (gVal == 0)
        gVal = gMean + (gStd * gStdMultiplier);
    elseif (gVal < 25)
        gVal = gVal * 10;
    end
    if (bMean >= 195 && bMean <= 235)
        bVal = bMean;
    end
else
    % Mostly reduce blue channel.
    bVal = max(bMean - (bStd * bStdMultiplier), 0);
    if (bVal == 0)
        bVal = gMean + (bStd * gStdMultiplier);
    elseif (bVal < 25)
        bVal = bVal * 10;
    end
    if (gMean >= 195 && gMean <= 235)
        gVal = gMean;
    end
end

rVal = 150;
if (rMean < 200)
    rVal = 0;
%     disp("didn't use red thresh");
end

% Convert RGB image to chosen color space
I = RGB;

% Define thresholds for channel 1 based on histogram settings
channel1Min = rVal;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = gVal;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = bVal;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end