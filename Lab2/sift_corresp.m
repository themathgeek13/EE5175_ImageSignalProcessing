% 
% [corresp1, corresp2] = sift_corresp(image1, image2, show_fig)
%
% This function reads two images (file name strings), finds their 
% SIFT features, and returns the correspondences based on the 
% distance between the nearest and second nearest neighbour.
% 
% corresp1(i,:) point of image1 corresponds to corresp2(i,:) point of image2
% 
% correspx(i,1) = row number of ith point
% correspx(i,2) = column number of ith point

function [corresp1, corresp2] = sift_corresp(imgName1, imgName2)

% Find SIFT keypoints for each image
[~, desc1, loc1] = sift(imgName1);
[~, desc2, loc2] = sift(imgName2);

% dist_ratio: Only keep matches in which the ratio of vector angles from the
% nearest to second nearest neighbor is less than distRatio.
dist_ratio = 0.6;   

% For each feature in the first image, select its match to second image.
desc2t = desc2';
count = 1;
for i = 1 : size(desc1,1)
   inprods = desc1(i,:) * desc2t; % Vector of inner products
   [vals,idx] = sort(acos(inprods)); % Take cos inverse and sort results

   % Check if nearest neighbour has angle less than dist_ratio times second
   if (vals(1) < dist_ratio * vals(2))
      corresp1(count,:) = loc1(i,1:2);
      corresp2(count,:) = loc2(idx(1),1:2);
      count = count + 1;
   end
end

