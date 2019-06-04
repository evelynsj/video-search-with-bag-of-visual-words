% Display example image patches associated with two of the visual words.
% Choose 2 words that are distinct to illustrate what the diff. words are
% capturing. Display enough patch examples so the word content is
% evident (25 patches per word displayed).
% Use 'getPatchFromSIFTParameters.m'

addpath('./provided_code/');

framesdir = './frames/';
siftdir = './sift/';

% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftDir '/*.mat']);
fprintf('reading %d total files...\n', length(fnames));

imnames = dir([framesdir '/*.jpeg']);


allDescriptors = [];
allPositions = [];
allScales = [];
allOrients= [];

imageMat = [];

for i = 1:800 % number of frames

    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');

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

    
    disp(size(descriptorIdx));

    for k=1:25
        featureIdx = descriptorIdx(k);

         % read in the associated image
        imname = [framesdir imageMat(featureIdx).name]; % add the full path
        img = imread(imname);

        grayImg = rgb2gray(img);
        
        patch = getPatchFromSIFTParameters(allPositions(featureIdx,:), allScales(featureIdx), allOrients(featureIdx), grayImg);

        subplot(5,5,k);
        imshow(patch);

    end

end


