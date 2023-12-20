function [pred_error, bayer] = predictErrorSVD(im)

S = im(:,:,2);

box = 3;
zeroSvd = zeros(3);
zeroSvd(1,1) = 1;

[pred_error, bayer]=SVD(S, box, zeroSvd);

end

function [pred_error, bayer] = SVD(im, box, zeroSvd)    

im = double(im);
toCrop=mod(size(im),2);
im=im(1:end-toCrop(1),1:end-toCrop(2),:);

pattern1 = im2col(padarray(im(1:2:end, 1:2:end),[(box - 1)/2 (box - 1)/2],0,'both'), [box box]);
pattern2 = im2col(padarray(im(1:2:end, 2:2:end),[(box - 1)/2 (box - 1)/2],0,'both'), [box box]);
pattern3 = im2col(padarray(im(2:2:end, 1:2:end),[(box - 1)/2 (box - 1)/2],0,'both'), [box box]);
pattern4 = im2col(padarray(im(2:2:end, 2:2:end),[(box - 1)/2 (box - 1)/2],0,'both'), [box box]);


pred_error1 = blkproc(reshape(pattern1,box,[]), [box box], @(bI)svdExtract(bI,box,zeroSvd));
pred_error2 = blkproc(reshape(pattern2,box,[]), [box box], @(bI)svdExtract(bI,box,zeroSvd));
pred_error3 = blkproc(reshape(pattern3,box,[]), [box box], @(bI)svdExtract(bI,box,zeroSvd));
pred_error4 = blkproc(reshape(pattern4,box,[]), [box box], @(bI)svdExtract(bI,box,zeroSvd));

pred_error = zeros(size(im));
pred_pattern1 = reshape(pred_error1,size(im,1)/2,[]);
pred_pattern2 = reshape(pred_error2,size(im,1)/2,[]);
pred_pattern3 = reshape(pred_error3,size(im,1)/2,[]);
pred_pattern4 = reshape(pred_error4,size(im,1)/2,[]);

pred_error(1:2:end, 1:2:end) = pred_pattern1;
pred_error(1:2:end, 2:2:end) = pred_pattern2;
pred_error(2:2:end, 1:2:end) = pred_pattern3;
pred_error(2:2:end, 2:2:end) = pred_pattern4;

if (std(pred_pattern1(:)) + std(pred_pattern4(:))) > std(pred_pattern2(:)) + std(pred_pattern3(:))
    bayer = [1 0; 0 1];
else
    bayer = [0 1; 1 0];
end
end

function [ Out ] = svdExtract(im, box, zeroSvd)
    [U, S, V] = svd(im);
    S(logical(zeroSvd)) = 0;
    Out = U * S * V';
    Out = Out((box + 1)/2, (box + 1)/2); 
end
