% 
% GetFilesInSubDir is a useful tool for traversing the full set of images
% ...in the ./images folder. It was primarily made to broaden and hasten
% ...testing accross the different images to find better generalised
% solutions.
% 
function filepaths = GetFilesInSubDir(subDir)
    files = dir(subDir);
    files = files(~ismember({files.name}, {'.', '..'})); % Remove navigation elements from struct.
    filepaths = subDir + "\" + {files.name};
end