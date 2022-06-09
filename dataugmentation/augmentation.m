function augmentation( varargin )
% Data augmentation
% aumentando a quantidade de kernels
    
if(nargin>0)
    dados_tre = varargin{1};
    n = length(dados_tre);
else
    nomedir='kernels'; 
    arquivos = dir(strcat('./',nomedir)); %diretório das bases
    n = length(arquivos)-3;
end

for l = 1: n
%     if(nargin>0)
%     b=double(dados_tre(l).img);
%     else
%     arq=load(strcat('./',nomedir,'/',arquivos(3).name));
%     b=double(arq.m);
%     %b2=double(imread(strcat('./',nomedir,'/',arquivos(3).name)));
%     end
    
    b=double(dados_tre(l).img);

    imwrite(uint8(b),strcat('./dataaug/',int2str(l),'.tif'));
    rse(b,n)
    
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat('./dataaug/',int2str(l),'_','esp_.tif'));
    
    n=n+1;
    rse(b_esp,n)
    
    %% Rotação
    for j = 1:3
    b=rot90(b);
    imwrite(uint8(b),strcat('./dataaug/',int2str(l),'_','rot_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b,n)
  
    b_esp= flip(b,1);
    imwrite(uint8(b_esp),strcat('./dataaug/',int2str(l),'_','esp_',int2str(j),'.tif'));
    
    n=n+1;
    rse(b_esp,n)
    end
    
end

end

