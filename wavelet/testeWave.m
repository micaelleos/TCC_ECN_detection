clear; clc; close all;
load woman

image(X); colormap(map); colorbar;

W=[0.5 0.5];
[Lo_D,Hi_D,Lo_R,Hi_R] = orthfilt(W)

imH=X(:);
Wd=conv(Hi_D,imH);
Wd(end)=[];

imH2=reshape(Wd,size(X));
imd=(255/max(max(imH2)))*imH2;
figure
image(imd); colormap(map); colorbar;

imH3=imH2(1:2:end,1:2:end);
imH4=imH3(:);

Wdd=conv(Hi_D,imH4);
Wdd(end)=[];
imH5=reshape(Wdd,size(X)/2);
imd2=(255/max(max(imH5)))*imH5;
figure
image(imd2); colormap(map); colorbar;