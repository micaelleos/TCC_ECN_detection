%% Implementa��o 14
% parent = Imp 13 
% para observar normaliza��o da soma do tensor de sa�da de acordo com a
% quantidade de kernels. 

clear;clc;close all;
%% Extra��o dos kernels 
%tic
lista = {'6355','5961.1','9794.1','9793.2'}
lim=0.05:0.05:1; % vetor de varia��o de limiar de classifica��o
vJ=zeros(length(lim),1); % p/ fun��o de custo
var = [];
res=[];

for ind =1:4  % processamento de todas as imagens do banco
vart=1:length(lista); % para exclus�o da imagem que est� sendo processada das janelas de refer�ncia
dados = extrakernels(lista(ind),20); % extrai automaticamente os kernels de acordo com suas respectivas m�scaras.

%% Data augmentation
delete('./dataaug/*') % limpa a pasta
augmentation( dados ) % faz data augmentation dos kernesl recortados em "extrakernels" e salva na pasta ./dataaug
clear dados; % limpa vari�vel porque � muito grande

%% Abertura das imagens
tic
%Abertura das imagens
nomex=char(lista(ind)) 
dirI=strcat('./Testes/Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Testes/Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Banco de Filtros 

%layer 1
[maximos,resL1,Soma] = bancofiltcgpu(A,0,20);

%Guardar resultado
res(ind).maximo = maximos(3,:);
res(ind).x = maximos(1,:);
res(ind).y = maximos(2,:);
res(ind).exame = lista(ind);

% Redimensionamento de vari�vel para retirar padding de convolu��o do
% filtro
var(ind).soma = Soma(10:end-10,10:end-10); 
var(ind).AMR = AM(10:end-10,10:end-10);

end



tamanho = zeros(4,1);
maximos1 = zeros(4,1);
for k =1 : 4
   tamanho(k) = length(res(k).x); 
   maximos1(k) = max(max(var(k).soma));
end
figure
plot( maximos1, tamanho, '.')

figure
colormap('gray')
image(J,'CDataMapping','scaled')

figure
subplot(2,2,1)
histogram(res(1).maximo,20,'Normalization','probability')
subplot(2,2,2)
histogram(res(2).maximo,20,'Normalization','probability')
subplot(2,2,3)
histogram(res(3).maximo,20,'Normalization','probability')
subplot(2,2,4)
histogram(res(4).maximo,20,'Normalization','probability')

maximos2 = zeros(4,1);
im_norm = [];
% imagens normalizadas pela quantidade de kernels 
for k =1 : 4 
    im_norm(k).img =(var(k).soma + abs(min(min(var(k).soma))))./length(res(k).x)
    maximos2(k) = max(max(im_norm(k).img));
    figure
    colormap('gray')
    image(uint8(255*im_norm(k).img))
end

figure
plot( maximos2, tamanho, '.','MarkerSize',20)
xlabel('m�ximos normalizados') 
ylabel('Quantidade de Kernels') 
