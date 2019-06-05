% Display example image patches associated with two of the visual words.
% Choose 2 words that are distinct to illustrate what the diff. words are
% capturing. Display enough patch examples so the word content is
% evident (25 patches per word displayed).
% Use 'getPatchFromSIFTParameters.m'

addpath('../PS 3/provided_code/')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);
fprintf('reading %d total files...\n', length(fnames));

% imnames = dir([framesdir '/*.jpeg']);


allDescriptors = [];
allPositions = [];
allScales = [];
allOrients= [];

imageMat = [];

pathIdx = [];

for i = 1:200 % number of frames

    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    

    allDescriptors = [allDescriptors; descriptors];
    allPositions = [allPositions; positions];
    allScales = [allScales; scales];
    allOrients = [allOrients; orients];

    % creates matrix of image id's mapped with the number of descriptors
    imageMat = [imageMat, repmat(i, 1, length(descriptors))];
    
    numfeats = size(descriptors,1);
    
    % image paths are mapped with the associated number of features
    pathIdx = [pathIdx; repmat({imname}, numfeats, 1)];
    
    
end
allDescriptors = allDescriptors';

% 	membership	1xn cluster membership vector(index of which word
%       descriptor belongs to)
% 	means		dxk matrix of cluster centroids
k=1500;
[membership,means] = kmeansML(k, allDescriptors);

% create two random sample, pick 2 random words
wordIdx = randperm(k,2);

for i=1:2
    figure;
    n = wordIdx(i);

    % finds indices of all the features/descriptors associated with that
    % word/membership
    descriptorIdx = find(membership == n);   

    for k=1:25
        featureIdx = descriptorIdx(k);
  
        % gets path of the image with the associated feature index
        path = pathIdx{featureIdx,:};

        grayScale = rgb2gray(imread(path));
        
        patch = getPatchFromSIFTParameters(allPositions(featureIdx,:), allScales(featureIdx), allOrients(featureIdx), grayScale);

        subplot(5,5,k);
        imshow(patch);

    end

end

save('kMeans.mat');
