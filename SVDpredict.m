function [result] = SVDpredict(im, Nb)
    
    im = double(im);
    toCrop=mod(size(im),Nb);
    im=im(1:end-toCrop(1),1:end-toCrop(2),:);
    
    % green channel extraction
    imG = predictErrorSVD(im);
    [h, w] = size(imG);
    dim = [h, w];
     
    % make variation map
    var_map = getVarianceEach(imG, dim);
    
    % local variance of acquired and interpolated pixels
    stat1 = getFeature(var_map, [1 0; 0 1], Nb);
    stat2 = getFeature(var_map, [0 1; 1 0], Nb);
    
    if sum(stat1(:)) > sum(stat2(:))
        stat = stat1; 
    else
        stat = stat2;
    end

    map = medfilt2(stat,[5 5],'symmetric');
    expMap=exp(map);
    probMap=1./(expMap+1);
    result=probMap;     
    result = (result-min(result(:)))/(max(result(:))-min(result(:)));

end