function [ Img ] = downsamplep( IMG, k )
% Cria estrutura pirâmide com a diminuição das dimensão da imagem 

Img(1).imd=IMG;
l=2;
for n = 1:k
    if (mod(n,2)==0)
    img = zeros(floor(size(IMG,1)/n),floor(size(IMG,2)/n));

    for i  = 1 : size(img,1)
        for j  = 1 : size(img,2)
       img(i,j) = sum(sum(IMG(i*n-n+1:(i+1)*n-n,j*n-n+1:(j+1)*n-n)))/2*n;
        end
    end
    
    Img(l).imd=img;
    l=l+1;
    end
end

end