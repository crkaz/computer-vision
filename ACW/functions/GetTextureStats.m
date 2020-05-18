% 
% Return a table of texture statistics detailing regions in a given mask.
% 
function statsTable = GetTextureStats(im, mask)
    statsTable = getTextureStats(im, mask); % Call private function.
end

% ----------------------------------------
% % PRIVATE METHODS in ./functions/private
% ----------------------------------------
