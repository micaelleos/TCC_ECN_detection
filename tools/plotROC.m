clear;clc;close all;
%% Plot dos ROCs em connjunto

load('roc_cm.mat');
load('roc_lda.mat');
load('roc_rna.mat');


%% AUC
[tpr,fpr,thresholds] = roc(train_rna,predic_rna);
AUC=trapz(fpr,tpr)

%% Normalização
predic_lda = predic_lda - min(min(predic_lda));
predic_lda = predic_lda/max(max(predic_lda));

predic_cm = predic_cm - min(min(predic_cm));
predic_cm = predic_cm/max(max(predic_cm));

predic_rna = predic_rna - min(min(predic_rna));
predic_rna = predic_rna/max(max(predic_rna));

%% ROC
% figure
% plotroc(train_lda,predic_lda,'Discriminante de Fisher',train_rna,predic_rna,'Redes Neurais Artificiais',train_cm,predic_cm,'Casamento de Modelos')

train=train_cm;
predic=predic_cm;

x=0:0.01:1;

v_TP=zeros(1,length(x));
v_FP=zeros(1,length(x));
v_TN=zeros(1,length(x));
v_FN=zeros(1,length(x));

v_esp=zeros(1,length(x));
v_sen=zeros(1,length(x));
v_acc=zeros(1,length(x));
v_prec=zeros(1,length(x));

class_C = predic(find(train==1));
class_S = predic(find(train==0));

for k = 1 : length(x)
   
    lim = x(k);
    
    v_TP(k)=sum(class_C>lim); 
    v_FP(k)=sum(class_S>lim);
    v_TN(k)=sum(class_S<lim);
    v_FN(k)=sum(class_C<lim);
    
    v_esp(k)=v_TN(k)/(v_TN(k)+v_FP(k));
    v_sen(k)=v_TP(k)/(v_TP(k)+v_FN(k));
    v_acc(k)=(v_TP(k)+v_TN(k))/(v_TP(k)+v_TN(k)+v_FP(k)+v_FN(k));
    v_prec(k)=v_TP(k)/(v_TP(k)+v_FP(k));
    
end

roc = ones(size(v_esp)) - v_esp;

figure
plot(roc,v_sen)
title('ROC')
xlabel('1 - Especificidade')
ylabel('Sensibilidade')
hold on
plot([0:0.1:1],[0:0.1:1],'r');

figure
plot(x,v_esp);
hold on
plot(x,v_sen);
plot(x,v_acc);
plot(x,v_prec);
plot(x(find(v_acc==max(v_acc))),max(v_acc),'r.','MarkerSize',20)
title(strcat('Melhor Limiar :',num2str(x(find(v_acc==max(v_acc))))))
legend('Especificidade','Sensibilidade','Acurácia','Precisão')

figure
plotconfusion(train,predic);

v_esp(find(v_acc==max(v_acc)))
v_sen(find(v_acc==max(v_acc)))
v_acc(find(v_acc==max(v_acc)))
v_prec(find(v_acc==max(v_acc)))

