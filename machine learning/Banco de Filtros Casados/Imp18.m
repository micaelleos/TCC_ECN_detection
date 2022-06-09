%% Implementa��o 18
% 
clear;clc;close all;
%% Extra��o dos kernels 

lista = {'6355','5961.1','9794.1','9793.2'};
res=[];

for ind =1:4  % processamento de todas as imagens do banco
vart=1:length(lista); % para exclus�o da imagem que est� sendo processada das janelas de refer�ncia
dados = extrakernels(lista(vart(vart~=ind)),20); % extrai automaticamente os kernels de acordo com suas respectivas m�scaras.

%% Data augmentation
delete('./dataaug/*') % limpa a pasta
augmentation( dados ) % faz data augmentation dos kernesl recortados em "extrakernels" e salva na pasta ./dataaug
clear dados; % limpa vari�vel porque � muito grande

%% Processamento

% Abertura das imagens
tic
nomex=char(lista(ind)); 
dirI=strcat('./Testes/Exames/',nomex,'.jpg');   %exame
dirM=strcat('./Testes/Mascaras/',nomex,'.jpg');  %mascara
[A,AM] = abririm(dirI,dirM);

%% Banco de Filtros 

%layer 1
[maximos] = bancofiltcgpu(A,0,'dataaug');

%Guardar resultado
res(ind).x = maximos(1,:);
res(ind).y = maximos(2,:);
res(ind).exame = lista(ind);
res(ind).max = maximos(3,:);
%res(ind).soma=soma;
res(ind).mascara=AM;
res(ind).img = A;


end

%% Plot do histogrma da distribui��o de valores m�ximos

lim= 0.5:0.005:1; % faixa de varia��o do limiar
for g= 1:4
figure
histogram(res(g).max,50,'Normalization','probability');
title(res(g).exame)

%Inicializa��o de vari�veis
A =res(g).img;
AM =res(g).mascara;
maximos = [res(g).x; res(g).y; res(g).max];
v_tp=[];
v_fp=[];
v_tn=[];
v_fn=[];
cp=[];
J=zeros(size(lim,1));
%% Avalia��o de limiar

for t =1:length(lim)
    mascTP=zeros(size(A)); % m�scara de verdadeiros positivos
    mascP=zeros(size(A)); % m�scara de positivos
    mascN=zeros(size(A)); % m�scara de negativos
    
    ind=find(lim(t)-0.005<maximos(3,:) & lim(t)+0.005>maximos(3,:));
    m = maximos(1:3,ind); % m�ximos ap�s limiar
    

    %c�lculo de positivos
    cp(t).TP = 0;
    for j = 1 : size(m,2)
        x = m(1,j);
        y = m(2,j);
        if((x+10 < size(A,1)) && (y+10 < size(A,2))...
                && (x-10 > 0) && (y-10 > 0))
            if(any(any(AM(x-10:x+10,y-10:y+10))))
                mascTP(x-10:x+10,y-10:y+10)=1;
                cp(t).t(1:2,j) = [x  y];
                cp(t).TP=cp(t).TP+1;
            end
           mascP(x-10:x+10,y-10:y+10)=1; 
        end         
    end

    
    
    
    %c�lculo de negativos
    cp(t).TN =0;
    cp(t).N =0;
    n=1;
    [row,col] = find(mascP==0); % pega a localiza��o de negativos
    for i = 1:length(row)
        k = row(i);
        p = col(i);
            if((k+10 < size(A,1)) && (p+10 < size(A,2))...
                && (k-10 > 0) && (p-10 > 0))
                if (any(any(mascP(k-10:k+10,p-10:p+10)))==0 && any(any(mascN(k-10:k+10,p-10:p+10)))==0)
                    cp(t).N=cp(t).N+1;
                    if(any(any(AM(k-10:k+10,p-10:p+10)))==0)
                        cp(t).f(1,n)=k;
                        cp(t).f(2,n)=p;
                        cp(t).TN=cp(t).TN+1;
                        n=n+1;
                        mascN(k-10:k+10,p-10:p+10) = 1;
                    end
                end           
        end
    end
    
    TP = cp(t).TP;
    FP = length(m)- TP;
    TN = cp(t).TN;
    FN = cp(t).N - TN;
    J(t) = FP/(FP+TP)+FN/(FN + TN);
    
    v_tp=[v_tp TP];
    v_fp=[v_fp FP];
    v_tn=[v_tn TN];
    v_fn=[v_fn FN];
    
%     IMF=imfuse(mascP,A);
%     figure(g)
%     clf
%     colormap('gray')
%     image(IMF,'CDataMapping','scaled')
%     hold on
%     plot(m(2,:),m(1,:),'r.')
%     hold off
%     pause(0.05)

    
end
    res(g).J=J;
    res(g).TP=v_tp;
    res(g).FP=v_fp;
    res(g).TN=v_tn;
    res(g).FN=v_fn;
  
    figure
    plot(lim(1:length(J)),J)
    title(res(g).exame)
    ylabel('Custo')
    xlabel('Limiar')
end
g=4
res(g).TP(73)
res(g).FP(73)
res(g).TN(73)
res(g).FN(73)


%% M�tricas

for h=1:4
    
   res(h).esp=res(h).TN(:)./(res(h).TN(:)+res(h).FP(:));
   res(h).sen=res(h).TP(:)./(res(h).TP(:)+res(h).FN(:));
   res(h).acc=(res(h).TP(:)+res(h).TN(:))./(res(h).TP(:)+res(h).FP(:)+res(h).TN(:)+res(h).FN(:));
   res(h).prec=res(h).TP(:)./(res(h).TP(:)+res(h).FP(:));
    
   roc=ones(size(res(h).esp))-res(h).esp(:);
   figure
   plot(res(h).sen,roc,'.')
end
