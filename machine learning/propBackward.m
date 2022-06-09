function [ gradientes ] = propBackward(y,variaveis,variaveis2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
l=length(variaveis);
AL=y;
gradientes=[];

for i = l:-1:1
   dA = sum((variaveis2(i).A-AL),1);
   AL = (variaveis2(i-1).A);
   
   dZ = dA .* variaveis2(i).A.*(1-variaveis2(i).A);
   dW = dZ .* sum(variaveis2(i-1).A,1);
   db = dZ;
   gradientes(i).dW=dW;
   gradientes(i).db=db;
end

end

