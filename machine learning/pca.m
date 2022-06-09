clear; clc; close all;

%abrindo imagens
nomedir='4'; 
arquivos = dir(strcat('./',nomedir)); 
quantIm = length(arquivos)-2;

%% PCA Sem dividir os vetores pela norma
P=zeros(20*20,quantIm);
for l = 1: quantIm
b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));
P(:,l)=b(:);
%P(:,l)=b(:)/norm(b(:));
end

PM=zeros(size(P));
for i = 1:quantIm
PM(:,i)=P(:,i)-mean(P')';
end

PMP=PM*PM';
e = eig(PMP);
[V,D] = eig(PMP);
nc=10;%número de compomentes

Vm=V(:,end-(nc-1):end);
Vmm=reshape(Vm,[20,20,nc]);

for j=1:nc
figure
colormap('gray')
image(Vmm(:,:,j),'CDataMapping','scaled')
title(int2str(j))
imwrite(Vmm(:,:,j),strcat('./2/',int2str(j),'.jpg'));
end
%% PCA Dividindo os vetores pela norma
% 
% P2=zeros(20*20,quantIm);
% for l = 1: quantIm
% b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));
% P2(:,l)=b(:)/norm(b(:));
% end
% 
% PM2=zeros(size(P2));
% for i = 1:quantIm
% PM2(:,i)=P2(:,i)-mean(P2')';
% end
% 
% PMP2=PM2*PM2';
% e2 = eig(PMP2);
% [V2,D2] = eig(PMP2);
% nc=10;%número de compomentes
% 
% Vm2=V2(:,end-(nc-1):end);
% Vmm2=reshape(Vm2,[20,20,10]);
% 
% for j=1:10
% figure
% colormap('gray')
% image(Vmm2(:,:,j),'CDataMapping','scaled')
% title(int2str(j))
% %imwrite(Vmm2(:,:,j),strcat('./2',int2str(j),'.jpg'));
% end