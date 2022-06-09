function [maximos,varargout] = bancofiltcgpu( A,limiar,nomedir)
%Processamento da imagem A por todos os kernels contidos em nomedir. Retorna
%as maiores correspond�ncias acima do limiar, em formato de matriz
%multidimencional. resultado(nk(canais), dimxA, dimyA)

%soma=zeros(size(A));

%% Abrindo diret�rio dos kernels
arquivos = dir(nomedir); %diret�rio das bases
quantIm = length(arquivos)-3;

%% Inicializa��o das vari�veis
imres = zeros(size(A)); 
vmax=zeros(size(imres)); % para recorte de valores dentro do limiar
dim=[size(imres)]; %vetor de dimens�es


%para recortar as regi�es que correspondem com o limiar da fun��o
%recorte=zeros(dim(1),dim(2));

% Tensor para os valores de imres dentro da faixa definida em limiar
%resultado=zeros(quantIm,size(A,1),size(A,2));

%Localiza��o dos pontos m�ximos referentes a cada kernel
%maximos=zeros(3,quantIm+1);
maximos=zeros(1,quantIm+1);
%%
%h = waitbar(0,'Processando imagem no Banco de Filtros');

for l = 1: quantIm
b=[];
b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));
dim_b=[size(b)];

if (any(any(b)) && any(any(A)) )
%Filtro Casado
imres = filtrocasadogpu(A, b);
maximo=max(max(abs(imres)));
else
    maximo=0;
end

%constru��o de m�scara para recorte dos m�ximos
%vmax = zeros(size(imres));



%localiza��o do m�ximo
% [x y] =find(abs(imres)==maximo);
% %centraliza��o do encaixe do kernel
% x=x-floor(dim_b(1)/2);
% y=y-floor(dim_b(2)/2);
% 
% maximos(:,l)=[x(1) y(1) maximo];

maximos(l)=[maximo];

 %vmax(abs(imres)>(maximo*limiar))= 1;
 %Recorte dos valores intermedi�rio (permanece apenas os m�ximos absolutos)
 %recorte=vmax.*imres;
 %resultado(l,:,:) = recorte(ceil(dim_b(1)/2):end - floor(dim_b(1)/2),ceil(dim_b(2)/2):end - floor(dim_b(2)/2));

%waitbar(l/quantIm)

%soma = soma + recorte(ceil(dim_b(1)/2):end - floor(dim_b(1)/2),ceil(dim_b(2)/2):end - floor(dim_b(2)/2));
end

% figure
% colormap('gray')
% image(soma,'CDataMapping','scaled')
% colorbar

varargout{1}= 0;%resultado;
%delete(h)
end

