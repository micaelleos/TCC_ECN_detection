function [ Jc,Js ] = extraJanelas(A,AM)
%Recorte de kernels automático por meio de máscara.
%   A= Imagem a ser recortada, 
%   Am = Máscara da Imagem em preto e branco,

n1=1;
n2=1;
tk=20; %tamanho dos recortes
Jc=[];
Js=[];
masC=zeros(size(AM));
masS=zeros(size(AM));

% recorte de janelas com pneumatose
for i = ceil(tk/2)+ 1: size(AM,1) - floor(tk/2)-1
    
   for j = ceil(tk/2) +1 : size(AM,2) - floor(tk/2) -1
    
    x= i-ceil(tk/2):i+floor(tk/2);
    y= j-ceil(tk/2):j+floor(tk/2);
       
    mC=masC(x,y);
    mS=masS(x,y);
    am=AM(x,y);
   
   if((i+20 > size(A,1))==0 && (j+20 > size(A,2))==0)
       if ((any(any(mC))==0)&& (any(any(am))==1))
           Jc(n1).img=A(x,y);
           Jc(n1).x=i;
           Jc(n1).y=j;
           masC(x,y)=1;
           n1=n1+1;
       end
   end 
   end
end

%recorte de janelas sem pneumatose
for i = ceil(tk/2)+ 1: size(AM,1) - floor(tk/2)-1
    
   for j = ceil(tk/2) +1 : size(AM,2) - floor(tk/2) -1
    
    x= i-ceil(tk/2):i+floor(tk/2);
    y= j-ceil(tk/2):j+floor(tk/2);
       
    mC=masC(x,y);
    mS=masS(x,y);
    am=AM(x,y);
   
   if((i+20 > size(A,1))==0 && (j+20 > size(A,2))==0)
       if ((any(any(mC))==0) && (any(any(mS))==0)&& ...
               (any(any(am))==0))
           Js(n2).img=A(x,y);
           Js(n2).x=i;
           Js(n2).y=j;
           masS(x,y)=1;
           n2=n2+1;
       end
   end 
   end
end
end

