clear;clc; close all;

A = double(imread('../Exames/5961.1.jpeg'));
arquivos = dir;
n=1; % número de imgbase abertas por vez

figure(1)
imshow(uint8(A))

 w =  [ 0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512;
   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378;
   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268   -0.2268;
   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378   -0.0378;
    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512    0.1512];
    


for i = 1:n
   % abre imgbase 
  % b=double(rgb2gray(imread(arquivos(i+2).name)));
   %b=double(imread(arquivos(i+2).name));
%     figure
%     title(strcat('Imgbase ',int2str(i)))
%     imshow(uint8(b))
    
    
    J=[];
   for j = 1:1
    [m,x,y] = prodesc(w,A);
    J(j,1:3) = [m,x,y];
     A  = multiescala(A);
   end
    
   x1= J(find(J(:,1)==max(J(:,1))),2);
   y1= J(find(J(:,1)==max(J(:,1))),3);
   
    figure(1)
    hold on
    plot(x1,y1,'o')
    text(x1,(y1+20),int2str(i),'Color','white','FontSize',10)
    drawnow 
end
