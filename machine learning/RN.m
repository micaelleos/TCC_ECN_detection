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

X=[x;ones(1,size(x,2))]./max(max(x));

%Parâmetros
neu=5;%neurônios camada 1
neu2=1;%neurônios camada 2

dt=1*10^(-5); %passo

%inicialização matrizes de pesos
W2=rand(neu2,neu+1);
W1=rand(neu,size(x,1)+1)*0,1;
%load('rna2layer5and1n.mat');

err=10;
i=0;
beta=0.99;
Vdw1=0;
Vdw2=0;
tic
custo=[];
%% 
acc=0;
while(0)%err>2.5)
i=i+1;

y_=modelo(W2,W1,X); 

[dW1,dW2]=gradiente(W2,W1,X,y);%//gradiente negativo 

Vdw1= beta*Vdw1 + (1-beta)*dW1;
Vdw2= beta*Vdw2 + (1-beta)*dW2;

W1=W1 - dt.*Vdw1;
W2=W2 - dt.*Vdw2;

erro=(y-y_).^2;
custo(i)=1/sum(sum(erro));

err=abs(log(custo(i)));

vp= sum(y_(find(y == 1)) > 0.5);
vn= sum(y_(find(y == 0)) < 0.5);
fp=sum(y_(find(y == 1)) < 0.5);
fn=sum(y_(find(y == 0)) > 0.5);

acc= (vp+vn) / (vp+vn+fp+fn);
pre=vp/(vp+fp);
sen=vp/(vp+fn);
esp=vn/(vn+fp);

clf
subplot(2,1,1)
plot(y_(find(y == 0)),'b*');
title(strcat('ACC:',num2str(acc),' PREC:',num2str(pre),' Sen:',num2str(sen),' Esp:',num2str(esp)));
hold on
plot(y_(find(y == 1)),'r*');
subplot(2,1,2)
plot(log(custo),'g*')
%plot(log(custo(end)),'g*')
drawnow();
end
t=toc

%% Teste

load('rna2layer5and1n.mat');

y_teste=[ones(1,size(B_com,2)) zeros(1,size(B_sem,2))];
x_teste=[B_com B_sem];

X_teste=[x_teste;ones(1,size(x_teste,2))]./max(max(x_teste));

y_teste_=modelo(W2,W1,X_teste); 

vp= sum(y_teste_(find(y_teste == 1)) > 0.5);
vn= sum(y_teste_(find(y_teste == 0)) < 0.5);
fp=sum(y_teste_(find(y_teste == 1)) < 0.5);
fn=sum(y_teste_(find(y_teste == 0)) > 0.5);

acc= (vp+vn) / (vp+vn+fp+fn);
pre=vp/(vp+fp);
sen=vp/(vp+fn);
esp=vn/(vn+fp);
%% Plot da distribuição

x=0:0.01:1;

v_esp=zeros(1,length(x));
v_sen=zeros(1,length(x));
v_acc=zeros(1,length(x));
v_prec=zeros(1,length(x));


for k = 1 : length(x)
   
    lim = x(k);
    
    vp= sum(y_teste_(find(y_teste == 1)) > lim);
    vn= sum(y_teste_(find(y_teste == 0)) < lim);
    fp=sum(y_teste_(find(y_teste == 1)) < lim);
    fn=sum(y_teste_(find(y_teste == 0)) > lim);

    acc= (vp+vn) / (vp+vn+fp+fn);
    pre=vp/(vp+fp);
    sen=vp/(vp+fn);
    esp=vn/(vn+fp);
    
   
    v_esp(k)=esp;
    v_sen(k)=sen;
    v_acc(k)=acc;
    v_prec(k)=pre;
    
end

    v_esp(find(v_esp == nan))=0;
    v_sen(find(v_sen == nan))=0;
    v_acc(k)=acc;
    v_prec(k)=pre;

figure
plot(x,v_esp);
hold on
plot(x,v_sen);
plot(x,v_acc);
plot(x,v_prec);
plot(x(find(v_acc==max(v_acc))),max(v_acc),'r.','MarkerSize',20)
title(strcat('Melhor Limiar :',num2str(x(find(v_acc==max(v_acc))))))
legend('Especificidade','Sensibilidade','Acurácia','Precisão')




%% Matriz de confusão e Curva ROC

predic_rna = y_teste_;
train_rna = y_teste;
figure
plotconfusion(train,predic);

%% ROC
[tpr,fpr,thresholds] = roc(train,predic);
AUC=trapz(fpr,tpr)
figure
plotroc(train,predic)