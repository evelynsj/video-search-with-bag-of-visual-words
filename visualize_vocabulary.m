% Display example image patches associated with two of the visual words.
% Choose 2 words that are distinct to illustrate what the diff. words are
% capturing. Display enough patch examples so the word content is
% evident (25 patches per word displayed).
% Use 'getPatchFromSIFTParameters.m'

<<<<<<< HEAD
addpath('../PS 3/provided_code/')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);
fprintf('reading %d total files...\n', length(fnames));

% imnames = dir([framesdir '/*.jpeg']);
=======
addpath('./provided_code/');

framesdir = './frames/';
siftdir = './sift/';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftDir '/*.mat']);
fprintf('reading %d total files...\n', length(fnames));

imnames = dir([framesdir '/*.jpeg']);
>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c


allDescriptors = [];
allPositions = [];
allScales = [];
allOrients= [];

imageMat = [];

<<<<<<< HEAD
pathIdx = [];

for i = 1:200 % number of frames
=======
for i = 1:800 % number of frames
>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c

    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
<<<<<<< HEAD
    

    allDescriptors = [allDescriptors; descriptors];
    allPositions = [allPositions; positions];
    allScales = [allScales; scales];
    allOrients = [allOrients; orients];

    % creates matrix of image id's mapped with the number of descriptors
    imageMat = [imageMat, repmat(i, 1, length(descriptors))];
    
    numfeats = size(descriptors,1);
    
    % image paths are mapped with the associated number of features
    pathIdx = [pathIdx; repmat({imname}, numfeats, 1)];
    
=======

    numfeats = size(descriptors,1);

    
    if(numfeats >= 100) % desregards frames with <10 features/descriptors
%         numfeats = 100;
%         descriptorIndex = randperm(numfeats, numDescriptorsToCollect);
        descriptorIndex = randperm(numfeats, 100); 
        allDescriptors = [allDescriptors; descriptors(descriptorIndex,:)];
        allPositions = [allPositions; positions(descriptorIndex,:)];
        allScales = [allScales; scales(descriptorIndex,:)];
        allOrients = [allOrients; orients(descriptorIndex,:)];
        imageMat = [imageMat; imnames(descriptorIndex,:)];
    
        
    end
>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c
    
end
allDescriptors = allDescriptors';

% 	membership	1xn cluster membership vector(index of which word
%       descriptor belongs to)
% 	means		dxk matrix of cluster centroids
k=1500;
[membership,means] = kmeansML(k, allDescriptors);

% create two random sample, pick 2 random words
wordIdx = randperm(k,2);

<<<<<<< HEAD
=======

>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c
for i=1:2
    figure;
    n = wordIdx(i);

<<<<<<< HEAD
    % finds indices of all the features/descriptors associated with that
    % word/membership
    descriptorIdx = find(membership == n);   

    for k=1:25
        featureIdx = descriptorIdx(k);
  
        % gets path of the image with the associated feature index
        path = pathIdx{featureIdx,:};

        grayScale = rgb2gray(imread(path));
        
        patch = getPatchFromSIFTParameters(allPositions(featureIdx,:), allScales(featureIdx), allOrients(featureIdx), grayScale);
=======
    
    % finds indices of all the features/descriptors associated with that
    % word/membership
    descriptorIdx = find(membership == n);

    
    disp(size(descriptorIdx));

    for k=1:25
        featureIdx = descriptorIdx(k);

         % read in the associated image
        imname = [framesdir imageMat(featureIdx).name]; % add the full path
        img = imread(imname);

        grayImg = rgb2gray(img);
        
        patch = getPatchFromSIFTParameters(allPositions(featureIdx,:), allScales(featureIdx), allOrients(featureIdx), grayImg);
>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c

        subplot(5,5,k);
        imshow(patch);

    end

end

<<<<<<< HEAD
save('kMeans.mat');
=======

>>>>>>> 94d86bd3f5c2b70c504aaf399e118c091930b70c
