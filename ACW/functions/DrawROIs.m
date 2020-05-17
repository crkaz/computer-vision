function DrawROIs(original, mask)
    COLOUR = 'b';
    LINE_THICKNESS = 2;
    CIRCLE = false;
    
    imshow(original);
    bbs = overlayROIs(mask, COLOUR, LINE_THICKNESS, CIRCLE);
    title(length(bbs) + " objects detected");
end

function bbs = overlayROIs(mask, colour, lineThickness, circle)
    CC = bwconncomp(mask); % get "connected components" in the binary mask.

    bbs = regionprops(CC,'Boundingbox'); % Get region info from region properties

    % Draw bounding boxes for each region/connected component detected
    for k = 1 : length(bbs)
        BB = bbs(k).BoundingBox; % get bounding box measures for region 'k'
        if (circle == false)
            % Draw a rectangular BB.
            rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor',colour,'LineWidth',lineThickness); % Draw roi as rectangle with colour c and line thickness t.
        else
            % Draw a circular BB.
            rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor',colour,'LineWidth',lineThickness,"Curvature",[1,1]) ;
        end
    end
end