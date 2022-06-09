clear; clf; close all;
%load wbarb;
A = imread('imteste.jpg');
BA = zeros(size(A));
BH = zeros(size(A));
BV = zeros(size(A));
BD = zeros(size(A));

k=20; %tamanho da janela
n=1;
niveisdec=[];
tic
for i = 1 : size(A,1) - k
    for j = 1 : size(A,2) - k
        A1 = A(i:i+k,j:j+k);
        dx=2^(floor(log2(size(A1,1))));
        dy=2^(floor(log2(size(A1,2))));

        X = A1(1:dx,size(A1,2)-dy+1:end);
        
        niveisdec = multdecwave(X,'haar',n);
     
        energy  = waveEnergy( niveisdec );
        energy2=energy/sum(sum(energy));
        BA(i,j) = energy(n,1);
        BH(i,j) = energy(n,2);
        BV(i,j) = energy(n,3);
        BD(i,j) = energy(n,4);
    end
end
%% Show
toc
map=colormap('pink');
 for i=1:n
 showdecwave( niveisdec(i).WLL,niveisdec(i).WLH,niveisdec(i).WHL,niveisdec(i).WHH,map,0 );
 end
A1=A(360:380,710:730);
figure
colormap('gray');
image(teste,'CDataMapping','scaled')
figure
image(BH,'CDataMapping','scaled')
figure
image(BV,'CDataMapping','scaled')
figure
image(BD,'CDataMapping','scaled')