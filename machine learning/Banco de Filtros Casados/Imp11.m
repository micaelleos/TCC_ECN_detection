%% Implementa??o 11
% Fun??es com c?lculo de computa??o paralela.
% Estrutura de banco de filtros agora organizado para os tensores

clear;clc;close all;
%% Extra??o dos kernels 
%tic

lista = {'9794.1','9793.2','6355'}%{'6355','9793.2','9794.1'};%
dados = extrakernels(lista,20);

tre = dados; %kernels para treinamento
%% Data augmentation
delete('./dataaug/*')
augmentation( tre )
clear tre dados;
%% Processamento
res=[];

for j = 1 : 1% length(lista)
%% Abertura das imagens
%tic
nomex='5961.1'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A1,AM1] = abririm(dirI,dirM);
[A, rect] = imcrop(uint8(A1));
A=double(A);
AM=AM1(floor(rect(2))+1:floor(rect(2))+floor(rect(4)),floor(rect(1))+1:floor(rect(1)) + floor(rect(3)));
%% Banco de Filtros 
limiar=0;
%layer 1
[maximos,resL1,Soma] = bancofiltcgpu(A,limiar,20);

%Guardar resultado
res(j).x = maximos(1,:);
res(j).y = maximos(2,:);
res(j).exame = lista(j);
res(j).mascara=AM;
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
%% An?lise dos valores m?ximos

max_selecionados=maximos(:,find(maximos(3,:)>0.9));
max_selecionados = [max_selecionados(1,:)-20; max_selecionados(2,:)-20; max_selecionados(3,:)];
%% Visualiza??o
figure
colormap('gray')
image(poseq,'CDataMapping','scaled')
colorbar
title('Resultado');


IMF=imfuse(AMR,soma);
figure
colormap('gray')
image(IMF,'CDataMapping','scaled')
title('M?scara');
colorbar
hold on
plot(max_selecionados(2,:),max_selecionados(1,:),'.')

%% Hipotese Nula
clear Jc Js;
[ Jc,Js ] = extraJanelas(A,AM);

C_Js = zeros(size(Js));
C_Jc = zeros(size(Jc));

for j = 1 : length(Jc) -1
   
    x=Jc(j).x;
    y=Jc(j).y;
    if((x+20 > size(poseq,1))==0 && (y+20 > size(poseq,2))==0)
        if(any(any(poseq(x:x+20,y:y+20)))==1)
            C_Js(j) = 1;
        end
    end
    
end

for k = 1 : length(Js) -1 
    x=Js(k).x;
    y=Js(k).y;
    if((x+20 > size(poseq,1))==0 && (y+20 > size(poseq,2))==0)
        if(any(any(poseq(x:x+20,y:y+20)))==1)
            C_Jc(k) = 1;
        end      
    end
end

%amostras ecolhidas aleatoriamente e equilibradas
C_Js_eq = C_Js(randi(length(C_Jc),[length(C_Jc) 1]));

amost_Js=sum(C_Js_eq)/length(C_Js_eq);
amost_Jc=sum(C_Jc)/length(C_Jc);

%% Valida??o

FP=sum(C_Jc==0)
TP=sum(C_Jc==1)
FN=sum(C_Js_eq==1)
TN=sum(C_Js_eq==0)

%[ esp , sen, acc, pre, FP, TP, FN, TN ] = avalpross('2',poseq,AMR)

%[ esp , sen, acc, pre, FP, FN, TP, TN] = avalpross('3',max_selecionados(1:2,:),AMR)

disp('maximo:')
max(max(maximos(3,:)))