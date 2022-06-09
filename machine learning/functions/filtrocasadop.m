function [ J ] = filtrocasadop( A, b, masc )
% Aplicação de filtro casado não linear, com dica de processamento com masc
%   espera-se que b tenha dimensões ímpares
%b=b0(2:end,2:end); % armengue por ter cortado os kernels na dimenção 40x40

[dbx dby]=size(b);

M=zeros(dbx,dby);
J=zeros(size(A,1),size(A,2));

%Normalização dos vetores
b=b(:);
b=b-mean(b);
b=b./norm(b);

% nesta convolução há redução da imagem de saída - sem padding
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
                 if J(i,j)>1 % análise de erro no código
                 i;
                 end
            end
        end
    end
end

end