function [ J ] = filtrocasadog( A, b2 )
%Filtro casado com Gradiente de importância (multiplicação com uma
%gaussiana) da janelinha M
%   Detailed explanation goes here

[dbx dby]=size(b2);

M=zeros(dbx,dby);
J=zeros(size(A,1),size(A,2));

g=gauss2d(dbx,dby,7,7);
%Normalização dos vetores
b=b2.*g;
b=b(:);
b=b-mean(b);
b=b./norm(b);

% nesta convolução há redução da imagem de saída - sem padding
for i = 1:size(A,1)-ceil(dbx/2)
    for j = 1:size(A,2)-ceil(dby/2)
        if (i>ceil(dbx/2) && j>ceil(dby/2))
            %Recorte de janela da imagem A (processada)
            M = A(i-ceil(dbx/2):i+floor(dbx/2)-1,j-ceil(dby/2):j+floor(dby/2)-1);
            M=M(:); %vetorização da janela
            M=M-mean(M);
            if (norm(M)~=0)
            M=M./norm(M);
            end
             J(i,j)=M(:)'*b(:); 
        end
    end
end
end

