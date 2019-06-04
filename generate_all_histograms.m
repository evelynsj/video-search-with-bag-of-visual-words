addpath('../PS 3/provided_code/')
load('kmeans.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);

allBow = zeros(length(fnames), 1500); % result should be 6612x1500
for i=1:length(fnames)
    disp(i);
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'descriptors');
    if size(descriptors, 1) == 0
        continue;
    end
    dist = dist2(descriptors, means);
    [~, minIdx] = min(dist, [], 2);
    bincounts = histc(minIdx, 1:1500);
    bincounts(isnan(bincounts)) = 0;
    allBow(i,:) = bincounts';
end

save('allBow.mat', 'allBow');