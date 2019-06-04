
addpath('../PS 3/provided_code/')
load('kmeans.mat')
load('allBow.mat')
load('allDeepFC.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);
frames = ['friends_0000004503.jpeg.mat'; 'friends_0000000394.jpeg.mat'];

%% bag of words
queryBow = zeros(2,length(means));
for i=1:2
    fname = [siftdir '/' frames(i,:)];
    load(fname, 'imname', 'descriptors');
    imname = [framesdir '/' imname];
    img = imread(imname);
    dist = dist2(descriptors, means);
    [~, minIdx] = min(dist, [], 2);
    bincounts = histc(minIdx, 1:1500);
    queryBow(i,:) = bincounts';
end

% compute similarity
top10 = zeros(2,10); % result should be 2x10
top10Idx = zeros(2,10);
for i=1:2
    simScore = corr(queryBow(i,:)', allBow'); % compute similarity score
    simScore(isnan(simScore)) = 0;
    % get top 10 by sorting. Need to preserve the index though
    [sortedSim, prevIdx] = sort(simScore, 'descend');
    top10(i,:) = sortedSim(2:11);
    top10Idx(i,:) = prevIdx(2:11);
end

% display
for i=1:2
    figure;
    for j=1:11
        subplot(3,4,j);
        if j == 1
            fname = [siftdir '/' frames(i,:)];
        else
            fname = [siftdir '/' fnames(top10Idx(i,j-1)).name];
        end
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        img = imread(imname);
        imshow(img);
    end
end

%% Alexnet
queryDeepFC = zeros(size(frames, 1), 4096);
for i=1:2
    fname = [siftdir '/' frames(i,:)];
    load(fname, 'imname', 'deepFC7');
    imname = [framesdir '/' imname];
    img = imread(imname);
    queryDeepFC(i,:) = deepFC7;
end

% compute similarity
for i=1:2
    simScore = corr(queryDeepFC(i,:)', allDeepFC');
    simScore(isnan(simScore)) = 0;
    % get top 10 by sorting. Need to preserve the index though
    [sortedSim, prevIdx] = sort(simScore, 'descend');
    top10(i,:) = sortedSim(2:11);
    top10Idx(i,:) = prevIdx(2:11);
end

for i=1:2
    figure;
    for j=1:11
        subplot(3,4,j);
        if j == 1
            fname = [siftdir '/' frames(i,:)];
        else
            fname = [siftdir '/' fnames(top10Idx(i,j-1)).name];
        end
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        img = imread(imname);
        imshow(img);
    end
end

