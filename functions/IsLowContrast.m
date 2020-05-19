% 
% Estimate whether an image is low contrast by checking the range of ...
% ... n% of the distribution, centred around the mean.
% 
function bool = IsLowContrast(im)
    bool = isLowContrast(im); % Call private function.
end

% ----------------------------------------
% % PRIVATE METHODS in ./functions/private
% ----------------------------------------