function [WLL,WLH,WHL,WHH] = ddwaveletdec(X,tipo)
%UNTITLED Summary of this function goes here
%   Decomposição de imagem por wavelet
    
    if (strcmp(tipo,'haar'))
        W=[0.5 0.5];
        
    else
        [RF,W] = biorwavf(tipo);
    end
    
    [Lo_D,Hi_D,Lo_R,Hi_R] = orthfilt(W);
    
    tf=size(W,2); % tamanho do filtro para tratamento das bordas
    
    %colunas
    xc=X';
    imH=xc(:); %imagem p/ pross. horizontal (variação entre linhas)
    wH=conv(Hi_D,imH); % passa alta
    wH=wH(tf:end);
    wL=conv(Lo_D,imH); % passa baixa
    wL=wL(tf:end);
    
    WH=reshape(wH,size(xc));
    WL=reshape(wL,size(xc));
    
    Wh=WH(1:2:end,:)';% ver se essa lógica está certa
    Wl=WL(1:2:end,:)';
    
    %LL decomposição
    wL = Wl(:);
    wLL=conv(Lo_D,wL);
    wLL=wLL(tf:end);
    WLL=reshape(wLL,[size(xc,1) size(xc,2)/2]);
    WLL=WLL(1:2:end,:);
    
    %LH detalhes horizontais
    wLH=conv(Hi_D,wL);
    wLH=wLH(tf:end);
    WLH=reshape(wLH,[size(xc,1) size(xc,2)/2]);
    WLH=WLH(1:2:end,:);
    
    %HL detalhes verticais
    wH = Wh(:);
    wHL=conv(Lo_D,wH);
    wHL=wHL(tf:end);
    WHL=reshape(wHL,[size(xc,1) size(xc,2)/2]);
    WHL=WHL(1:2:end,:);
    
    %HH detalhes diagonais
    wHH=conv(Hi_D,wH);
    wHH=wHH(tf:end);
    WHH=reshape(wHH,[size(xc,1) size(xc,2)/2]);
    WHH=WHH(1:2:end,:);

end

