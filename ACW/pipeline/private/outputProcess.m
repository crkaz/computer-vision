% Format and display stepwise output for pipeline 
function outputProcess(r,c, oim, p1Mask, p2Mask, finalMask)
    R = r;
    C = c;
    n = 1;
    
    figure
    disp("OVERALL PIPELINE (P1&P2 COMPOSITE) STEPS");
    subplot(R,C,n);
    imshow(oim);
    title("Original");
    n = n + 1;
    
    subplot(R,C,n);
    try
        if (p1Mask == "null")
            title("P1 DIDN'T RUN");
        end
    catch
        imshow(p1Mask);
        title("P1 Output");
    end
    n = n + 1;
    
    subplot(R,C,n);
    imshow(p2Mask);
    title("P2 Output");
    n = n + 1;

    subplot(R,C,n);
    imshow(finalMask);
    title("P1&P2 Composite");
    n = n + 1;
    
    subplot(R,C,n);
    hold on;
    imshow(oim);
    count = DrawROIs(finalMask);
    title("COUNT = " + length(count));
    hold off;
    n = n + 1;
end