% Format and display stepwise output for pipeline 
function outputP2(r,c, oim, denoised, enhanced, bw, morphed)
    R = r;
    C = c;
    n = 1;
    i = 1;
    
    figure
    disp("STEP #1 : PIPELINE 2 (P2)");
    subplot(R,C,n);
    imshow(oim);
    title("Original");
    n = n + 1;
    
    subplot(R,C,n);
    imshow(denoised);
    title("[P2."+ i +"] Denoised");
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    imshow(enhanced);
    title("[P2."+ i +"] Contrast Enh. (or not)");
    n = n + 1;
    i = i + 1;

    subplot(R,C,n);
    imshow(bw);
    title("[P2."+ i +"] Thresholded");
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    imshow(morphed);
    title("[P2."+ i +"] Morphed");
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    hold on;
    imshow(oim);
    count = DrawROIs(morphed);
    title("COUNT = " + length(count));
    hold off;
    n = n + 1;
    i = i + 1;
end