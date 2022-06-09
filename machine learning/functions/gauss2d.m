function [G] = gauss2d(sx,sy,sigx,sigy)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cx=ceil(sx/2);
cy=ceil(sy/2);

%sigx=20; 
%sigy=20;

gx=1:sx;
gy=gx';
G=zeros(sx,sy);
for i = 1 : sx
    for j = 1 : sy
    G(i,j) = exp(-((gx(i)-cx)^2/(2*sigx^2) + (gy(j)-cy)^2/(2*sigy^2)));
    end
end

end

