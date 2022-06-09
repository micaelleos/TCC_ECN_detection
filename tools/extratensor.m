function [ tLn ] = extratensor(tensor,coor,dimj)
% Função de extração de tensores a partir das coordenadas(coor). 
%Recorte pela extensão do tensor.
% tensor= o proprio tensor.
% coor= coordenadas de recorte.
% dimj= Dimensão da janela de recorte no tensor, é um escalar.
%tLn = conjunto de tensores. size(tLn)=(nt,nk,x,y).

nk=size(tensor,1);
nt=length(coor);
tLn=zeros(nt,nk,dimj,dimj);
j=floor(dimj/2);

for i = 1: nt
%REVER SE VALOR MÁXIMO É NO CENTRO DO KERNEL OU NO INÍCIO.
    tLn(i,:,:,:)=tensor(:,coor(1,i)-j:coor(1,i)+j-1,coor(2,i)-j:coor(2,i)+j-1);
    i
end

end

