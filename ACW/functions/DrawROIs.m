function DrawROIs(original, mask)
    COLOUR = 'b';
    LINE_THICKNESS = 2;
    CIRCLE = false;
    
    imshow(original);
    overlayROIs(mask, COLOUR, LINE_THICKNESS, CIRCLE);
end

function overlayROIs(mask, colour, lineThickness, circle)
    CC = bwconncomp(mask); % get "connected components" in the binary mask.

    info = regionprops(CC,'Boundingbox'); % Get region info from region properties

    % Draw bounding boxes for each region/connected component detected
    for k = 1 : length(info)
        BB = info(k).BoundingBox; % get bounding box measures for region 'k'
        if (circle == false)
            % Draw a rectangular BB.
            rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor',colour,'LineWidth',lineThickness); % Draw roi as rectangle with colour c and line thickness t.
        else
            % Draw a circular BB.
            rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor',colour,'LineWidth',lineThickness,"Curvature",[1,1]) ;
        end
    end
end