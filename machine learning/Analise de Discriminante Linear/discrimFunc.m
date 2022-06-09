function [ f ] = discrimFunc( x,Wo1,w1,wo1,Wo2,w2,wo2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
f=x*Wo1*x'-x*Wo2*x'+w1'*x'-w2'*x'+wo1-wo2;
end

