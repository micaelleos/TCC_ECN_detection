function dataaugmentation(var,dir)
%Fun��o de aumento de dados. Imagens s�o salvas
%no diret�rio "dir". 
%   Distor��es aplicadas:
%   -rota��o        3x
%   -espelhamento   1x
%   -escalonamento  4x
n=1;
for l = 1: length(var)
    b=var(l).img;
    imwrite(uint8(b),strcat(dir,...
        int2str(l),'.tif'));
    rse(b,n,dir) %vers�es escalonadas
    
    b_esp= flip(b,1); % vers�o espelhada
    imwrite(uint8(b_esp),strcat(dir,...
        int2str(l),'_','esp_.tif'));
    
    n=n+1;
    rse(b_esp,n,dir) %vers�es escalonadas
    
    %vers�es rotacionadas 
    for j = 1:3
        b=rot90(b);
        imwrite(uint8(b),strcat(dir,...
            int2str(l),'_','rot_',int2str(j),'.tif'));

        n=n+1;
        rse(b,n,dir) %vers�es escalonadas

        b_esp= flip(b,1); % vers�o espelhada
        imwrite(uint8(b_esp),strcat(dir,...
            int2str(l),'_','esp_',int2str(j),'.tif'));

        n=n+1;
        rse(b_esp,n,dir) %vers�es escalonadas
    end

end

end

