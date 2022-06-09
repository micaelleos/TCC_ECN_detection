clear; clf; close all;
%load wbarb;
A1 = imread('5961.1.jpg');
dx=2^(floor(log2(size(A1,1))));
dy=2^(floor(log2(size(A1,2))));
%A1=rgb2gray(A);
X = A1(1:dx,size(A1,2)-dy+1:end);
map=colormap('pink');
image(X); colormap(map); colorbar;
[cA1,cH1,cV1,cD1] = dwt2(X,'db1');

A1 = upcoef2('a',cA1,'db1',1);
H1 = upcoef2('h',cH1,'db1',1); 
V1 = upcoef2('v',cV1,'db1',1);
D1 = upcoef2('d',cD1,'db1',1);

colormap(map);
subplot(2,2,1); image(wcodemat(cA1,192));
title('Approximation A1')
subplot(2,2,2); image(wcodemat(cH1,192));
title('Horizontal Detail H1')
subplot(2,2,3); image(wcodemat(cV1,192));
title('Vertical Detail V1') 
subplot(2,2,4); image(wcodemat(cD1,192));
title('Diagonal Detail D1')

Xsyn = idwt2(cA1,cH1,cV1,cD1,'db1');

[C,S] = wavedec2(X,2,'db1');

%% 
% [WLL,WLH,WHL,WHH] = ddwaveletdec(X,'haar');
% 
% showdecwave( WLL,WLH,WHL,WHH,map )
% 
% figure
% WLL=(255/max(max(WLL)))*WLL;
% subplot(2,2,1);
% image(WLL); colormap(map);
% title('WLL')
% 
% WLH=(255/max(max(WLH)))*WLH;
% subplot(2,2,2);
% image(WLH); colormap(map);
% title('WLH')
% 
% WHL=(255/max(max(WHL)))*WHL;
% subplot(2,2,3);
% image(WHL); colormap(map);
% title('WHL')
% 
% WHH=(255/max(max(WHH)))*WHH;
% subplot(2,2,4);
% image(WHH); colormap(map);
% title('WHH')
%% 
n=5
niveisdec = multdecwave(X,'haar',n);

for i=1:n
showdecwave( niveisdec(i).WLL,niveisdec(i).WLH,niveisdec(i).WHL,niveisdec(i).WHH,map,0 );
end

energy  = waveEnergy( niveisdec );
energy2=energy/sum(sum(energy));
