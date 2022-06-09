function [ y ] = multiescala(A1,n)
%MULTIESCALA subamostragem com filtragem anti-recobrimento 
%   Detailed explanation goes here
for i = 1:n
    y=A1(1:end-1,1:end-1)+A1(1:end-1,2:end)+A1(2:end,1:end-1)+A1(2:end,2:end);
    y=y*(1/4);    
end
end

