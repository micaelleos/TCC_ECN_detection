function [ B ] = diffrel( A, janela )
%Filtro realcador de diferenças
%   Detailed explanation goes here

a = size(A,1);
b = size(A,2);
n=floor(janela/2);
B=A;%zeros(size(A));

v_min=0;
v_max=0;

for i = 1 : a
    for j = 1 : b 
        if( i>n && j>n && (j<b-n) && (i<a-n))

        v_min = min(min(A(i-n:i+n,j-n:j+n)));
        v_max = max(max(A(i-n:i+n,j-n:j+n)));
        
        B(i,j) = v_max + abs(v_min);
        end
    end
end

end

