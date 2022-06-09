clear; clc; close all;

%% RNA

load('data_A.mat')
load('data_B.mat')

x = [A_com A_sem];
y = [ones(1,length(A_com)) zeros(1,length(A_sem))];

ind = randi(length(x),length(x),1);

x=x(:,ind);
y=y(:,ind);

x_test = [B_com B_sem];
y_test = [ones(1,length(B_com)) zeros(1,length(B_com))];

ind2 = randi(length(x_test),length(x_test),1);

x_test = x_test(:,ind2);
y_test = y_test(:,ind2);

%% Neural Network

net = patternnet([5 1]);
net = train(net,x,y);
%view(net)
t = net(x_test);
perf = perform(net,t,y_test)

teste = sim(net,x_test);
[tpr,fpr,thresholds] = roc(y_test,teste);
AUC=trapz(fpr,tpr) 

%ROC
figure
plotroc(y_test,teste)

%Matriz de confusão
figure
plotconfusion(y_test,teste)