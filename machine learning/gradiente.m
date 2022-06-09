function [dW1,dW2]=gradiente(W2,W1,X,y)
% Calculo de gradiente das matrizes de peso
    dW1=zeros(size(W1));
    dW2=zeros(size(W2));
    
    %Feed-Forward
    z=tanh(W1*X);
    Z=[ones(1,size(z,2));z];
    y_=0.5+0.5.*tanh(0.5*W2*Z);
    
    %calculo de erro
    err=-(y-y_);
    
    %Back-propagation
    retro=(err.*(y_.*(1-y_)))'*W2(:,2:end);     
    dW1=(X*(retro.*(1-z.^2)'))';
    retro2=err.*(y_.*(1-y_));
    dW2 = (retro2*Z');
end

