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