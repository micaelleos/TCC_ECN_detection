clear;clc;close all;
%% Classificador de Jugurta

arquivos_c = dir('../base de dados/train/com'); %diretório das bases
arquivos_s = dir('../base de dados/train/sem');
quantIm = length(arquivos_c)-3;

A_com=[];
A_sem=[];

for j = 1 : quantIm
    b=double(imread(strcat('../base de dados/train/com/',arquivos_c(j+2).name)));
    b=b(:);
    b=b-mean(b);
    b=b/norm(b);
    
    A_com=[A_com,b];
    
    b2=double(imread(strcat('../base de dados/train/sem/',arquivos_s(j+2).name)));
    b2=b2(:);
    b2=b2-mean(b2);
    b2=b2/norm(b2);
    
    A_sem=[A_sem,b2];
end

%% dados de teste

arquivos_c = dir('../base de dados/test/com'); %diretório das bases
arquivos_s = dir('../base de dados/test/sem');
quantIm = length(arquivos_c)-3;


B_com=[];
B_sem=[];

for j = 1 : quantIm
    j
    b=double(imread(strcat('../base de dados/test/com/',arquivos_c(j+2).name)));
    b=b(:);
    b=b-mean(b);
    b=b/norm(b);
    
    B_com=[B_com,b];
    
    b2=double(imread(strcat('../base de dados/test/sem/',arquivos_s(j+2).name)));
    b2=b2(:);
    b2=b2-mean(b2);
    b2=b2/norm(b2);
    
    B_sem=[B_sem,b2];
    
end


%% Cálculo
% A é treino, B é teste

g=gpuDevice(1);

Agpu_c=gpuArray(A_com);
Bgpu_c=gpuArray(B_com);
Bgpu_s=gpuArray(B_sem);

resA_c_c = Bgpu_c'*Agpu_c;
resA_c_s = Bgpu_s'*Agpu_c;

res_A_C_C=gather(resA_c_c);
macc=max(res_A_C_C');

res_A_C_S=gather(resA_c_s);
macs=max(res_A_C_S');

clear Agpu_c resA_c_s resA_c_c
Agpu_s=gpuArray(A_sem);

resA_s_c = Bgpu_c'*Agpu_s;
resA_s_s = Bgpu_s'*Agpu_s;

res_A_S_C=gather(resA_s_c);
masc=max(res_A_S_C');

res_A_S_S=gather(resA_s_s);
mass=max(res_A_S_S');

clear Agpu_s resA_s_s resA_s_c Bgpu_c Bgpu_s
reset(g);

TP=0;
FP=0;
TN=0;
FN=0;
for i =1:length(macc)    
    if(macc(i)>macs(i))
        TP = TP+1;
    else
        FP = FP+1;
    end
    
    if(mass(i)>masc(i))
        TN=TN+1;
    else
        FN=FN+1;
    end
end

esp=TN/(TN+FP)
sen=TP/(TP+FN)
acc=(TP+TN)/(TP+TN+FP+FN)
prec=TP/(TP+FP)

figure
subplot(2,1,1)
histogram(macc,50,'Normalization','probability');
hold on
histogram(macs,50,'Normalization','probability');
title('Janelas com Pneumatose')
legend('Verdadeiro Positivo','Falso Positivo')
xlabel('Valores de maximos')
ylabel('Nº Janelas (%)')
hold off
subplot(2,1,2)
histogram(masc,50,'Normalization','probability');
hold on
histogram(mass,50,'Normalization','probability');
title('Janelas sem Pneumatose')
legend('Falso Negativo','Verdadeiro Negativo')
xlabel('Valores de maximos')
ylabel('Nº Janelas (%)')


%% Agora variando um limiar de aceitação

class_C= macc - macs;
class_S= masc - mass;

class_C(isnan(class_C))=[];
class_S(isnan(class_S))=[];

x = [-0.6:.001:0.6];
c = normpdf(x,mean(class_C),sqrt(var(class_C)));
s = normpdf(x,mean(class_S),sqrt(var(class_S)));

figure
plot(x,c);
hold on
plot(x,s);
legend('Classe com p.','Classe sem p.')
xlabel('Limiar')
title('Distribuição das Classes')

v_TP=zeros(1,length(x));
v_FP=zeros(1,length(x));
v_TN=zeros(1,length(x));
v_FN=zeros(1,length(x));

v_esp=zeros(1,length(x));
v_sen=zeros(1,length(x));
v_acc=zeros(1,length(x));
v_prec=zeros(1,length(x));

for k = 1 : length(x)
   
    lim = x(k);
    
    v_TP(k)=sum(class_C>lim); 
    v_FP(k)=sum(class_S>lim);
    v_TN(k)=sum(class_S<lim);
    v_FN(k)=sum(class_C<lim); ;
    
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

AUC = trapz(roc,v_sen)

figure
plot(x,v_esp);
hold on
plot(x,v_sen);
plot(x,v_acc);
plot(x,v_prec);
plot(x(find(v_acc==max(v_acc))),max(v_acc),'r.','MarkerSize',20)
title(strcat('Melhor Limiar :',num2str(x(find(v_acc==max(v_acc))))))
legend('Especificidade','Sensibilidade','Acurácia','Precisão')

youden = v_sen + v_esp - 1;
figure
plot(x,youden);
title('Índice de Youden')
f_you = find(youden == max(youden));

k = find(v_acc==max(v_acc));

v_TP(k)./length(class_C) 
v_FP(k)./length(class_C)
v_TN(k)./length(class_C)
v_FN(k)./length(class_C)

v_esp(k)
v_sen(k)
v_acc(k)
v_prec(k)

%% Plot matrix de confusão

melhor_limiar=x(find(v_acc==max(v_acc)));
v_class_C = class_C > melhor_limiar;
v_class_S = not(class_S < melhor_limiar);

predic = double([v_class_C v_class_S]);
train = [ones(1,length(v_class_C)) zeros(1,length(v_class_S))];
plotconfusion(train,predic);
%% ROC
v_class_C = class_C;
v_class_S = class_S;

predic_cm = double([v_class_C v_class_S]);
train_cm = [ones(1,length(v_class_C)) zeros(1,length(v_class_S))];

[tpr,fpr,thresholds] = roc(train_cm,predic_cm);
AUC=trapz(fpr,tpr)
figure
plotroc(train_cm,predic_cm)
