clear; clc; close all;



%Abrir a imagem
load wbarb;

%Decomposi��o wavelet
niveis=3;
tipo='bior1.3'
[ niveisdec ] = multdecwave(X,tipo,niveis)
En=zeros(niveis,1);
for i = 1: niveis
   %exibi��o das imagens
   showdecwave(niveisdec(i).WLL,niveisdec(i).WLH,niveisdec(i).WHL,niveisdec(i).WHH,map) 
   % C�lculo de energia por n�vel
   En(i)= sum(sum((niveisdec(i).WLL)^2+(niveisdec(i).WLH)^2+(niveisdec(i).WHL)^2+(niveisdec(i).WHH)^2)); 
end



