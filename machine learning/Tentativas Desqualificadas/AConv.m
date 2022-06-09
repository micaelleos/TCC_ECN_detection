%% AConv
% Operação de correlação cruzada entre um pedacinho de achado RX com a
% imagem de um exame.
clear;clc; close all;

A = imread('../Exames/5961.1.jpeg');
%A = imread('../Exames/Camada 3.png');

if length(size(A))==3
   A=double(rgb2gray(A));
else
    A=double(A);
end

%diretório das bases
arquivos = dir('./1'); 

% número de imgbase abertas por vez
n=7; 
figure
image(A,'CDataMapping','scaled')
colormap('gray')


% filtro de Aprimoramento (enhancement filter)
f=[-1 -1 -1;-1 9 -1; -1 -1 -1];

for i = 7:n
%   abre imgbase 
    b=double(rgb2gray(imread(strcat('1/',arquivos(i+2).name))));
    figure
    image(b,'CDataMapping','scaled')
    title('Kernel');
    
%   Normalização dos vetore
    b1=b;
    b1=b1-sum(sum(b1))/(size(b,1)*size(b,2));
    b1=b1/norm(b1);
    b2=b1(:);
    
    A1=A;
    A1=A1-sum(sum(A1))/(size(A1,1)*size(A1,2));
    A1=A1/norm(A1);
    A2=A1(:);
    
%   Operação de correlação cruzada
    imres = xcorr2(b1,A1);

    %imres = crosscoor( A1,b1 );
    imres1=conv2(imres,f);%abs(imres);
    
    
    figure
    image(imres1,'CDataMapping','scaled')
    title(char(strcat('Resultado',arquivos(i+2).name)));
        
end




    
    
    
    