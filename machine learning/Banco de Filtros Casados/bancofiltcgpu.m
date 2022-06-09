function [maximos,varargout] = bancofiltcgpu( A,limiar,nomedir)
%Processamento da imagem A por todos os kernels contidos em nomedir. Retorna
%as maiores correspondências acima do limiar, em formato de matriz
%multidimencional. resultado(nk(canais), dimxA, dimyA)

%soma=zeros(size(A));

%% Abrindo diretório dos kernels
arquivos = dir(nomedir); %diretório das bases
quantIm = length(arquivos)-3;

%% Inicialização das variáveis
imres = zeros(size(A)); 
vmax=zeros(size(imres)); % para recorte de valores dentro do limiar
dim=[size(imres)]; %vetor de dimensões


%para recortar as regiões que correspondem com o limiar da função
%recorte=zeros(dim(1),dim(2));

% Tensor para os valores de imres dentro da faixa definida em limiar
%resultado=zeros(quantIm,size(A,1),size(A,2));

%Localização dos pontos máximos referentes a cada kernel
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

%construção de máscara para recorte dos máximos
%vmax = zeros(size(imres));



%localização do máximo
% [x y] =find(abs(imres)==maximo);
% %centralização do encaixe do kernel
% x=x-floor(dim_b(1)/2);
% y=y-floor(dim_b(2)/2);
% 
% maximos(:,l)=[x(1) y(1) maximo];

maximos(l)=[maximo];

 %vmax(abs(imres)>(maximo*limiar))= 1;
 %Recorte dos valores intermediário (permanece apenas os máximos absolutos)
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

