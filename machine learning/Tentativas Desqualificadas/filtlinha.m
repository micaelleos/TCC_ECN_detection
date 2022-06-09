function [ w ] = filtlinha(n,m)
%UNTITLED Summary of this function goes here
%   m e n são as dimensões do filtro
    
    p=1;
    if(rem(n,2)==0) %se par
        matx1=-[0:p:n/2-1];
        matx1(1)=p*n/2;
        d1=repmat(matx1',1,m);
        d2=repmat(matx1(end:-1:1)',1,m);
    else
        matx1=-[0:p:floor(n/2)];
        matx1(1)=p*floor(n/2);
        d1=repmat(matx1',1,m);
        d2=repmat(matx1(end-1:-1:1)',1,m);
    end
    
    w=[d1;d2];
    w=w/norm(w);
end

