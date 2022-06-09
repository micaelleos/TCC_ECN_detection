function [resL2] = ctensorpmax(resL1,Lt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

limiar=0.8;
file = load(strcat('./4/tensor/',Lt,'.mat'));
tensor=file.tL2;
d=size(tensor); % dimensão dos filtros dos tensores
dc=d(1); % quantidade de filtros

di=size(resL1,2) - ceil(size(tensor,2)/2); 
dj=size(resL1,3) - ceil(size(tensor,3)/2);
resL2=zeros(dc,di,dj);

h = waitbar(0,strcat('Processando imagem na camada-  ',Lt));
tic
for c = 1:dc
    for i = 1:di-d(end-1)
        for j = 1:dj-d(end)
            sl=resL1(:,i:i+d(end-1)-1,j:j+d(end)-1);
            if(any(any(sl))~=0)
            resL2(c,i,j)= sum(sum(sum(sl.*squeeze(tensor(c,:,:,:)))));
            end
        end
    end
    %% recorte do máximos por canal
    %vmax = zeros(size(resL2(c,:,:))); 
    %vmax(imres>max(max(resL2(c,:,:)))*limiar) = 1;
    
    %Recorte dos valores mínimos (permanece apenas os máximos)
    %resL2(c,:,:) = vmax.*resL2(c,:,:);
    
    %waitbar(c/dc)
end
delete(h)
toc
save('resL2');
end

