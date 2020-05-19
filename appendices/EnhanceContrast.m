% Checks if the range of the distribution is indicative of low contrast and
% attempts to enhance the image by using Matlab's adaptive (local)
% histogram equalisation function: adapthisteq(im)
% https://uk.mathworks.com/help/images/ref/adapthisteq.html

% imP = processed im
% bool == true if contrast enhanced or false if im is unchanged.
function [imP, bool] = EnhanceContrast(im)

    % Low range or mean is > 200 || < 50 ;
    RANGE = 75;
    LOW = 40;
    HIGH = 215;

    theMin = min(im(:));
    theMax = max(im(:));
    theRange = theMax - theMin;
    theMean = mean(im(:));
    theStd = std2(im(:));
    theMeanPStd = theMean + theStd;
    theMeanMStd = theMean - theStd;
    theRange2 = theMeanPStd - theMeanMStd;

    bool = 0;
    % if ((theRange <= RANGE) || (theMeanMStd > HIGH || theMeanPStd < LOW))
    % if (theRange2 < RANGE && (theMeanMStd > HIGH || theMeanPStd < LOW))
    if (theRange2 < RANGE || (theMeanMStd < LOW|| theMeanPStd > HIGH))
        % if ((theMeanMStd < LOW|| theMeanPStd > HIGH))
        bool = 1;
        disp("LOW CONTRAST");
    end
    %     theRange2
    %     theMeanMStd
%     theMeanPStd
end