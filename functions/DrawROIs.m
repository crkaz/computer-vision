% 
% DrawROIs draws crops an image according to the connected components in
% ... the provided mask and using regionprops() to draw a bounding box. It
% ... returns those bounding boxes for further use and to provide a simple
% ... means of counting the number of detected compnents (i.e. length(bbs)).
% 
function bbs = DrawROIs(mask)
    COLOUR = 'b';
    LINE_THICKNESS = 2;
    CIRCLE = false;
    
    ccs = bwconncomp(mask); % get "connected components" in the binary mask.
    bbs = regionprops(ccs,'Boundingbox'); % Get region info from region properties

    % Draw bounding boxes for each region/connected component detected
    for i = 1:length(bbs)
        bb = bbs(i).BoundingBox; % get bounding box for region 'i'
        if (CIRCLE == false)
            % Draw a rectangular BB with colour c and line thickness t.
            rectangle('Position', [bb(1),bb(2),bb(3),bb(4)],'EdgeColor',COLOUR,'LineWidth',LINE_THICKNESS);
        else
            % Draw a circular BB with colour c and line thickness t.
            rectangle('Position', [bb(1),bb(2),bb(3),bb(4)],'EdgeColor',COLOUR,'LineWidth',LINE_THICKNESS,"Curvature",[1,1]) ;
        end
    end
end