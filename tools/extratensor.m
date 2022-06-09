function [ tLn ] = extratensor(tensor,coor,dimj)
% Fun��o de extra��o de tensores a partir das coordenadas(coor). 
%Recorte pela extens�o do tensor.
% tensor= o proprio tensor.
% coor= coordenadas de recorte.
% dimj= Dimens�o da janela de recorte no tensor, � um escalar.
%tLn = conjunto de tensores. size(tLn)=(nt,nk,x,y).

nk=size(tensor,1);
nt=length(coor);
tLn=zeros(nt,nk,dimj,dimj);
j=floor(dimj/2);

for i = 1: nt
%REVER SE VALOR M�XIMO � NO CENTRO DO KERNEL OU NO IN�CIO.
    tLn(i,:,:,:)=tensor(:,coor(1,i)-j:coor(1,i)+j-1,coor(2,i)-j:coor(2,i)+j-1);
    i
end

end

