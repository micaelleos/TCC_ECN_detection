clear;clc;close all;
%% Extração dos kernels para formação de bases para treinamento e teste

lista = {'9793.2','5961.1','6355','9794.1'} 
dir= './base_cross_validation/';


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


for base = 1 : 5
    x=floor(0.20*length(dadoscom));
test_sem = dadossem_eq((base-1)*x+1:base*x);
test_com = dadoscom((base-1)*x+1:base*x);

train_sem = dadossem_eq(:);
train_com = dadoscom(:);

train_sem((base-1)*x+1:base*x) = [];
train_com((base-1)*x+1:base*x) = [];
%% Data augmentation
n=1;
set={'test/com','test/sem','train/com','train/sem'};
for s = 1: 4
    if s == 1
        var = test_com;
    elseif s == 2
        var = test_sem;
    elseif s == 3
        var = train_com;
    elseif s == 4
        var = train_sem;
    end
    
    
    dir3 = strcat(dir,int2str(base),'/',set(s),'/');
    
    dir2=dir3{1};
    mkdir(dir2);
for l = 1: length(var)
    b=var(l).img;

    imwrite(uint8(b),strcat(dir2,int2str(l),'.tif'));
    rse(b,n,dir2)
    
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat(dir2,int2str(l),'_','esp_.tif'));
    
    n=n+1;
    rse(b_esp,n,dir2)
    
    %% Rotação
    for j = 1:3
    b=rot90(b);
    imwrite(uint8(b),strcat(dir2,int2str(l),'_','rot_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b,n,dir2)
  
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat(dir2,int2str(l),'_','esp_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b_esp,n,dir2)
    end

end
end
end