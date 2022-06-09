function [ MASC ] = estendermasc( masc )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    MASC = zeros(2*size(masc,1),2*size(masc,2));
    
    for i = 0:size(masc,1)-1
        for j = 0:size(masc,2)-1
            if masc(i+1,j+1) == 1
            MASC(2*i+1:2*i+2,j*2+1:2*j+2)=1;
            end
        end
    end
    
end

