function [ W,w,wo ] = Quadraticclass(C,mu,P)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
W = -0.5*inv(C);
w = inv(C)*mu;
wo = -0.5*mu'*inv(C)*mu - 0.5*log(det(C)) + log(P);
end

