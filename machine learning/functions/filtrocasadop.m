function [ J ] = filtrocasadop( A, b, masc )
% Aplica��o de filtro casado n�o linear, com dica de processamento com masc
%   espera-se que b tenha dimens�es �mpares
%b=b0(2:end,2:end); % armengue por ter cortado os kernels na dimen��o 40x40

[dbx dby]=size(b);

M=zeros(dbx,dby);
J=zeros(size(A,1),size(A,2));

%Normaliza��o dos vetores
b=b(:);
b=b-mean(b);
b=b./norm(b);

% nesta convolu��o h� redu��o da imagem de sa�da - sem padding
for i = 1:size(A,1)-ceil(dbx/2)
    for j = 1:size(A,2)-ceil(dby/2)
        if (i>ceil(dbx/2) && j>ceil(dby/2))
            if masc(i,j) == 1
                M = A(i-ceil(dbx/2):i+floor(dbx/2)-1,j-ceil(dby/2):j+floor(dby/2)-1);
                M=M(:);
                M=M-mean(M);
                if (norm(M)~=0)
                M=M./norm(M);
                end
                 J(i,j)=M(:)'*b(:);
                 if J(i,j)>1 % an�lise de erro no c�digo
                 i;
                 end
            end
        end
    end
end

end