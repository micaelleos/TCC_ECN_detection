function [ img ] = downsample( IMG, n )
%UNTITLED Summary of this function goes here
%   Diminuir dimensão da imagem
img =zeros(floor(size(IMG,1)/n),floor(size(IMG,2)/n));

for i  = 1 : size(img,1)
    for j  = 1 : size(img,2)
   img(i,j) = sum(sum(IMG(i*n-n+1:(i+1)*n-n,j*n-n+1:(j+1)*n-n)))/2*n;
    end
end

end

