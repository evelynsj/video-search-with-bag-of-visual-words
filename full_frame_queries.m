%% Rough outline:
% 1. Choose 3 different/random frames to serve as queries
% 2. Create the bag of words for each query image (bag of words = histogram, use histc)
% 3. Create the bag of words for all remaining frames (bag of words = histogram, use histc)
% 4. Compute similarity scores between query image and remaining images to determine top 5 most similar images to query image
    % can use normalized scalar product
    % or can use corr
    
% Create a histogram/BoW for a frame:
% ASK: WHEN DO WE USE KMEANS.MAT
% 1. Get a membership matrix: Use dist2/distsqr and min to determine which words/kmeans clusters the sampled descriptors fall into
% 2. Feed the matrix along with the range 1:k into histc
    % bincounts output will be the bag of words
    % [bincounts] = histc(X,range)
    % X: list of all words in the image.
        % Get the list of words:
        % use dist2 to find the distances between each descriptor (in the
        % query image) and the kmeans clusters
        % Find the minimum distances for each descriptor
        % Take minimum across the rows of result (of dist2) and note down
        % the indices of all the minimums. Can do this in one line with the
        % min function ==> membership array
        % Determine which word out of the 1500 words the minimum distance
        % corresponds to
        % the value in the membership matrix is just the index in the
        % descriptor (so max is 1500)
    % range = 1:1500
    
%% Choose 3 different/random frames to serve as queries

addpath('../PS 3/provided_code/')
load('kmeans.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);
randFrames = randperm(length(fnames), 3);

imageNames = [];
for i=1:3
    fname = [siftdir '/' fnames(randFrames(i)).name];
    load(fname, 'imname');
    imageNames = [imageNames; imname];
end

%% Create bag of words for each query image
for i=1:1
    % get the descriptors
    fname = [siftdir '/' fnames(randFrames(i)).name];
    load(fname, 'descriptors');
    % find the distances between each descriptor and the kmeans clusters (use dist2)
    dist = dist2(descriptors, means); % each row values are the distance from each descriptor to all 1500 words hence nx1500
    % Get the membership vector
    [min, minIdx] = min(dist, [], 2);
end

%% thoughts
% we need to use dist to find membership for the query images because the
% membership matrix that kmeansml outputs is only for the descriptors that
% are sampled. And we don't know if our query image is part of that.