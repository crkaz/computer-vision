function outputP1(r,c,oim, denoised, ch, chN, bw, mserMask, mserRegions)
    R = r;
    C = c;
    n = 1;
    i = 1;
    
    figure
    disp("PIPELINE 1 (P1) STEPS");
    subplot(R,C,n);
    imshow(oim);
    title("Original");
    n = n + 1;
    
    subplot(R,C,n);
    imshow(denoised);
    title("[P1."+ i +"] Denoised");
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    imshow(ch);
    title("[P1."+ i +"] Selected Channel #" + chN);
    n = n + 1;
    i = i + 1;

    subplot(R,C,n);
    imshow(bw);
    title("[P1."+ i +"] Binarized Sel. Ch.");
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    hold on;
    imshow(mserMask);
    title("[P1."+ i +"] MSER Regions");
    plot(mserRegions,'showPixelList',true,'showEllipses',false);
    hold off;
    n = n + 1;
    i = i + 1;
    
    subplot(R,C,n);
    hold on;
    imshow(oim);
    count = DrawROIs(mserMask);
    title("COUNT = " + length(count));
    hold off;
    n = n + 1;
    i = i + 1;
end