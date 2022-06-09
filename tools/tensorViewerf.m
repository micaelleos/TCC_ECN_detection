function [soma]=tensorViewerf(A)
% vari�vel a ser visualizada
tL=A(:,10:end-10,10:end-10);

%% visualiza��o de tensor de sa�da de camada
soma=zeros(size(tL(1,:,:)));
for j=1:size(tL,1)
    %soma=soma+abs(tL(j,:,:));
    soma=soma+tL(j,:,:);
end

soma=squeeze(soma);
%soma=-1*(soma-max(max(soma)));
%soma=squeeze(soma);
figure
colormap('gray')
image(soma,'CDataMapping','scaled')
colorbar

% [x y]=find(soma==max(max(soma)));
% hold on
% plot(y,x,'dr')
end

