function [ Hc,Hs ] = verHipo( Jc,Js,poseq )
%Verifica��o da hip�tese nula
%   Detailed explanation goes here

Hc = [];
Hs = [];

for i = 1 : length(Jc)
   
    x=Jc(i).x;
    y=Jc(i).y;
    
    if(any(any(poseq(x:x+20,y:y+20)))==1)
        Jc.img
    end
    
end

end

