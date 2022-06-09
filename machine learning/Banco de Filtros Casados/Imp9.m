%% Implementa��o 9
% Fun��es com c�lculo de computa��o paralela.
% Estrutura de banco de filtros agora organizado para os tensores

clear;clc;close all;
%% Extra��o dos kernels 
%tic

lista = {'6355','9793.2'};
dados = extrakernels(lista,20);

i_val = randi(length(dados),1,ceil(0.3*length(dados)));
i_tre = setdiff(1:length(dados),i_val);

tre = dados; %kernels para treinamento
%val = dados(i_val(:)); %kernels de valida��o

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
[maximos,resL1] = bancofiltcgpu(A,limiar,20);

%Guardar resultado
res(i).x = maximos(1,:);
res(i).y = maximos(2,:);
res(i).exame = lista(i);
res(i).mascara=AM;
end

%% Visualiza��o
figure
colormap('gray')
image(A,'CDataMapping','scaled')
title('Im M�ximos');
hold on
plot(maximos(2,:),maximos(1,:),'.')

IMF=imfuse(AM,A);


x = [val(find(strcmpi({val(:).exame},nomex))).x];
y = [val(find(strcmpi({val(:).exame},nomex))).y];


figure
colormap('gray')
image(res,'CDataMapping','scaled')
title('Im M�ximos');
hold on
plot(maximos(2,:),maximos(1,:),'.')
plot(y(:),x(:),'dr')


res=tensorViewerf(resL1(40:80,:,:));
%% Valida��o

[ esp , sen, acc, pre ] = avalpross( res, val);


