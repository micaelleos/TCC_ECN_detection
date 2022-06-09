clear;clc;close all;

%% Pré processamento 
%abrindo imagens
r_nomedir='2'; 
r_arquivos = dir(strcat('./',r_nomedir)); 
r_quantIm =3% length(r_arquivos)-2;
r_tensor=zeros(20,20,r_quantIm);
for l = 1: r_quantIm
r_tensor(:,:,l)=double(imread(strcat(r_nomedir,'/',r_arquivos(l+2).name)));
end

%abrindo imagens
nomedir='4'; 
arquivos = dir(strcat('./',nomedir)); 
quantIm = length(arquivos)-2;

v=zeros(quantIm,r_quantIm);
for l = 1: quantIm
b=double(imread(strcat(nomedir,'/',arquivos(l+2).name)));
b=b(:)-mean(b(:));
b=b./norm(b);
for k=1:r_quantIm
r=squeeze(r_tensor(:,:,k));
r=r(:)-mean(r(:));
r=r/norm(r);
v(l,k)=b'*r;
end
end
%% K-means


k=3;
center = rand(k,r_quantIm)/5;

figure
plot3(v(:,1),v(:,2),v(:,3),'.')
hold on
plot3(center(:,1),center(:,2),center(:,3),'.')

d=zeros(quantIm,k);

for i = 1: 10
   
    %distância euclidiana
    for j = 1:k
    d(:,j) = sqrt(sum((v-repmat(center(j,:),quantIm,1)).^2,2));
    end
    
    %associar os pontos às centroides mais próximas
    [x,k_max]=max(d');

    for c=1:k
    center(c,:)=1/(sum(k_max==c)+0.00001)*sum(v(find(k_max==c),:),1);
    end
    
end

figure
plot3(v(:,1),v(:,2),v(:,3),'.')
hold on
plot3(center(:,1),center(:,2),center(:,3),'.')


for l = 1: quantIm
b=imread(strcat(nomedir,'/',arquivos(l+2).name));
imwrite(b,strcat('./5/',int2str(k_max(l)),'/',int2str(l),'.jpg'));
end