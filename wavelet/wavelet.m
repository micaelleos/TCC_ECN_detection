clear;clc;close all;
%lista = {'5961.1','6355','9793.2'};
nomex='5961.1'; 
%Abertura das imagens
dirI=strcat('../Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

k=20;

for i = 1 : size(A,1) - k
   for j = 1 : size(A,2) - k
   janela = A(i:i+k,j:j+k);
   
   end
end

