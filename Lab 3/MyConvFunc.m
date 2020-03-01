% @TODO: Padding param is currently redundant because new img array is prepopulated with 0s.
% @TODO: Window and filter kernels are currently hard coded to be 3x3.
% @TODO: Stride is hard coded.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% PROGRAM CODE %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Load image; resize for quicker testing.
cece = imread("Celica.jpg");
% cece = imresize(cece, 0.5);


%  Generate filter/s.
myFilter = [0 0 0; 0 -1 1; 0 0 0];
% myFilter = [0 1 0; 1 -4 -1; 0 -1 0];
% myFilter = [0 1 0; 0 -2 0; 0 -1 0];
% myFilter1 = [0 0 0; 0 -1 0; 0 1 0];


% Manipulate image/s.
% convImg1 = convn(cece,myFilter, 'same');
% convImg2 = MyConv(cece,myFilter, 255);

% With different colour models...
% ceceHSV = rgb2hsv(cece);
% ceceHSV = MyConv(ceceHSV,myFilter, 255);
% ceceLAB = rgb2lab(cece);
% ceceLAB = MyConv(ceceLAB,myFilter, 255);
% ceceYCBCR = rgb2ycbcr(cece);
% ceceYCBCR = MyConv(ceceYCBCR,myFilter, 255);
ceceHSV = conv2;
ceceHSV = MyConv(ceceHSV,myFilter, 255);

% Plot image/s.
imshow(ceceGrey)
% figure
% subplot(2,3,1);
% imshow(cece)
% title("Cece <3");
% subplot(2,3,2);
% imshow(convImg1)
% title("MatLab convn()");
% subplot(2,3,3);
% imshow(convImg2)
% title("MyConv()");
% subplot(2,3,4);
% imshow(ceceHSV)
% title("MyConv() HSV");
% subplot(2,3,5);
% imshow(ceceLAB)
% title("MyConv() L*A*B");
% subplot(2,3,6);
% imshow(ceceYCBCR)
% title("MyConv() YcBcR");

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% METHODS %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%  FACADE METHOD
% Traverse the image with a "sliding window" and convolve the image.
function convImg = MyConv(img, myFilt, padding)
    % @TODO: ASK ASHLEY WHY NEXT LINE DOES SOME NIIICE EDGE DETECTION.
    % convImg = img; % Make a copy to modify and return.

    [x,y,z] = size(img); % Get iterators as img dimensions.
    convImg = zeros(y,x,z); % Initialise empty output for speed.

    % @TODO: order of dimensions doesn't SEEM to have any effect.
    for ch = 1:z % Step through channels.
        for col = 1:y % Step through rows.
            for row = 1:x % Step through columns.
                % Get "window".
                neighbours = GetNeighbours(img, row, col, ch, padding);

                % Convolve the "window" with the filter.
                newPixel = Filt(neighbours, myFilt);

                % Set the value in the output/return img.
                convImg(row,col,ch) = newPixel;
            end
        end
    end
end
 

% IMPLEMENTATION METHOD
% Returns the "window" of neighbours.
function neighbours = GetNeighbours(img, row, col, ch, padding)
    nArray = [-1 0 1]; % Neighbour positions i.e. left/up, current x/y, right/down.
    neighbours = zeros(3,3); % 3x3 kernel.

    for ny = [1 2 3] % To step through nArray.
        for nx = [1 2 3]  % To step through nArray.
            y = row + nArray(ny); % Get y val for this neighbour.
            x = col + nArray(nx); % Get x val for this neighbour.
            try
                % Get the value of the neighbour pixel from the actual image.
                pixel = img(y,x,ch);
            catch
                % If neighbour doesn't exist, use the padding value.
                pixel = padding; 
            end
            
            % Return the populated window.
            neighbours(ny, nx) = pixel;
        end
    end
end


% IMPLEMENTATION METHOD
% Convolve a window of the image with a filter.
function scalar = Filt(neighbours, myFilt)
    % Get each pixel value left-right, top-down - of the window/neighbours.
    scalar = 0;
    for y = [1 2 3] % Step through rows of neighbours and filter.
        for x = [1 2 3] % Step through cols of neighbours and filter.
            % Calculate runnning total (double sum).
            scalar = scalar + (neighbours(y,x) * myFilt(y,x));
        end
    end
end
