function [ variaveis ] = inicializaRNA( netdim )
%Inicialização dos pessos e bias de acordo com as
%dimensões em netdim = [n1 n2 ...]
%   n1 = número de neurônios na camada 1 ...
variaveis = [];
for i=1:length(netdim)-1
   variaveis(i).W= rand(netdim(i+1),netdim(i)); 
   variaveis(i).b= rand(netdim(i+1),1);
end
end

