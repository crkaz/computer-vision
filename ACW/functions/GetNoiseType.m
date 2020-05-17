% 
% Estimate the noise-type/s present in the image based on the histogram of
% the difference between the original iamge and a filtered version.
% 
function noiseType = GetNoiseType(im)
    noiseType = getNoiseType(im); % Call private function.
    % 0 = "Impulse/Isolated"
    % 1 = "Gaussian/No Noise"
    % 2 = "Speckle/Mixed"     
end

% --------------------------------------
% PRIVATE METHODS in ./functions/private
% --------------------------------------