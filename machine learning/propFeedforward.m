function [ AL, variaveis2 ] = propFeedforward ( A, variaveis )
% Propagação feedforward dos dados na rede.

l=length(variaveis);
variaveis2=[];Z=[];
for i = 1:l
   Z = variaveis(i).W * A + repmat(variaveis(i).b,1,size(A,2));  
    A = ones(size(Z))./(ones(size(Z)) + exp(-Z));
   variaveis2(i).Z=Z;
   variaveis2(i).A=A;
end
AL=A;
end

