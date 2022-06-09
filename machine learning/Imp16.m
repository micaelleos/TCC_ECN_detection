clear; clc; close all;

%% Abrindo diretório dos kernels para implementaçao de rede neural com o toolbox do matlab

%COM
arquivos = dir('../base de dados/train/com'); %diretório das bases
quantIm = length(arquivos)-3;

x=[];
for i = 1 : quantIm
b=double(imread(strcat('../base de dados/train/com/',arquivos(i+2).name)));
x=[x b(:)];
end

y2 = ones(1, length(x));

%SEM
arquivos = dir('../base de dados/train/sem'); %diretório das bases
quantIm = length(arquivos)-3;


for i = 1 : quantIm
b=double(imread(strcat('../base de dados/train/sem/',arquivos(i+2).name)));
x=[x b(:)];
end

y2 = [y2 zeros(1,quantIm)];

%one-hot encoder
y = [y2; not(y2)];

ind = randi(length(x),length(x),1);

x=x(:,ind);
y=y(:,ind);

y2=y2(:,ind);

%% Dados de teste

x_test =[];

arquivos = dir('../base de dados/test/com'); %diretório das bases
quantIm = length(arquivos)-3;

for i = 1 : quantIm
b=double(imread(strcat('../base de dados/test/com/',arquivos(i+2).name)));
x_test=[x_test b(:)];
end

y_test2 = ones(1, length(x_test));

arquivos = dir('../base de dados/test/sem'); %diretório das bases
quantIm = length(arquivos)-3;

for i = 1 : quantIm
b=double(imread(strcat('../base de dados/test/sem/',arquivos(i+2).name)));
x_test=[x_test b(:)];
end

y_test2 = [y_test2 zeros(1,quantIm)];

y_test = [y_test2; not(y_test2)];



%% Neural Network

%[x,t] = iris_dataset;
net = patternnet([5 15 10]);
net = train(net,x,y2);
%view(net)
t = net(x_test);
perf = perform(net,t,y_test2);

irisOutputs = sim(net,x_test);
[tpr,fpr,thresholds] = roc(y_test2,irisOutputs);
AUC=trapz(fpr,tpr) 
figure
plotroc(y_test2,irisOutputs)
figure
plotconfusion(y_test2,irisOutputs)

%% Matriz de confusão
