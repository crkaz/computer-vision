% 
% The p1 pipeline is focused on detection of isolated starfish like ...
% ... those in the 1st and 2nd tier images. It is a linear pipeline ...
% ... whose goal is to locate all starfish, NOT create perfect masks ...
% ... (hence no morphological ops etc.) - although it does pretty good ...
% ... job anyway until it comes to more complex (cluttered/occluded
% ...images).
%  
function [finalMask, n] = p1(path, outputs)
    oim = imread(path);
    
    % Denoise and enhance.
    denoised = Denoise(oim);
    
    % Get channel most suited for binarising and blob detection (inital mask).
    [ch, chN] = GetOptimalChannel(denoised, false);

	% Binarize to separate foreground and background (remember this...
    ... pipeline targets isolated/noisy objects).
    bw = imbinarize(ch);
    
	% Invert the mask if the image is dark. This corrects the
	... thresholded backround/forground objects to work with the pipeline.
    if (IsDark(ch) && not(IsDark(oim)))
        bw = ~bw;
    end
    
    % Extract starfish blobs using MSER and region props.
    [mserMask, mserRegions] = MSERIsolateStarfish(bw);

    % Output all steps in one figure.
    if (outputs)
        outputP1(2,3, oim, denoised, ch, chN, bw, mserMask, mserRegions);
    end
    
    % Return final mask and starfish count (n).
    [finalMask, n] = bwlabeln(mserMask);
end