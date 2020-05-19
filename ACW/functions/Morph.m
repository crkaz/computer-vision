%
% Conditionally morphs a mask based on the properties of the original ...
% image, using MATLABs morpholoigical operators.
% 
function imP = Morph(mask, oim) 
noiseLevel = mean2(GetNoiseLevel(oim));
    
    % Morphing noisy image.
    if(noiseLevel > 0.50)
        % Get rid of small noise components and separate blobs.         
        se = strel('disk', 2);
        mask = imopen(mask, se);
        
        % Now there is less noise, remaining components may be fragments of
        % actual objects: line;4;0 helps reconnect horizontal starfish
        % extremities present in the given data.
        se = strel('line', 4, 0);
        mask = imclose(mask, se);
       
        % Previous morph leaves shape connected but a little unatural, so
        % erode it. Also helps disconnect objects/blobs.
        se = strel('line', 2, 45);
        mask = imerode(mask, se);
         
        % Noisy images more likely to have conjoined blobs, so thin it out.
        se = strel('diamond', 1);
        mask = imerode(mask, se);
        
        % Diamond in prev morph can leave shapes quite angular, which this
        % helps with in the given data.
        se = strel('line', 2, 45);
        mask = imdilate(mask, se);
        
        % As above, plus increases masks coverage (which is usually 
        % reduced since this is a noisy image).         
        se = strel('disk', 1);
        mask = imdilate(mask, se);
    end
    
    % Morphing low-noise image to imrpove mask.
    if(noiseLevel > 0.50)
        % Helps to separate some blobs without removing fragments completely.         
        se = strel('line', 2, 0);
        mask = imerode(mask, se);
        
        % Try to reconnect horizontal fragments (e.g. starfish legs).    
        se = strel('line', 4, 0);
        mask = imclose(mask, se);
        
        % Separate the blobs. Value of one as to not undo the previous step.         
        se = strel('diamond', 1);
        mask = imopen(mask, se);
        
        % Smooth and increase the overall coverage of the mask (without reconnection).
        se = strel('disk', 1);
        mask = imdilate(mask, se);
    end

           
    % More aggressive morphing for cluttered/occluded images.
    if (IsCluttered(oim))
        % Start by trying to separate slightly connected blobs.
        se = strel('disk', 1);
        mask = imerode(mask, se);

        % Without changing the shape as much as prev step, try to further
        % separate blobs.
        se = strel('diamond', 1);
        mask = imopen(mask, se);

        % Diamond shape is more agressive than disk, so a high value can be
        % used here to firther sepearate clutter.
        se = strel('disk', 4);
        mask = imopen(mask, se);
        
        % Fragments likeley to have formed with all the separation, so do a
        % little all-over dilation to keep actual objects intact.
        se = strel('disk',1);
        mask = imdilate(mask, se);

        % As above, but  not all-over. -20deg helps in given dataset.
        se = strel('line',4, -20);
        mask = imdilate(mask, se);
         
        % Imopen isn't has harsh as erode, so less chance of undoing all the
        % previous steps dilation.
        se = strel('disk', 4);
        mask = imopen(mask, se);
        
        % Final tweaks which aim to make the best of a bad job in the
        % advanced images.
        se = strel('line',1, 45);
        mask = imerode(mask, se);
        se = strel('line',1, -90);
        mask = imdilate(mask, se);
        se = strel('disk',1);
        mask = imclose(mask, se);
        se = strel('line',4, 0);
        mask = imopen(mask, se);
        se = strel('disk',2);
        mask = imerode(mask, se);
        se = strel('disk',2);
        mask = imclose(mask, se);
        
        % Lots of textures in these images, which often translates to ...
        ... holey masks, which this helps with.
        mask = imfill(mask, 'holes');
    end
    
    % This value ensures smaller discernable starfish in given data...
    ... kept, whilst removing a substantial amount of noisy blobs.
    ... We do this at this step as to not remove fragments that might be
    ... reconnected too early.
    mask = bwareaopen(mask, 450);

    % Remove any erroneous detections caused by filter borders that ...
    ... cover (or nearly cover) the full width or hight of the image.
    [h,w,~] = size(oim); % Get height of image.
    [ccs, ~] = bwlabeln(mask);
    bbs = regionprops(ccs,'Boundingbox');
    for i = 1:length(bbs)
        bb = bbs(i).BoundingBox; % get bounding box measures
        bbh = bb(3); % height of bb
        bbw = bb(4); % width of bb
        if (bbh > h * 0.7 || bbw > w * 0.85)
            removalMask = ccs == i; % i represents blob id from bwlabeln(..).
            mask(removalMask) = 0; % Remove erroneous blob.
        end
    end

    imP = mask;
end