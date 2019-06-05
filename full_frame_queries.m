%% Rough outline:
% 1. Choose 3 different/random frames to serve as queries
% 2. Create the bag of words for each query image (bag of words = histogram, use histc)
% 3. Create the bag of words for all remaining frames (bag of words = histogram, use histc)
% 4. Compute similarity scores between query image and remaining images to determine top 5 most similar images to query image
    
%% Choose 3 different/random frames to serve as queries & create a bag of word for each query image

addpath('../PS 3/provided_code/')
load('kmeans.mat')
load('allBow.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);
randFrames = randperm(length(fnames), 3);

imageNames = [];
queryBow = [];
for i=1:3
    fname = [siftdir '/' fnames(randFrames(i)).name];
    load(fname, 'imname', 'descriptors');
    % get image names
    imageNames = [imageNames; imname];
    % find the distances between each descriptor and the kmeans clusters (use dist2)
    dist = dist2(descriptors, means); % each row values are the distance from each descriptor to all 1500 words hence nx1500
    % Get the membership vector
    [~, minIdx] = min(dist, [], 2);
    % create a histogram
    bincounts = histc(minIdx, 1:1500);
    queryBow = [queryBow; bincounts']; % BoW for the three query images are stored in queryBow (each row corresponds to each image)
end

%% Compute similarity scores

simScore = []; % result should be 1x6612
top5 = zeros(3,5); % result should be 3x5
top5Idx = zeros(3,5);
for i=1:3
    simScore = corr(queryBow(i,:)', allBow'); % compute similarity score
    simScore(isnan(simScore)) = 0;
    % get top 5 by sorting. Need to preserve the index though
    [sortedSim, prevIdx] = sort(simScore, 'descend');
    top5(i,:) = sortedSim(2:6);
    top5Idx(i,:) = prevIdx(2:6);
end

for i=1:3
    figure;
    for j=1:6
        subplot(2,3,j);
        if j == 1
            fname = [siftdir '/' fnames(randFrames(i)).name];
        else
            fname = [siftdir '/' fnames(top5Idx(i,j-1)).name];
        end
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        img = imread(imname);
        imshow(img);
    end
end

%% thoughts
% we need to use dist to find membership for the query images because the
% membership matrix that kmeansml outputs is only for the descriptors that
% are sampled. And we don't know if our query image is part of that.

% Create a histogram/BoW for a frame:
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
        % Determine which word out of the 1500 words the minimum distance corresponds to
        % the value in the membership matrix is just the index of the word descriptor (so max is 1500)
    % range = 1:1500