function [ niveisdec ] = multdecwave(X,tipo,N)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

niveisdec=[];

for i = 1:N
    [WLL,WLH,WHL,WHH] = ddwaveletdec(X,tipo);
    %estrutura de dados
    
    niveisdec(i).WLL = WLL;
    niveisdec(i).WLH = WLH;
    niveisdec(i).WHL = WHL;
    niveisdec(i).WHH = WHH;
    
    X=WLL;
end


end

