function [ P ] = fdpgauss( X,Y,d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% processamento de dados com
P=zeros(1,size(X,1));
n=zeros(1,size(X,1));
C=cov(Y);
m=mean(Y);
for k =1 :size(X,1)
n(k)=mvnpdf(X(k,:),m,C);
P(k)=n(k)*0.5;
end
end

