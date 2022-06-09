%% Implementação 12
% Funções com cálculo de computação paralela.
% Estrutura de banco de filtros agora organizado para os tensores

clear;clc;close all;
%% Extração dos kernels 
%tic

lista = {'6355','5961.1'}%{'6355','9793.2','9794.1'};%
delete('./kernels/*')
extrakernels(lista,20);

%% Data augmentation
delete('./dataaug/*')
augmentation;

%% Processamento
res=[];

for i = 1 : 1% length(lista)
%% Abertura das imagens
%tic
nomex='9793.2'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A1,AM1] = abririm(dirI,dirM);
[A, rect] = imcrop(uint8(A1));
A=double(A);
AM=AM1(floor(rect(2))+1:floor(rect(2))+floor(rect(4)),floor(rect(1))+1:floor(rect(1)) + floor(rect(3)));
%% Banco de Filtros 
limiar=0.5;
%layer 1
[maximos,resL1,Soma] = bancofiltcgpu(A,limiar,20);

%Guardar resultado
res(i).x = maximos(1,:);
res(i).y = maximos(2,:);
res(i).exame = lista(i);
res(i).mascara=AM;
end

soma = imresize(Soma,[(size(Soma,1) - 30) (size(Soma,2)- 30)] );

AMR=AM(20:end-10,20:end-10);
%% Classificador
limiar_r = (max(max(soma))-min(min(soma))) * 0.4 + min(min(soma));
pos=soma;
pos(pos>limiar_r)=0;
pos = -1*pos;
poseq = histeq(pos);
poseq = 255*(poseq - min(min(poseq)))/(max(max(poseq))- min(min(poseq)));
possoma = -soma .* poseq;
%% Análise dos valores máximos

max_selecionados=maximos(:,find(maximos(3,:)>0.9));
max_selecionados = [max_selecionados(1,:)-20; max_selecionados(2,:)-20; max_selecionados(3,:)];
%% Visualização
figure
colormap('gray')
image(poseq,'CDataMapping','scaled')
colorbar
title('Resultado');


IMF=imfuse(AM,A);
figure
colormap('gray')
image(IMF,'CDataMapping','scaled')
title('Máscara');
colorbar
hold on
plot(max_selecionados(2,:),max_selecionados(1,:),'.')

%% Validação

[ esp , sen, acc, pre, FP, TP, FN, TN ] = avalpross('2',poseq,AMR)

%[ esp , sen, acc, pre, FP, FN, TP, TN] = avalpross('3',max_selecionados(1:2,:),AMR)

disp('maximo:')
max(max(maximos(3,:)))