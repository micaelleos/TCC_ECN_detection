clear;clc; close all;

A = imread('../Recortes/5961.1.jpeg');
%A = imread('./1/Camada 22.png');
if length(size(A))==3
   A=double(rgb2gray(A));
else
    A=double(A);
end

imshow(uint8(A))


 w1 =  [ 0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512;
   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378;
   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268;
   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378;
    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512];
    
 w2  = filtlinha(6,10); 
   
imres = convn(A,w2,'same');
%[y,x]=find(imres==min(min(imres)));


%trandformação logarítmica
%imres4 = imres(50:end-50,:);
 imres4 = imres;
% imres4= real(log(imres4));
imres4(imres4>0)=0; 
imres4(imres4<0)=255;
 

figure;
surf(imres4);

figure
image(-imres4,'CDataMapping','scaled')
title('imres')
colorbar

% figure
% c=imfuse(imres,A);
% image(c);


    




    
    
    
    