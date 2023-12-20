function [statistics] = getFeature(map,Bayer,Nb)

% Proposed feature to localize CFA artifacts

pattern = kron(ones(Nb/2,Nb/2),Bayer);

func = @(sigma) sum(sigma(logical(pattern)))/sum(sigma(not(logical(pattern))));                       

statistics = blkproc(map,[Nb Nb],func);

statistics = real(statistics);
statistics(isnan(statistics))=1;
statistics(isinf(statistics))=0;

return