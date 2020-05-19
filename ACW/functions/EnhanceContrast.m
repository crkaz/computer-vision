% 
% Uses MATLAB's adapthisteq() to locally adjust the contrast of the input
% image. This was discovered as the best option (from imadjust, histeq) in
% most cases, although imadjust performs nearly as well.
% 
function imP = EnhanceContrast(im)
    imP = enhanceContrast(im); % Call private function.
end

% -----------------------------------------
% % PRIVATE METHODS in ./functions/private
% -----------------------------------------
