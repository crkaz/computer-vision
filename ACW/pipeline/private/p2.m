% 
% The p2 pipeline is more complex than p1 and generalises slightly better.
% Unlike p1, p2 focuses on detecting all starfish with better covering
% masks, even if that means including a lot of noise.
% 
function [finalMask, n] = p2(path, outputs)
    oim = imread(path);

    % Denoise.
    denoised = Denoise(oim);
    
    % Conditionally enhance contrast.
    enhanced = denoised; % Just for displaying CE stage.
    if(mode(IsLowContrast(denoised)) || IsDark(oim))
        enhanced = EnhanceContrast(denoised);
    end

    % Threshold the image to get a rough mask with candidate blobs.
    bw = logical(ThresholdRGB(enhanced));

	% Invert the mask if the image is dark. This corrects the ...
    ... thresholded backround/forground objects to work with the pipeline.
    if (IsDark(oim))
       	bw = ~bw;
    end

    % Conditionally apply morphological ops to the mask.
    morphed = Morph(bw, oim);
        
    % Output all steps in one figure.
    if (outputs)
        outputP2(2,3,oim, denoised, enhanced, bw, morphed);
    end
    
    % Return final mask and starfish count (n).
    [finalMask, n] = bwlabeln(morphed);
end