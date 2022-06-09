
% variável a ser visualizada
tL=resL2;

%% visualização de tensor de saída de camada
soma=zeros(size(tL(1,:,:)));
for j=1:size(tL,1)
    soma=soma+abs(tL(j,:,:));
end

soma=squeeze(soma);

soma=squeeze(soma);
figure
colormap('gray')
image(soma,'CDataMapping','scaled')

[x y]=find(soma==max(max(soma)));
hold on
plot(y,x,'dr')

%% visualização de conjunto de tensores -> tensores de treinamento
x=[];
y=[];
z=[];
for i=1:size(tL,1)
tensor=squeeze(tL(i,:,:,:));
tensor2=zeros(size(tensor));
tensor2(tensor(:,:,:)>0.5)=1;

[z,x,y] = ind2sub(size(tensor),find(tensor2==1));

figure
plot3(z,x,y,'.');

clear x y z
end

