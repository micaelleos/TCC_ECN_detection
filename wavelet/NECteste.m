clear; clc; close all;
% Para a função ddwaveletdec funcionar a dimensão da imagem
% deve ser de base 2
A = imread('../img/9794.3.jpg');
dx=2^(floor(log2(size(A,1))));
dy=2^(floor(log2(size(A,2))));
A1=rgb2gray(A);
Ar = A1(1:dx,size(A,2)-dy+1:end);
%A1=double(A);
colormap('pink');imshow(Ar)
figure
colormap('pink');imshow(A)
n=3
niveisdec = multdecwave(Ar,'haar',n);

map=colormap('pink');

for i=1:n
showdecwave( niveisdec(i).WLL,niveisdec(i).WLH,niveisdec(i).WHL,niveisdec(i).WHH,map,0 );
end

% energy  = waveEnergy( niveisdec );
% energy2=energy/sum(sum(energy));
% 
% figure;plot(energy(:,1))
% figure;plot(energy(:,2))
% figure;plot(energy(:,3))
% figure;plot(energy(:,4))