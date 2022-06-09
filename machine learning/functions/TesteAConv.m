%% AConv
%Teste de operação com filtro casado correlation
clear;clc; close all;

% abertura das imagens
Ag = imread('../Exames/5961.1.jpeg');

if length(size(Ag))==3
   Ag=double(rgb2gray(Ag));
else
    Ag=double(Ag);
end 

%mascara para calculo de erros e acertos

Am = imread('./Mascaras/5961.1.jpg');

if length(size(Am))==3
   Am=double(rgb2gray(Am));
else
    Am=double(Am);
end 

d=10;
AM=downsample( Am, d );
AM(AM>0)=1;
%A=medfilt2(Ag);
A  = downsample( Ag, d );
 

% pontos de maximo a serem encontrados
pontos=10;
correspo= 0.6 ; % porcentagem de melhores correspondências
%  figure
% image(A,'CDataMapping','scaled')
% colormap('gray')

 %% 

%diretório das bases
arquivos = dir('./2'); 

% número de imgbase abertas por vez
n=length(arquivos)-2;
%n=7;
h = waitbar(0,'Processando base...');
for i = 1:n
%   abre imgbase 
%    bg=double(rgb2gray(imread(strcat('2/',arquivos(i+2).name))));
     bg=double(imread(strcat('2/',arquivos(i+2).name)));
    %b=medfilt2(bg);
    b  = downsample( bg, d );
    
    %b=A(176-10:176+10,114-10:114+10);
   
    tic
%   Filtro Casado
    %imres = crosscoor( A,b );
    imres = filtrocasado( A, b );
    %imres2 = normxcorr2(b,A);
    toc
    waitbar(i / n)
%% Encontrar melhor ponto/região correspondente
    [x y] = find(imres == max(max(imres))); 
%     [sortedX, sortedInds] = sort(imres(:),'descend');
%     tops = sortedInds(1:pontos);
%     [x, y] = ind2sub(size(imres), tops);
    
    imres3=zeros(size(imres));
    imres3(imres>(max(max(imres))*correspo))=1;
    %[x2 y2] = find(imres2 == max(max(imres2)));
   
    c1=imfuse(imres3,A);
    c=imfuse(c1,AM);
    
% %% ERRADO
%taxa de acertos
% 
% AMn=ones(size(AM));
% AMn(AM==1)=0;
% 
% imres3n=ones(size(imres3));
% imres3n(imres3==1)=0;
% 
% tot=sum(AM(:));
% acertos=100*sum(sum(bitand(imres3,AM)))/tot
% fpositivos=sum(sum(bitand(imres3,AMn)))/tot
% fnegativos=sum(sum(bitand(imres3n,AM)))/tot
    
%% Exibição
    figure
    subplot(1,3,1)
    image(b,'CDataMapping','scaled')
    colormap('gray')
    title('Kernel');
    subplot(1,3,2)
    image(imres,'CDataMapping','scaled')
    title(char(strcat('Resultado',arquivos(i+2).name)));
    hold on
    plot(y,x,'dr')
    subplot(1,3,3)
    image(c,'CDataMapping','scaled')
    colormap('gray')
    title(char(strcat('Resultado',arquivos(i+2).name)));
    hold on
    plot(y,x,'dr')
   
    
   
%     figure
%     title('2tipo')
%     subplot(1,2,1)
%     image(imres2,'CDataMapping','scaled')
%     title(char(strcat('Resultado',arquivos(i+2).name)));
%     subplot(1,2,2)
%     image(A,'CDataMapping','scaled')
%     colormap('gray')
%     title(char(strcat('Resultado',arquivos(i+2).name)));
%     hold on
%     plot(y2,x2,'dr')


end
close(h) 

    
    
    
    