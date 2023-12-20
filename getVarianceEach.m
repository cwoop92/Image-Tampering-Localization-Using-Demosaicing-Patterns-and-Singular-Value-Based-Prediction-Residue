function [var_map] = getVarianceEach(im,dim)

% extend pattern over all image
pattern1 = kron(ones(dim(1)/2,dim(2)/2), [1 0; 0 0]);
pattern2 = kron(ones(dim(1)/2,dim(2)/2), [0 1; 0 0]);
pattern3 = kron(ones(dim(1)/2,dim(2)/2), [0 0; 1 0]);
pattern4 = kron(ones(dim(1)/2,dim(2)/2), [0 0; 0 1]);

% separate acquired and interpolate pixels for a 7x7 window% 
box = 5;
mask = kron(ones(box,box), [1 0; 0 0]);
mask = mask(1:(2*box-1), 1:(2*box-1));

window = mask;
vc = sum(window(:));
window_mean = window./vc;

% local variance of acquired pixels
pixel1 = im.*(pattern1);
mean_map_acquired1 = imfilter(pixel1,window_mean,'replicate').*pattern1;
sqmean_map_acquired1 = imfilter(pixel1.^2,window_mean,'replicate').*pattern1;
var_map_acquired1 =  (sqmean_map_acquired1 - (mean_map_acquired1.^2))/vc;

pixel2 = im.*(pattern2);
mean_map_acquired2 = imfilter(pixel2,window_mean,'replicate').*pattern2;
sqmean_map_acquired2 = imfilter(pixel2.^2,window_mean,'replicate').*pattern2;
var_map_acquired2 =  (sqmean_map_acquired2 - (mean_map_acquired2.^2))/vc;

pixel3 = im.*(pattern3);
mean_map_acquired3 = imfilter(pixel3,window_mean,'replicate').*pattern3;
sqmean_map_acquired3 = imfilter(pixel3.^2,window_mean,'replicate').*pattern3;
var_map_acquired3 =  (sqmean_map_acquired3 - (mean_map_acquired3.^2))/vc;

pixel4 = im.*(pattern4);
mean_map_acquired4 = imfilter(pixel4,window_mean,'replicate').*pattern4;
sqmean_map_acquired4 = imfilter(pixel4.^2,window_mean,'replicate').*pattern4;
var_map_acquired4 =  (sqmean_map_acquired4 - (mean_map_acquired4.^2))/vc;

var_map = var_map_acquired1 + var_map_acquired2 + var_map_acquired3 + var_map_acquired4;

return
