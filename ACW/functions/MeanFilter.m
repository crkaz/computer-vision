% 
% Mean Filter implementation. Could add padding parameter but no need for
% anything other than same right now, and no default params make it
% tedious.
% 
function filtered = MeanFilter(im, nhood)
    filtered = meanFilter(im, nhood); % Call private function.
end

% ----------------------------------------
% % PRIVATE METHODS in ./functions/private
% ----------------------------------------
