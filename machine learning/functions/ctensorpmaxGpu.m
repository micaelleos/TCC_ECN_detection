function [resL2] = ctensorpmaxGpu(resL1,Lt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

resL1=gpuArray(resL1);
limiar=0.8;
file = load(strcat('./4/tensor/',Lt,'.mat'));
tensor=gpuArray(file.tL2);
d=size(tensor); % dimensão dos filtros dos tensores
dc=1;d(1); % quantidade de filtros

di=size(resL1,2) - ceil(d(2)/2); 
dj=size(resL1,3) - ceil(d(3)/2);
resL2=zeros(dc,di,dj,'gpuArray');

%prealocção de variáveis
t=zeros(d(2),d(3),d(4),'gpuArray');
t2=zeros(d(2)*d(3)*d(4),1,'gpuArray');
sl=zeros(size(t),'gpuArray');
s2=zeros(size(t2),'gpuArray');

h = waitbar(0,strcat('Processando imagem na camada-  ',Lt));
tic
for c = 1:dc
    t=squeeze(tensor(c,:,:,:));
    t2=t(:);
    for i = 1:di-d(end-1)
        tic
        for j = 1:dj-d(end)
            sl=resL1(:,i:i+d(end-1)-1,j:j+d(end)-1);
            if(isempty(sl)~=1)
            s2=sl(:);
            resL2(c,i,j)= s2'*t2;
            end
        end
        toc
    end
    %% recorte do máximos por canal
    %vmax = zeros(size(resL2(c,:,:))); 
    %vmax(imres>max(max(resL2(c,:,:)))*limiar) = 1;
    
    %Recorte dos valores mínimos (permanece apenas os máximos)
    %resL2(c,:,:) = vmax.*resL2(c,:,:);
    
    waitbar(c/dc)
end
delete(h)
toc
%save('resL2');
end

