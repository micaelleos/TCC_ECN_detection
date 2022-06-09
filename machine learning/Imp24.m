clc;clear;close;
%% Inicialização

load('data_A.mat');
load('data_B.mat');

y=[ones(1,size(A_com,2)) zeros(1,size(A_sem,2))];
x=[A_com A_sem];

%enbaralhamento dos dados de treinamento
ind = randi(length(y),length(y),1);
y=y(ind);
x=x(:,ind);

netdim = [size(x,1) 5 15 10 1];
[variaveis] = inicializaRNA(netdim);

err=10;
i=0;
tic
custo=[];

A= x;
%% Treinamento da Rede Neural

while(err>2)
   
[ AL, variaveis2 ] = propFeedforward(A,variaveis);
[ gradientes ] = propBackward(y,variaveis,variaveis2);   
    
end