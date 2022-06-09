function [ G,teta ] = fderivativo( img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[dx dy]=size(img);

X=zeros(dx,dy);
Y=zeros(dx,dy);
% nesta convolução há redução da imagem de saída - sem padding
for i = 1:dx-1
    for j = 1:dy-1
        X(i,j)=img(i+1,j)-img(i,j);
        Y(i,j)=img(i,j+1)-img(i,j);
    end
end

G=sqrt(X.^2+Y.^2);
teta=atan(Y./X);

limiar=mean(mean(G))*10+2;
G(G>limiar)=0;

end

