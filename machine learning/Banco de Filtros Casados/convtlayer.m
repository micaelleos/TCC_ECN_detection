function [resLn] = convtlayer(tLnx,layer)
%Convolution tensor on layer
%   tLnx(nk,x,y) = tensor de entrada
%   layer = número da camada
%   resLn(nt,x,y)
%   Detailed explanation goes here

%% Criação das estruturas de dados
%banco de tensores (filtros)
tLn_t=gpuArray(importdata(strcat('./tensor/tL',int2str(layer),'_t.mat')));
dim_t=size(tLn_t); % [nt nk x y]

%Tensor de entrada
tLn=gpuArray(tLnx);
dim=size(tLn);

%
recorte=zeros(dim(1),dim(2),dim(3),'gpuArray');
resLnx=zeros(dim_t(1),dim(2),dim(3),'gpuArray');
recorte2=zeros(dim(2)+dim_t(3)-1,dim(3)+dim_t(4)-1);
%
image=zeros(dim(2),dim(3));
kernel=zeros(dim_t(3),dim_t(4));
tensor=zeros(dim_t(2),dim_t(3),dim_t(4)); 

%% Processamento
h = waitbar(0,strcat('Processando imagem na Camada:  ',int2str(layer)));
for i = 1:dim_t(1) %nt
    tensor=squeeze(tLn_t(i,:,:,:));
    for c = 1:dim_t(2) %nk
    image=squeeze(tLn(c,:,:));
    kernel=squeeze(tensor(c,:,:));
    %recorte(c,:,:)=convn(image,kernel,'same'); 
    if(range(range(kernel)) ~= 0)
    recorte2=normxcorr2(kernel,image);
    else
    recorte2=zeros(dim(2)+dim_t(3)-1,dim(3)+dim_t(4)-1);
    end
    recorte(c,:,:)=recorte2(floor(dim_t(3)/2):end-floor(dim_t(3)/2),floor(dim_t(4)/2):end-floor(dim_t(4)/2));
    end
    resLnx(i,:,:)= sum(recorte,1); 
    waitbar(i/dim(1))
end
delete(h)
resLn=gather(resLnx);
reset(gpuDevice(1));
end

