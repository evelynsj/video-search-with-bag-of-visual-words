% Use the two images and associated features in provided file twoFrameData.mat

%% Allow a user to select a region of interest in one frame using selectRegion.m
load('twoFrameData');
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
% oninds = selectRegion(im1, positions1);
[oninds,border] = selectRegionMod(im1, positions1); 

% DISPLAY SELECTED REGION IN IMAGE
hold on;
imshow(im1);
polygon = fill(border(:,1),border(:,2),'r'); % creates a polygon & fills with red
set(polygon, 'FaceColor', 'none'); % removes red fill
set(polygon, 'EdgeColor', 'y'); 
set(polygon, 'LineWidth', 5);


%% Match descriptors in that region to descriptors in second image based on Euclidean distance in SIFT space
% oninds = tells us positions in the region where it has SIFT extracted
% display features in region of interest
% imshow(im1);
% displaySIFTPatches(positions1(oninds,:), scales1(oninds), orients1(oninds), im1);
% title('Display features in region of interest');
% fprintf('hit a key to continue.\n');
% pause;

numfeats = size(oninds, 1);
match = [];
threshold = 0.8;
for i=1:numfeats
    dist = dist2(descriptors1(oninds(i),:), descriptors2); % we want to find the Euclid distance for each position
    % i,j is the euclid dist between ith row of d1 and jth row of d2
    % so the dist of each feature in d1 (within boundary of interest points) is compared against every other feature in d2
    % we want to find the minimum distance and the index to know which feature is the minimum in d2
    % and make sure it's not an ambiguous match
    [sortedDist, origIdx] = sort(dist);
    minDist = sortedDist(1);
    I = origIdx(1);
    secondMinDist = sortedDist(2);
    if minDist / secondMinDist < threshold
        match = [match, I];
    end
end

%% Display selected region of interest in the image (polygon) and the matched features in the second image
match = match';
figure;
imshow(im2);
displaySIFTPatches(positions2(match,:), scales2(match), orients2(match), im2);
