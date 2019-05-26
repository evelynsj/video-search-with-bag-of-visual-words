% Use the two images and associated features in provided file twoFrameData.mat

%% Allow a user to select a region of interest in one frame using selectRegion.m
load('twoFrameData');
% descriptors: SIFT vectors as rows -> describes local patch features of every pixel
% We want to get the interest points and look at the descriptors at those selected points

% display all features
% imshow(im1);
% displaySIFTPatches(positions1, scales1, orients1, im1);
% title('Show all features');
% fprintf('hit a key to continue.\n');
% pause;
% clf;

% select region of interest
fprintf('\n\nuse the mouse to draw a polygon, double click to end it\n');
oninds = selectRegion(im1, positions1);


%% Match descriptors in that region to descriptors in second image based on Euclidean distance in SIFT space

%% Display selected region of interest in the image (polygon) and the matched features in the second image
