clear;clc;close all;
%% Extração dos kernels para formação de bases para treinamento e teste

lista = {'9793.2','5961.1','6355','9794.1'} 
Jc = [];
Js =[];
dadoscom = [];
dadossem = [];
teste =[];
% abre as imagens e extrai as janelas
for i = 1:4
clear Js Jc
nomex=char(lista(i))
dirI=strcat('./Testes/Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Testes/Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);  

A1=imresize(A,[520,ceil(size(A,2)*520/size(A,1))]);
AM1=imresize(AM,[520,ceil(size(A,2)*520/size(A,1))]);

A1 = uint8(255*A1/max(max(A1)));
AM1 = uint8(255*AM1/max(max(AM1)));

%imwrite(A1,strcat(nomex,'.jpg'));
%imwrite(AM1,strcat(nomex,'m.jpg'));
 [ Jc,Js ] = extraJanelas(A1,AM1);
 dadoscom = [dadoscom Jc];
 dadossem = [dadossem Js];
end

%% reorganização aleatória das imagens
dadoscom = dadoscom(randi(length(dadoscom),length(dadoscom),1));
dadossem = dadossem(randi(length(dadossem),length(dadossem),1));
dadossem_eq = dadossem(1:length(dadoscom));

pct = 0.7 % 70% das imagens
train_sem = dadossem_eq(1:round(pct * length(dadossem_eq)));
train_com = dadoscom(1:round(pct*length(dadoscom)));
train_sem = train_sem(randi(length(train_sem),length(train_sem),1));
train_com = train_com(randi(length(train_com),length(train_com),1));

test_sem = dadossem_eq(round(pct * length(dadossem_eq))+1:end);
test_com = dadoscom(round(pct*length(dadoscom))+1:end);
test_sem = test_sem(randi(length(test_sem),length(test_sem),1));
test_com = test_com(randi(length(test_com),length(test_com),1));


%% Data augmentation
delete('./dataaug/*')

var = train_com;
n=1;
for l = 1: length(var)
    b=var(l).img;

    imwrite(uint8(b),strcat('./dataaug/',int2str(l),'.tif'));
    rse(b,n)
    
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat('./dataaug/',int2str(l),'_','esp_.tif'));
    
    n=n+1;
    rse(b_esp,n)
    
    %% Rotação
    for j = 1:3
    b=rot90(b);
    imwrite(uint8(b),strcat('./dataaug/',int2str(l),'_','rot_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b,n)
  
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat('./dataaug/',int2str(l),'_','esp_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b_esp,n)
    end

end