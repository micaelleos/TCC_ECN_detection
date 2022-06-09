function [ J ] = crosscoor( A,b)
%Operação de correlação crusada entre imagem 


%   Assume-se que b tem dimensões ímpares.

% A2=zeros((size(A,1)+2*size(b,1)),(size(A,2)+2*size(b,2)));
% A2(size(b,1):end-size(b,1)-1,size(b,2):end-size(b,2)-1)=A;

J=zeros(size(A));

dx=size(b,1);
dy=size(b,2);

M=zeros(size(b));

%Normalização do filtro
b=b(:);
b=b-mean(b);
b=b/norm(b); % para o cálculo correto da norma, b tem que ser um vetor e não uma matriz


%convolução com resultado de mesma dimensão que a imagem A
for i = 1:1:size(A,1)
    for j = 1:1:size(A,2)
        if((i<size(A,1)-dx)&&(j<size(A,2)-dy))
            if (i==463 && j == 361)
            i
            end
        %Janela de operação
        M=A(i:i+dx-1,j:j+dy-1);
        M=M(:);
        M=M-mean(M);
        M=M/norm(M);
        
%         if(sum(find(M~=0))~=0)
%         %Normalização da Janela
%         M=M-mean(M(:));
%         M=M./norm(M);
%         end
        
        J(i,j)=M'*b;
        end
        end
    end
end

