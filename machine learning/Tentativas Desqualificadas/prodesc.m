function [m,x,y] = prodesc(b,A)
%PRODESC produto escalar entre imagens
%   Retorna a coordenada da imagem A1 onde melhor se encaixou a imagem b

   % armazena em formato de vetor
   vec = b(:); 
   %Normaliza vetor imgbase
   vec = (max(vec)-vec);
   vec=vec/norm(vec);
   
   %Transforma imagem a ser analizada em vetor (exame)
   A1=A(:);
   %Normaliza o vetor imagem
   A1=(max(A1)-A1);
   A1=A1/norm(A1);
   
   %Organização de coordenadas para posterior mapeamento
   linha=[1:size(A,1)];
   lin=repmat(linha,1,size(A,2));
   col=repelem(linha,size(A,2));
   %Produto escalar do vetor imgbase com o vetor imagem
   J=zeros(size(A));
   tam = length(vec);
   for j = 1:length(A1)
      if j<=length(A1)-tam
       p=vec;
      else
        p=vec(1:end-(tam-length(A1(j:end))));  
      end
      J(lin(j),col(j))=dot(A1(j:j+length(p)-1),p);
   end
   
%    figure
%    surf(J(1:2:end,1:2:end))
%    colorbar
   figure
   imagesc(J)
%    
   %encontrar melhor ponto correspondente
   m =min(min(J(10:end-10,10:end-10)));
   [x,y]=find(J==m);
end

