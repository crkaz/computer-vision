function imP = Denoise(im)
    % Apply median filter; this is a generally good filter for many images.     
    % (applying to each channel preserves the original colour).     
    [c1,c2,c3] = imsplit(im);
    c1 = medfilt2(c1);
    c2 = medfilt2(c2);
    c3 = medfilt2(c3);
    im = cat(3, c1,c2,c3);
    
    % Apply a mean filter; this improves images with gaussian and speckle
    % noise. Whilst some detail is lost, segmentation improves as a result.
    im = MeanFilter(im, 3);
    
    % See MyDenoise function.
    im = MyDenoise(im);
    
    imP = im;
end

function imP = MyDenoise(im)
    oim = im;
    
    filtered = oim;
    [f1,f2,f3] = imsplit(filtered);
    f1 = medfilt2(f1);
    f2 = medfilt2(f2);
    f3 = medfilt2(f3);
    filtered = cat(3, f1, f2, f3);

    noise = filtered - oim;

    % Split noise channels
    noiseThresh = 30;
    [c1,c2,c3] = imsplit(oim);
    [n1,n2,n3] = imsplit(noise);
    n1 = n1 > noiseThresh;
    n2 = n2 > noiseThresh;
    n3 = n3 > noiseThresh;

    % % Denoise channels
    [c1,c2,c3] = imsplit(oim);
    c1(n1) = f1(n1);
    c2(n2) = f2(n2);
    c3(n3) = f3(n3);
    denoised = cat(3, c1,c2,c3);
%     imshow(denoised);
%     title("denoised");

    [c1,c2,c3] = imsplit(denoised);
    c1 = MeanFilter(c1, 3);
    c2 = MeanFilter(c2, 3);
    c3 = MeanFilter(c3, 3);
    denoised = cat(3, c1,c2,c3);
%     imshow(denoised);
%     title("denoised");

    denoised = imsharpen(denoised);
    
    imP = denoised;
end