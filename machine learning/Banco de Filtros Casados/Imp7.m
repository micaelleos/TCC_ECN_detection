%% Implementação 7
% Funções com cálculo de computação paralela.
% Estrutura de banco de filtros agora organizado para os tensores

clear;clc;close all;
%% Abertura das imagens
%tic
nomex='6355'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Recorte de kernels
coor=recorteKernels(A,AM,20);

%% Data Augmentation

% FUNÇÃO

%% Banco de Filtros 
limiar=0.5;
%layer 1
[ resL1, maximos ] = bancofiltcgpu(A,limiar,20);

%% Contrução do kernel 2 camada

[tL1_t] = extratensor(resL1,maximos(1:2,:),20);
salvaresultado('0',tL1_t);

%% Camada 2
gpuDevice(1) %limpar GPU
[resL2] = convtlayer(resL1,1);

p_m=zeros(3,size(resL2,1));
%Máximo de cada canal
for t=1:size(resL2,1)
p_m(1,t)=max(max(resL2(t,:,:)));
[p_m(2,t) p_m(3,t)] =find(squeeze(resL2(t,:,:))==p_m(1,t));
end

%% Visualização

res=tensorViewerf(resL2);
tensor=squeeze(resL1(7,:,:));
IMF=imfuse(AM,A);
IMFt=imfuse(AM,res);


figure
colormap('gray')
image(tensor,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')
plot(p_m(3,:),p_m(2,:),'.')

figure
colormap('gray')
image(IMF,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')
plot(p_m(3,:),p_m(2,:),'.')

figure
image(IMFt,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')
plot(p_m(3,:),p_m(2,:),'.')