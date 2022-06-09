%% Implementação 8
% Funções com cálculo de computação paralela.
% Estrutura de banco de filtros agora organizado para os tensores

% Laplacian of gaussian first, with pirimid
% matched filters bank
% matched tensor bank
% avarege pool layer

clear;clc;close all;
%% Abertura das imagens
%tic
nomex='5961.1'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Recorte de kernels
coor=recorteKernels(A,AM,20);

%% Banco de Filtros 
limiar=0.90;
%layer 1
[ resL1, maximos ] = bancofiltcgpu(A,limiar);

%% Contrução do kernel 2 camada

[tL1_t] = extratensor(resL1,coor',20)
salvaresultado('0',tL1_t);

%% Camada 2
[resL2] = convtlayer(resL1,1);

%% Visualização



res=tensorViewerf(resL2);
B=squeeze(resL1(15,:,:));

nova=res;

for k=1:length(maximos)
    i=maximos(1,k);
    j=maximos(2,k);
    t=5;
   if((i+t)<size(nova,1) && (j+t)<size(nova,2) && (i-t)>1 && (j-t)>1)
   nova(i-t:i+t,j-t:j+t)=nova(i-t:i+t,j-t:j+t).*(1-maximos(3,k)+1); 
   end
end

%IMFsoma2=imfuse(teste3,AM);
IMFsoma=imfuse(AM,res);

figure
colormap('gray')
image(B,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')
figure
%colormap('gray')
image(IMFsoma,'CDataMapping','scaled')
title('Im Máximos');
colorbar
hold on
plot(maximos(2,:),maximos(1,:),'.')

%============aqui ele está remitiplicando os pontos onde estão próximo



%===========parecido mas com calculo de densidade para n acontecer
%remitiplicação

teste3=zeros(size(A));
for i=1:size(A,1)-1
    for j=1:size(A,2)-1
    teste3(i,j)= B(i,j)-B(i+1,j+1);
    end
end


figure
colormap('gray')
image(teste3,'CDataMapping','scaled')
title('Im Máximos');
