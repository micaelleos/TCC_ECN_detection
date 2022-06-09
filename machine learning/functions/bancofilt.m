function [ J,coor ] = bancofilt( A ,d )
%UNTITLED2 Summary of this function goes here
%   Esta função abre os kernels presentes nas subpastas da pasta "pk"

pk = './kernels'; %string

arquivos = dir(pk);
imres=zeros(size(A));
J=zeros(size(A));

%mapeamento de máximos
x=0;
y=0;
coor=[];
h = waitbar(0,'Processando base...');

for s=1:length(arquivos)-3 %abrir pastas
    arquivos(s+2).name
    kernelsaqr = dir(strcat(pk,'/',arquivos(s+2).name));
    n=3;%length(kernelsaqr)-2;
for i = 1:n % abrir arquivos dentro das pastas

    kernel=double(imread(strcat(pk,'/',arquivos(s+2).name,'/',kernelsaqr(i+2).name)));
    kernelds  = downsample( kernel, d );  %teste com redução de dimensão.
    %kernelds  = multiescala(kernelds, d);
    tic
%   Filtro Casado
    imres = filtrocasado( A, kernelds );
    toc
    [x y] = find(imres == max(max(imres)));
    coor=[coor; x y];
    waitbar(i / n)
end

end
close(h) 
end

