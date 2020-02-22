% % matlab -nosplash -nodesktop -sd d:\repos\Computer Vision\Lab 3 -r "run('.\Lab3.m');"

% %% EXERCISE 2
% cece = imread("Celica.jpg");
% % saltycece = imread("Celica.jpg");
% % figure

% % subplot(1,2,1);
% % imshow(cece);
% % title("Normal");

% % % https://www.mathworks.com/help/images/ref/imnoise.html
% % subplot(1,2,2);
% % % saltycece = imnoise(saltycece, "poisson");
% % % saltycece = imnoise(saltycece, "gaussian");
% % saltycece = imnoise(saltycece, "speckle");
% % saltycece = imnoise(saltycece, "salt & pepper", 0.02);
% % imshow(saltycece)
% % title("Noisy");


% % Exercise 5: Using built-in MATLAB functions, apply both a mean filter, and a median filter to
% % the chosen noisy images. For this exercise you may utilise built-in functions, or methods of
% % your choosing.


% % MEDIAN FILTER
% % For all channels (if 3 channels)..
% % retroCece = medfilt3(cece);
% % imshow(retroCece)

% % For individual channels:
% % r = cece(:,:,1);
% % g = cece(:,:,2);
% % b = cece(:,:,3);
% % medFiltCece = medfilt3(cece);
% % medFiltR = medfilt2(r);

% % someFiltR = conv2(r, ones(3)/100, 'same');
% % someFiltG = conv2(g, ones(3)/100, 'same');
% % someFiltB = conv2(b, ones(3)/100, 'same');

% % figure
% % subplot(3,3,1);
% % imshow(r)
% % title("Red Channel")
% % subplot(3,3,2);
% % imshow(g)
% % title("Green Channel")
% % subplot(3,3,3);
% % imshow(b)
% % title("Blue Channel")
% % subplot(3,3,4);
% % imshow(cece)
% % title("Original")
% % subplot(3,3,5);
% % imshow(medFiltCece)
% % title("Median Filter All Channels")
% % subplot(3,3,6);
% % imshow(medFiltR)
% % title("Median Filter Red Channel")
% % subplot(3,3,7);
% % imshow(someFiltR)
% % title("? Filter Red Channel")
% % subplot(3,3,8);
% % imshow(someFiltG)
% % title("? Filter Green Channel")
% % subplot(3,3,9);
% % imshow(someFiltB)
% % title("? Filter Blue Channel")


% % meanFiltR = ones(5,5)/25, 'same';
% % meanFiltG = ones(5,5)/25, 'same';
% % meanFiltB = ones(5,5)/25, 'same';
% % meanFiltCece = ones(3,3)/9, 'same';
% meanFiltCece = ones(9,9)/81, 'same';

% % im1 = imfilter(cece,meanFiltR);
% % im2 = imfilter(cece,meanFiltG);
% % im3 = imfilter(cece,meanFiltB);
% im4 = imfilter(cece,meanFiltCece);

% figure
% subplot(1,2,1);
% imshow(cece)
% subplot(1,2,2);
% imshow(im4)
% % subplot(2,2,1);
% % imshow(im1)
% % title("Mean Filter R")
% % subplot(2,2,2);
% % imshow(im2)
% % title("Mean Filter G")
% % subplot(2,2,3);
% % imshow(im3)
% % title("Mean Filter B")
% % subplot(2,2,4);
% % imshow(im4)
% % title("Mean Filter Original")

% EXTENDED EXERCISE 1

% function [returnsa, returnsb] = functName(param)
%     returnsa = sum(param(:))/numel(param); 
%     returnsb = sum(param(:))/numel(param); 
% end

% function returns = functName(param)
%     returns = sum(param(:))/numel(param); 
% end

% m = [1 2 3; 4 5 6; 7 8 9];
% % disp(m)
% m = m'; % transpose with apostrophe
% for n = m
%     disp(n)
% end


cece = imread("Celica.jpg");
% cece = imresize(cece, 0.5);
% myFilter = [0 1 0; 1 -4 -1; 0 -1 0];
% myFilter = [0 1 0; 0 -2 0; 0 -1 0];
myFilter1 = [0 0 0; 0 -1 0; 0 1 0];
myFilter2 = [0 0 0; 0 -1 1; 0 0 0];
% myFilter = myFilter'; % transpose

convImg1 = MyConv(cece,myFilter1, 0);
convImg2 = MyConv(cece,myFilter2, 0);

figure
subplot(1,2,1);
imshow(convImg1)
subplot(1,2,2);
imshow(convImg2)
% 
% 
% 
% @TODO: PADDING IS REDUNDANT WITH THIS IMPLEMENTATION 
% 
%  FACADE
function convImg = MyConv(img, myFilt, padding)
    convImg = img; % Make a copy.
    [x,y,z] = size(img);
    for ch = 1:z
        for col = 1:y
            for row = 1:x
                neighbours = GetNeighbours(img, row, col, ch, padding);
                newPixel = Filt(neighbours, myFilt);
                convImg(row,col,ch) = newPixel;
            end
        end
    end
end

% IMPLEMENTATION
function neighbours = GetNeighbours(img, row, col, ch, padding)
    nArray = [-1 0 1];
    neighbours = zeros(3,3);

    for ny = [1 2 3]
        for nx = [1 2 3]
            y = row + nArray(ny);
            x = col + nArray(nx); 
            try
                pixel = img(y,x,ch);
            catch
                pixel = padding; 
            end
            
            neighbours(ny, nx) = pixel;
        end
    end
end

% IMPLEMENTATION
function scalar = Filt(neighbours, myFilt)
    % Get each pixel value left-right, top-down - of the window/neighbours.
    scalar = 0;
    for y = [1 2 3]
        for x = [1 2 3]
            scalar = scalar + (neighbours(y,x) * myFilt(y,x));
        end
    end
end
