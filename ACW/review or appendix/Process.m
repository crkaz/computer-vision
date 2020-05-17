function n = Process(imPath)
    % Load. 
    imO = imread(imPath);
    
    % Denoise.     
    imD = Denoise(imO);
    
    % Detect and enhance low contrast.
    contrastEnhanced = false;
    if (IsLowContrast(imD))
        [imCE, contrastEnhanced] = EnhanceContrast(imD);
        contrastEnhanced = true;
    end
    
    % Colour threshold for intial mask.
    mask = RGBThresh(imCE);

    % Detect possible clutter/occlusion.
    if (IsCluttered(mask))
        % Regenerate mask with/without contrast enhancement. 
        if (contrastEnhanced)
            % WITHOUT
            mask = RGBThresh(imD);
        else
            % WITH
            [imCE, contrastEnhanced] = EnhanceContrast(imD);
            mask = RGBThresh(imD);
        end
    end
    
    % Detect possibly darker images and invert their masks to make
    % foreground objects positive.
    if (IsDark(imD))      
        mask = ~im;
    end

    % Morphologically enhance the mask to denoise and improve coverage.
    mask = Morph(mask);
end