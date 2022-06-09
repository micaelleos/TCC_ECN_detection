function [y]= modelo(W2,W1,X)
% Modelo de rede neural de duas camadas
    z=tanh(W1*X);
    Z=[ones(1,size(z,2));z];
    y=0.5+0.5.*tanh(0.5*W2*Z);
end

