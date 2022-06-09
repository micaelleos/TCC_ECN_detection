function [tresL2] = tcbancfiltpmax(A,resL1,nomex)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imres = []; 

%dimansão dos tensores
dtx=40;
dty=40;

%pasta fixa filtros. Abre-se a pasta segundo o nome da imagem de
%referência nomex
nomedir=strcat('./Base_de_teste_2/',nomex,'/20x20');

arquivos = dir(strcat('./',nomedir)); %diretório das bases
quantIm = length(arquivos)-2;

h = waitbar(0,'Extraindo tensores da saída da camada 1 ');

tresL2=zeros(quantIm,size(resL1,1),dtx,dty);

vmax=[];

for l = 1: quantIm
b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));

%Filtro Casado
imres = filtrocasado(A, b);

%encontra região dos pontos máximos (próximos à 1)
[x y] = find(imres==max(max(imres)));  

%Corte através do tensor
tresL2(l,:,:,:)=resL1(:,x-floor(dtx/2)+1:x+ceil(dtx/2),y-floor(dty/2)+1:y+ceil(dty/2));

vmax=[vmax; x y];
clear x y;

waitbar(l/quantIm)
end
toc

delete(h)

tL2=tresL2;
save('vmax');
save(strcat('./4/tensor/tL21'),'tL2');
end

