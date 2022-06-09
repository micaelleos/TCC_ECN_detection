function [ resultado ] = cbancfiltpmax(A,limiar)
%   Filtra imagem A com os kernels da pasta em dentro de "nomedir"
%   Retorna os maiores "limiar" valores da opera��o numa imagem de tamanho
%   reduzido de size(A)- size(b)/2, onde b � o kernel
%   convolutional layer = Banco de filtros casados; pooling layer = m�ximos 

imres = []; 
vmax=[];

%diret�rio dos kernels
nomedir='4'; 

arquivos = dir(strcat('./',nomedir)); %diret�rio das bases
quantIm = 2;length(arquivos)-3;

%excluir pasta tensor
arquivos(find(strcmp({arquivos(:).name},'tensor')==1))=[];

b=imread(strcat(nomedir,'/',arquivos(3).name));

h = waitbar(0,'Processando imagem na camada 1');

% Vari�vel de resultado com pedding do tamanho do filtro
resultado=zeros(quantIm,size(A,1)-ceil(size(b,1)/2),size(A,2)-ceil(size(b,2)/2));

for l = 1: quantIm
b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));

%Filtro Casado
imres = filtrocasado(A, b);

%encontra regi�o dos pontos m�ximos (pr�ximos � 1)
%[x y] = find(imres>max(max(imres))*limiar);  

%coordenadas dos m�ximos
% vmax(l).x=x; 
% vmax(l).y=y; 

%constru��o de m�scara para recorte dos m�ximos
vmax = zeros(size(imres)); 
vmax(imres>max(max(imres))*limiar)= 1;

%Recorte dos valores m�nimos (permanece apenas os m�ximos)
resultado(l,:,:) = vmax.*imres;
%clear x y;

waitbar(l/quantIm)
end


delete(h)

tL1=resultado;

%save(strcat('./',nomedir,'/tensor/tL1'),'tL1');

end

