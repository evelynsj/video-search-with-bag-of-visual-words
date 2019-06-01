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

% images = dir([framesDir '/*jpeg']);
% x = length(matfiles); 
% disp(x);

allDescriptors = [];

for i = 1:400 % number of frames

    % load that file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
%     disp(numfeats);
    
    if(numfeats >= 50)
        descriptorIndex = randperm(numfeats, 50); 
%         disp(mydescriptors);

%         disp(descriptors(descriptorIndex,:));
        allDescriptors = [allDescriptors; descriptors(descriptorIndex,:)];
        
    end
    
end

allDescriptors = allDescriptors';

% 	membership	1xn cluster membership vector
% 	means		dxk matrix of cluster centroids
k=1500;
[membership,means] = kmeansML(k, allDescriptors);
