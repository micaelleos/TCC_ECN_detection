%% Implementação 9
% Funções com cálculo de computação paralela.
% Estrutura de banco de filtros agora organizado para os tensores

clear;clc;close all;
%% Extração dos kernels 
%tic

lista = {'6355','9793.2'};
dados = extrakernels(lista,20);

tre = dados; %kernels para treinamento
%% Data augmentation
delete('./kernels/*')
augmentation( tre );

%% Processamento
res=[];

for i = 1 : 1% length(lista)
%% Abertura das imagens
%tic
nomex='5961.1'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Banco de Filtros 
limiar=0.5;
%layer 1
[maximos,resL1,soma] = bancofiltcgpu(A,limiar,20);

%Guardar resultado
res(i).x = maximos(1,:);
res(i).y = maximos(2,:);
res(i).exame = lista(i);
res(i).mascara=AM;
end
%% 
[ B2 ] = diffrel( soma, 3 );
h = fspecial('log',[3 3])
img_filted = imfilter(soma,h);

%% Visualização
%res=tensorViewerf(resL1(1:500,:,:));

figure
colormap('gray')
image(B2,'CDataMapping','scaled')
colorbar
title('Im Máximos');
hold on
plot(maximos(2,3),maximos(1,3),'.')
IMF=imfuse(AM,A);
figure
colormap('gray')
image(IMF,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')
%% Pós-processamento

pos=soma;
pos(pos>0)=0;
pos = -1*pos;
poseq = histeq(pos);
posand = and(pos,poseq);

Bpos=255*ones(size(B2));
Bpos(B2>20)=0;
Bpos = -1*Bpos +255;
Bpos=Bpos + 255;
Bposeq = histeq(Bpos);
Bpos2= not(Bpos);
Bposand = pos.*Bpos2;


figure
colormap('gray')
image(Bposand,'CDataMapping','scaled')
colorbar
figure
colormap('gray')
image(soma_s,'CDataMapping','scaled')
colorbar

%% Validação

[ esp , sen, acc, pre ] = avalpross('1',maximos(1:2,:)',AM)


%% Salvando as imagens
B2_s = 255*(B2 - min(min(B2)))/(max(max(B2)) - min(min(B2)));
pos_s = 255*(pos - min(min(pos)))/(max(max(pos)) - min(min(pos)));
Bpos_s = 255*(Bpos - min(min(Bpos)))/(max(max(Bpos)) - min(min(Bpos)));
img_filted_s = 255*(img_filted - min(min(img_filted)))/(max(max(img_filted)) - min(min(B2)));
poseq_s = 255*(poseq - min(min(poseq)))/(max(max(poseq)) - min(min(poseq)));
Bposeq_s =255*(Bposeq - min(min(Bposeq)))/(max(max(Bposeq)) - min(min(Bposeq)));
soma_s=255*(soma - min(min(soma)))/(max(max(soma)) - min(min(soma)));

imwrite(uint8(B2_s),'B2_s.png')
imwrite(uint8(pos_s),'pos_s.png')
imwrite(uint8(Bpos_s),'Bpos_s.png')
imwrite(uint8(img_filted_s),'img_filted_s.png')
imwrite(uint8(poseq_s),'poseq_s.png')
imwrite(uint8(Bposeq_s),'Bposeq_s.png')
imwrite(uint8(soma_s),'soma_s.jpg')

