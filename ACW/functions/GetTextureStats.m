% 
% Return a table of texture statistics detailing regions in a given mask.
% 
function stats = GetTextureStats(im, mask)
    stats = getTextureStats(im, mask); % Call private function.
end

% ----------------------------------------
% % PRIVATE METHODS in ./functions/private
% ----------------------------------------
