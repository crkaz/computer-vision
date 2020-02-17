% %  EXERCISE 1 & 2
%circles = imread('circles.png');
coins = imread('coins.png');
%cameraman = imread('cameraman.tif');
lighthouse = imread('lighthouse.png');


% %  EXERCISE 3
[h, w] = size(circles)


% %  EXERCISE 4
% figure
% subplot(2,2,1);
% imshow(circles);
% subplot(2,2,2);
% imshow(coins);
% subplot(2,2,3);
% imshow(cameraman);
% subplot(2,2,4);
% imshow(lighthouse);


% %  EXERCISE 5
% [count, locs] = imhist(coins); % returns count of each bin

% % n bins can be defined
% [count, locs] = imhist(coins, 128); % returns count of each bin


% %  EXERCISE 6
% % If we just call imhist, without assigning it to our variables, it will display our
% % histogram for us. We can combine this with figure, and hold on/off to display our histogram,
% % and overlay another on-top.
% figure;
% hold on;
% imhist(coins); % Display histogram of your coins image.
% imhist(coins, 128); % Display histogram with 128 bins.
% hold off;


% %  EXERCISE 7
% rsCoins = imresize(coins ,0.25);
% figure
% subplot(1,2,1);
% imshow(coins);
% subplot(1,2,2);
% imshow(rsCoins);


% %  EXERCISE 8
% rsCoins = imresize(coins ,0.25);
% [h, w] = size(rsCoins)
% rsCoins = imresize(rsCoins ,5.0);
% [h, w] = size(rsCoins) % same size as original now but lost detail.
% figure
% subplot(1,2,1);
% imshow(coins);
% subplot(1,2,2);
% imshow(rsCoins);
% [h, w] = size(rsCoins)


% %  EXERCISE 9
% biCoins = imresize(coins, 3.0, "bilinear"); % Smoother
% neCoins = imresize(coins, 3.0, "nearest");
% figure
% subplot(1,2,1);
% imshow(biCoins);
% subplot(1,2,2);
% imshow(neCoins);


% %  EXERCISE 10
% equalised = histeq(coins); % Equalising enhances detail by essentuating dark and light ??
% figure
% subplot(1,2,1);
% imshow(coins);
% subplot(1,2,2);
% imshow(equalised);


% % EXERCISE 11
% % Using our colour image we previously loaded in (lighthouse), we can extract the
% % red channel, blue channel, and green channel using slice notation.
% % Colon ( : ) simply says to take ALL the values from lowest-highest in that dimension. As we
% % know in our colour model, that the first two dimensions are spatial (X direction, Y direction),
% % we want ALL our pixels, but taking only their 1st component, the red channel. Remember:
% % RGB.
% r = lighthouse(:, :, 1);
% g = lighthouse(:, :, 2);
% b = lighthouse(:, :, 3);
% figure
% subplot(1,3,1);
% imshow(r);
% subplot(1,3,2);
% imshow(g);
% subplot(1,3,3);
% imshow(b);


% % EXERCISE 12
% hsvLighthouse = rgb2hsv(lighthouse);
% figure
% subplot(1,2,1);
% imshow(lighthouse);
% subplot(1,2,2);
% imshow(hsvLighthouse);
% 
% h = hsvLighthouse(:, :, 1);
% s = hsvLighthouse(:, :, 2);
% v = hsvLighthouse(:, :, 3);
% figure
% subplot(1,3,1);
% imshow(h);
% subplot(1,3,2);
% imshow(s);
% subplot(1,3,3);
% imshow(v);


% % EXERCISE 12
% ycbcrLighthouse = rgb2ycbcr(lighthouse);
% figure
% subplot(1,2,1);
% imshow(lighthouse);
% subplot(1,2,2);
% imshow(ycbcrLighthouse);
% 
% h = ycbcrLighthouse(:, :, 1);
% s = ycbcrLighthouse(:, :, 2);
% v = ycbcrLighthouse(:, :, 3);
% figure
% subplot(1,3,1);
% imshow(h);
% subplot(1,3,2);
% imshow(s);
% subplot(1,3,3);
% imshow(v);


% % EXERCISE 13
labLighthouse = rgb2lab(lighthouse);
figure
subplot(1,2,1);
imshow(lighthouse);
subplot(1,2,2);
imshow(labLighthouse);

h = labLighthouse(:, :, 1);
s = labLighthouse(:, :, 2);
v = labLighthouse(:, :, 3);
figure
subplot(1,3,1);
imshow(h);
subplot(1,3,2);
imshow(s);
subplot(1,3,3);
imshow(v);

% https://stackoverflow.com/questions/34913005/color-space-mapping-ycbcr-to-rgb