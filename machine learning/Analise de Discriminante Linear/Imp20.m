clear;clc;close all;

%% Função Discriminante de Fischer

arquivos_c = dir('../base de dados/train/com'); %diretório das bases
arquivos_s = dir('../base de dados/train/sem');
quantIm = length(arquivos_c)-3;

% A_com=[];
% A_sem=[];
% 
% for j = 1 : quantIm
%     b=double(imread(strcat('../base de dados/train/com/',arquivos_c(j+2).name)));
%     b=b(:);
%     
%     A_com=[A_com,b];
%     
%     b2=double(imread(strcat('../base de dados/train/sem/',arquivos_s(j+2).name)));
%     b2=b2(:);
%     
%     A_sem=[A_sem,b2]; 
% end

load('data_A.mat')

%% Cálculo das médias

m_c= mean(A_com,2);
m_s= mean(A_sem,2);

m = (m_c + m_s)/0.5;

Sb=size(A_com,2)*(m_c-m)'*(m_c-m) + size(A_sem,2)*(m_s-m)'*(m_s-m);

s_c=0;
s_s=0;
for i = 1:length(size(A_com,2))
s_c=s_c+(A_com(:,i)-m_c)*(A_com(:,i)-m_c)';
s_s=s_s+(A_sem(:,i)-m_s)*(A_sem(:,i)-m_s)';
end

Sw=s_c+s_s;

M = inv(Sw)*Sb;


[V,D] = eig(M);
D=sum(D,1);

W1=V(1,:)';


a_c_1 = zeros(size(A_com,2),1);

for j = 1 :size(A_com,2)
a_c_1(j)=A_com(:,j)'*W1;
end

a_s_1 = zeros(size(A_com,2),1);
for j = 1 :size(A_com,2)
a_s_1(j)=A_sem(:,j)'*W1;
end


%% Gaussianas

y_c =[a_c_1];
y_s =[a_s_1];

m2_c = mean(y_c,1);
m2_s = mean(y_s,1);

m2_c = repmat(m2_c,size(y_c,1),1);
m2_s = repmat(m2_s,size(y_c,1),1);

v_c = var(y_c,1);
v_s = var(y_s,1);

v_c = repmat(v_c,size(y_c,1),1);
v_s = repmat(v_s,size(y_c,1),1);

c=normpdf(y_c,m2_c,sqrt(v_c));
s=normpdf(y_s,m2_s,sqrt(v_s));

%% dados de teste

load('data_B.mat')

% Levar dados para o novo espaço
b_c_1 = zeros(size(B_com,2),1);
for j = 1 :size(B_com,2)
b_c_1(j)=B_com(:,j)'*W1;
end

b_s_1 = zeros(size(B_com,2),1);
for j = 1 :size(B_com,2)
b_s_1(j)=B_sem(:,j)'*W1;
end

yb_c =[b_c_1];
yb_s =[b_s_1];

mb2_c = mean(yb_c,1);
mb2_s = mean(yb_s,1);

mb2_c = repmat(mb2_c,size(yb_c,1),1);
mb2_s = repmat(mb2_s,size(yb_c,1),1);

vb_c = var(yb_c,1);
vb_s = var(yb_s,1);

vb_c = repmat(vb_c,size(yb_c,1),1);
vb_s = repmat(vb_s,size(yb_c,1),1);

cb=normpdf(yb_c,mb2_c,sqrt(vb_c));
sb=normpdf(yb_s,mb2_s,sqrt(vb_s));

%% Discriminantes linear

% função da média e var
%Com
[ Pbcc ] = fdpgauss( yb_c,y_c,1 );
[ Pbcs ] = fdpgauss( yb_c,y_s,1 );

figure;
plot(yb_c(:,1),Pbcc,'.')
hold on
plot(yb_c(:,1),Pbcs,'.')

%Sem
[ Pbsc ] = fdpgauss( yb_s,y_c,3 );
[ Pbss ] = fdpgauss( yb_s,y_s,3 );

figure;
plot(yb_s(:,1),Pbsc,'.')
hold on
plot(yb_s(:,1),Pbss,'.')

%% Métricas

TP=0;
FP=0;
TN=0;
FN=0;
for i =1:size(B_sem,2)   
    if(Pbcc(i)>Pbcs(i))
        TP = TP+1;
    else
        FN = FN+1;
    end
    
    if(Pbss(i)>Pbsc(i))
        TN=TN+1;
    else
        FP=FP+1;
    end
end

esp=TN/(TN+FP)
sen=TP/(TP+FN)
acc=(TP+TN)/(TP+TN+FP+FN)
prec=TP/(TP+FP)
TP
FP
TN
FN

%% Variação de Limiar

%valores de yb_c
figure
histogram((yb_c),50,'Normalization','probability');
hold on
histogram((yb_s),50,'Normalization','probability');
title('Histograma de valores da base de teste no espaço W')
xlabel('Valor do dado em W')
ylabel('% de dados')

x=-250:1:50;

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
    
    v_TP(k)=sum(yb_c>lim); 
    v_FP(k)=sum(yb_s>lim);
    v_TN(k)=sum(yb_s<lim);
    v_FN(k)=sum(yb_c<lim); ;
    
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

v_TP(k)./length(yb_c) 
v_FP(k)./length(yb_c)
v_TN(k)./length(yb_c)
v_FN(k)./length(yb_c)

v_esp(k)
v_sen(k)
v_acc(k)
v_prec(k)

%% Matrix de confusão 

melhor_limiar=x(find(v_acc==max(v_acc)));
v_class_C = yb_c > melhor_limiar;
v_class_S = not(yb_s < melhor_limiar);

predic = double([v_class_C' v_class_S']);
train = [ones(1,length(v_class_C)) zeros(1,length(v_class_S))];
plotconfusion(train,predic);

[tpr,fpr,thresholds] = roc(train,predic);
AUC=trapz(fpr,tpr)
