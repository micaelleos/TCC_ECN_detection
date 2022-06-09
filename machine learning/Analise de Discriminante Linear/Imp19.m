clear;clc;close all;

%% Função Discriminante de Fischer

% arquivos_c = dir('../base de dados/train/com'); %diretório das bases
% arquivos_s = dir('../base de dados/train/sem');
% quantIm = length(arquivos_c)-3;
% 
% A_com=[];
% A_sem=[];
% 
% for j = 1 : quantIm
%     j
%     b=double(imread(strcat('../base de dados/train/com/',arquivos_c(j+2).name)));
%     b=b(:);
%     
%     A_com=[A_com,b];
%     
%     b2=double(imread(strcat('../base de dados/train/sem/',arquivos_s(j+2).name)));
%     b2=b2(:);
%     
%     A_sem=[A_sem,b2];
%     
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
W2=V(2,:)';
W3=V(3,:)';

a_c_1 = zeros(size(A_com,2),1);
a_c_2 = zeros(size(A_com,2),1);
a_c_3 = zeros(size(A_com,2),1);
for j = 1 :size(A_com,2)
a_c_1(j)=A_com(:,j)'*W1;
a_c_2(j)=A_com(:,j)'*W2;
a_c_3(j)=A_com(:,j)'*W3;
end

a_s_1 = zeros(size(A_com,2),1);
a_s_2 = zeros(size(A_com,2),1);
a_s_3 = zeros(size(A_com,2),1);
for j = 1 :size(A_com,2)
a_s_1(j)=A_sem(:,j)'*W1;
a_s_2(j)=A_sem(:,j)'*W2;
a_s_3(j)=A_sem(:,j)'*W3;
end


figure;
plot3(a_c_1,a_c_2,a_c_3,'r.')
hold on 
plot3(a_s_1,a_s_2,a_s_3,'b.')
legend('Classe com','Classe sem')

%% Gaussianas

x=[W1 W2 W3]; %meus vetores epeciais

y_c =[a_c_1 a_c_2 a_c_3];
y_s =[a_s_1 a_s_2 a_s_3];

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

figure
plot3(c(:,1),c(:,2),c(:,3),'r.')
title('Distribuição Normal Classe com p.')
figure
plot3(s(:,1),s(:,2),s(:,3),'b.')
title('Distribuição Normal Classe sem p.')

figure
plot3(c(:,1),c(:,2),c(:,3),'r.')
hold on
plot3(s(:,1),s(:,2),s(:,3),'b.')
title('Distribuição Normal dos dados de treinamento em W')
legend('classe com p.','classe sem p.')
xlabel('w1')
ylabel('w2')
zlabel('w3')

%% dados de teste

% arquivos_c = dir('../base de dados/test/com'); %diretório das bases
% arquivos_s = dir('../base de dados/test/sem');
% quantIm = length(arquivos_c)-3;
% 
% 
% B_com=[];
% B_sem=[];
% 
% for j = 1 : quantIm
%     j
%     b=double(imread(strcat('../base de dados/test/com/',arquivos_c(j+2).name)));
%     b=b(:);
%     
%     B_com=[B_com,b];
%     
%     b2=double(imread(strcat('../base de dados/test/sem/',arquivos_s(j+2).name)));
%     b2=b2(:);
%     
%     B_sem=[B_sem,b2];
%     
% end

load('data_B.mat')

% Levar dados para o novo espaço
b_c_1 = zeros(size(B_com,2),1);
b_c_2 = zeros(size(B_com,2),1);
b_c_3 = zeros(size(B_com,2),1);
for j = 1 :size(B_com,2)
b_c_1(j)=B_com(:,j)'*W1;
b_c_2(j)=B_com(:,j)'*W2;
b_c_3(j)=B_com(:,j)'*W3;
end

b_s_1 = zeros(size(B_com,2),1);
b_s_2 = zeros(size(B_com,2),1);
b_s_3 = zeros(size(B_com,2),1);
for j = 1 :size(B_com,2)
b_s_1(j)=B_sem(:,j)'*W1;
b_s_2(j)=B_sem(:,j)'*W2;
b_s_3(j)=B_sem(:,j)'*W3;
end

yb_c =[b_c_1 b_c_2 b_c_3];
yb_s =[b_s_1 b_s_2 b_s_3];

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

figure
plot3(cb(:,1),cb(:,2),cb(:,3),'r.')
title('Distribuição Normal Classe com p.')
figure
plot3(sb(:,1),sb(:,2),sb(:,3),'b.')
title('Distribuição Normal Classe sem p.')

figure
plot3(cb(:,1),cb(:,2),cb(:,3),'r.')
hold on
plot3(sb(:,1),sb(:,2),sb(:,3),'b.')
title('Distribuição Normal dos dados de teste em W')
legend('classe com p.','classe sem p.')
xlabel('w1')
ylabel('w2')
zlabel('w3')

%% Discriminantes linear

% Classificação por PDF
% função da média e var
%Com
[ Pbcc ] = fdpgauss( yb_c,y_c,3 );
[ Pbcs ] = fdpgauss( yb_c,y_s,3 );

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


% Métricas
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

%% Classificação por Quadratica

C1=cov(y_c(:,1));
C2=cov(y_s(:,1));

mu1 = mean(y_c(:,1));
mu2 = mean(y_s(:,1));

[ Wo1,w1,wo1 ] = Quadraticclass(C1,mu1',0.5);
[ Wo2,w2,wo2 ] = Quadraticclass(C2,mu2',0.5);

x=yb_s(:,1);
fc=zeros(size(x,1),1);
for t = 1 :size(x,1)
 fc(t) = discrimFunc( x(t,:),Wo1,w1,wo1,Wo2,w2,wo2 );
end

sum(fc>0)




