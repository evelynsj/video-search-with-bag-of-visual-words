%% rough outline
% select query region inside frame
    % this means that we use only a portion of the descriptors inside a frame, not all
    % create histograms for these descriptors
% compute similarity scores between the query image and remaining images
% do this for four frames

%% Choose four pictures
addpath('../PS 3/provided_code/')
load('kmeans.mat')
load('allBow.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);
% frames = randperm(length(fnames),1);
frames = ['friends_0000001768.jpeg.mat'; 'friends_0000000868.jpeg.mat'; 'friends_0000004697.jpeg.mat'; 'friends_0000002376.jpeg.mat' ];
% fridge, girl's shirt, singing lady, face (failure)

%% Select query region inside frames
queryBow = zeros(size(frames,1), length(means));
for i=1:4
    clf;
    % load image
    fname = [siftdir '/' frames(i,:)];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    imname = [framesdir '/' imname];
    img = imread(imname);
    [oninds, border] = selectRegionMod(img, positions);
    %% create the histogram for query region
    dist = dist2(descriptors(oninds,:), means); % 62 descriptors/dist for img1
    [~, minIdx] = min(dist, [], 2);
    bincounts = histc(minIdx, 1:1500);
    queryBow(i,:) = bincounts';
    %% Compute similarity
    
    simScore = corr(queryBow(i,:)', allBow');
    simScore(isnan(simScore)) = 0;
    % get top 5 by sorting. Need to preserve the index though
    [sortedSim, prevIdx] = sort(simScore, 'descend');
    top5 = sortedSim(2:6);
    top5Idx = prevIdx(2:6);
    
    %% Display
    figure;
    for j=1:6
        subplot(2,3,j);
        if j == 1
            fname = [siftdir '/' frames(i,:)];
        else
            fname = [siftdir '/' fnames(top5Idx(j-1)).name];
        end
        load(fname, 'imname');
        imname = [framesdir '/' imname];
        img = imread(imname);
        imshow(img);
        if j == 1
            hold on;
            polygon = fill(border(:,1),border(:,2),'r'); % creates a polygon & fills with red
            set(polygon, 'FaceColor', 'none'); % removes red fill
            set(polygon, 'EdgeColor', 'y'); 
            set(polygon, 'LineWidth', 5);
        end
    end
    fprintf('hit a key to continue, ctrl-c to stop.\n\n\n');
    pause;
end
