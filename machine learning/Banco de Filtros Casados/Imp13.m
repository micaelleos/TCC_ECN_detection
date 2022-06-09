 v%% Implementação 13
% Encontrando melhor limiar da mascara do classificador pela função de custo

clear;clc;close all;
%% Extração dos kernels 
%tic
lista = {'6355','5961.1','9794.1','9793.2'}
lim=-0.4:0.05:1; % vetor de variação de limiar de classificação
vJ=zeros(length(lim),1); % p/ função de custo
res=[];
for ind =1:1%4  % processamento de todas as imagens do banco
vart=1:length(lista); % para exclusão da imagem que está sendo processada das janelas de referência
dados = extrakernels(lista(vart(vart~=ind)),20); % extrai automaticamente os kernels de acordo com suas respectivas máscaras.

%% Data augmentation
delete('./dataaug/*') % limpa a pasta
augmentation( dados ) % faz data augmentation dos kernesl recortados em "extrakernels" e salva na pasta ./dataaug
clear dados; % limpa variável porque é muito grande

%% Processamento

% Abertura das imagens
tic
nomex=char(lista(ind)); 
dirI=strcat('./Testes/Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Testes/Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

% recorta região de interesse de processamento 
% [A1,AM1] = abririm(dirI,dirM);
% [A, rect] = imcrop(uint8(A1)); 
% A=double(A);
% AM=AM1(floor(rect(2)):floor(rect(2))+floor(rect(4)),floor(rect(1)):floor(rect(1)) + floor(rect(3)));
%% Banco de Filtros 

%layer 1
[maximos,soma] = bancofiltcgpu(A,0,'dataaug');

%Guardar resultado
res(ind).x = maximos(1,:);
res(ind).y = maximos(2,:);
res(ind).exame = lista(ind);
res(ind).soma=soma;
res(ind).mascara=AM;
res(ind).img = A
%% Classificador/Descritor
J=zeros(length(lim),1);
for t =1:length(lim)
limiar_r = lim(t);
%limiar_r = (max(max(soma))-min(min(soma))) * 0.6 + min(min(soma));

pos=soma;
pos(pos<limiar_r)=0;
%pos = -1*pos;
poseq = histeq(pos);
poseq = 255*(poseq - min(min(poseq)))/(max(max(poseq))- min(min(poseq)));
res(ind).posmasc = poseq;
possoma = -soma .* poseq;
%% Hipotese Nula
clear Jc Js;
[ Jc,Js ] = extraJanelas(A,AM);
C_Js = ones(size(Js));
C_Jc = zeros(size(Jc));

masS =ones(size(A));
masC =zeros(size(A));
for j = 1 : length(Jc) -1
    x=Jc(j).x;
    y=Jc(j).y;
    if((x+20 > size(poseq,1))==0 && (y+20 > size(poseq,2))==0)
        if(any(any(poseq(x:x+20,y:y+20)))==1)
            C_Jc(j) = 1;
            masC(x:x+20,y:y+20)=1;
        end
    end    
end

for k = 1 : length(Js) -1 
    x=Js(k).x;
    y=Js(k).y;
    if((x+20 > size(poseq,1))==0 && (y+20 > size(poseq,2))==0)
        if(any(any(poseq(x:x+20,y:y+20)))==1)
            C_Js(k) = 0;
            masS(x:x+20,y:y+20)=0;
        end      
    end
end

%amostras ecolhidas aleatoriamente e equilibradas
C_Js_eq = C_Js(randi(length(C_Jc),[length(C_Jc) 1]));

amost_Js=sum(C_Js_eq)/length(C_Js_eq);
amost_Jc=sum(C_Jc)/length(C_Jc);

%% Validação

res(ind).FP=sum(C_Jc==0);
res(ind).TP=sum(C_Jc==1);
res(ind).FN=sum(C_Js_eq==0);
res(ind).TN=sum(C_Js_eq==1);

J(t)=res(ind).FP/(res(ind).FP+res(ind).TP)+res(ind).FN/(res(ind).FN+res(ind).TN);
end
res(ind).J=J;
vJ=vJ+J;
end
figure
plot(lim,vJ)
title('Custo')

for l = 1 : 4
   figure
   plot(lim,res(l).J')
   title(res(l).exame)
end

 IMF=imfuse(masS,masC);
 figure
 colormap('gray')
 image(IMF,'CDataMapping','scaled')