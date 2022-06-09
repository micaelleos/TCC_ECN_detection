clear; clc; close all;
% Comparação da minha função de correlação cruzada normalizada com a pronta
% do matlab que roda na gpu. A da gpu foi 20x mais rápida.

%Preciso comparar resultados numericamente ainda, fiz um teste no olho
%apenas.

nomedir='4'; 
arquivos = dir(strcat('./',nomedir));
b=double(imread(strcat(nomedir,'/',arquivos(3).name)));

nomex='5961.1'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');    %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Testando função filtrocasado
tic
Agpu=gpuArray(A);
bgpu=gpuArray(b);

Jgpu=normxcorr2(bgpu,Agpu);
Jgather=gather(Jgpu);
toc

tic
J = filtrocasado( A, b );
toc

norm(norm(Jgather))
norm(norm(J))

mean(mean(Jgather))
mean(mean(J))

max(max(Jgather))
max(max(J))

min(min(Jgather))
min(min(J))

figure
image(J,'CDataMapping','scaled');

figure
image(Jgather,'CDataMapping','scaled');

%% Testando função bancofiltcgpu
limiar=0.7;

tic
[ resultado1 ] = cbancfiltpmax(A,limiar);
toc

tic
[ resultado2 ] = bancofiltcgpu(A,limiar );
toc

figure
image(squeeze(resultado1(1,:,:)),'CDataMapping','scaled');

figure
image(squeeze(resultado2(1,:,:)),'CDataMapping','scaled');