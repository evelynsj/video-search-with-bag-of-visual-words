addpath('../PS 3/provided_code/')
load('kmeans.mat')

framesdir = '../PS 3/frames/';
siftdir = '../PS 3/sift/';

fnames = dir([siftdir '/*.mat']);

allDeepFC = zeros(length(fnames), 4096); % result should be 6612x4196
for i=1:length(fnames)
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'deepFC7');
    allDeepFC(i,:) = deepFC7;
end

save('allDeepFC.mat', 'allDeepFC');