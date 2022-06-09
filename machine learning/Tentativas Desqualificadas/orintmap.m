%% Teste com mapa de orientação

clear;clc; close all;

A = imread('../Recortes/5961.1.jpeg');
%A = imread('./1/Camada 22.png');
if length(size(A))==3
   A=double(rgb2gray(A));
else
    A=double(A);
end

imshow(uint8(A));

%Filtro passa baixa
sigma=3;
Ag = imgaussfilt(A,sigma);


%detector de borda derivativo
X=zeros(size(A));
Y=zeros(size(A));
for i = 2: size(A,1)
    for j = 2: size(A,2)
        X(i,j)=Ag(i,j) - Ag(i-1,j);
        Y(i,j)=Ag(i,j) - Ag(i,j-1);
    end
end

mag= sqrt((X.^2+Y.^2));
angulo = atan((Y/X));

% limiar=8;
% mag(mag<limiar)=0;

figure
image(mag,'CDataMapping','scaled')
title('Magnitude')
colorbar

figure
image(angulo,'CDataMapping','scaled')
title('Gradiente')
colorbar

figure
c=imfuse(mag,A);
image(c);