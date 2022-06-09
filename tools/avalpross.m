function [ esp , sen, acc, pre, FP, FN, TP, TN ] = avalpross(tipo, varargin)
% Análise de resultado com especificidade, sensibilidade, accuracy e
% precision.
%   tipo = 0 -> divisão de conjunto de dados. Varargin = val,tre. tipo = 1 -> uso da máscara para determinar resultado. varargin = maximos e AM 

FP=0; %falso positivo
TP=0; %verdadeiro positivo
FN=0; %falso negativo
TN=0; %verdadeiro negativo
error = 0; % pontos marcados fora da etensão da imagem.

n=5; % tamanho da janela 
if(tipo=='0')
    res = varargin{1};
    val = varargin{2};
    c=0;%??
    for i = 1 : length(val)
        if(any(strcmpi(res(:).exame,val(i).exame)))

        c=find(strcmpi(res(:).exame,val(i).exame));

        if(any(ismember([res(:).x],[val(i).x-n:val(i).x+n]))...
           && any(ismember([res(:).y],[val(i).y-n:val(i).y+n])))
            TP=TP+1;
            %FP = [FP ; val(i).x val(i).y]
        else 
            FP=FP+1;
        end

        end
    end

elseif(tipo == '1')
    maximos = varargin{1};
    AM = varargin{2};
    mascara = zeros(size(AM));
    mascara2=ones(size(AM));
    [y,x]=find(AM==255);
    
    for j = 1 : length(maximos)
        % se AM(maximos) = 1, correto
        if(maximos(j,1)>n && maximos(j,2)>n && maximos(j,1)<size(AM,1) && maximos(j,2)<size(AM,2))
            j
            if(all(AM(maximos(j,1),maximos(j,2))))
            TP = TP + 1;
            else
            FP = FP + 1;   
            end
            
            for k = 1 : length(x)
                k
                janela = [x(k)-n:x(k)+n ; y(k)-n:y(k)+n];
                if (any(any(mascara(janela(1,:),janela(2,:))))==0)
                    if(all(find(ismember(janela(1,:),maximos(j,1))) == find(ismember(janela(2,:),maximos(j,2)))))
                    FN = FN + 1;
                    mascara(janela(1,:),janela(2,:))=1;
                    end
                end
                mascara2(janela(1,:),janela(2,:))=0;
            end
            
            mascara2(maximos(j,1)-n:maximos(j,1)+n,maximos(j,2)-n:maximos(j,2)+n)=0;
        else
            error = error + 1 ;
        end       
    end
    TN=sum(sum(mascara2))-sum(sum(mascara2))/(2*n);
    dados = length(maximos)-error;
    
elseif(tipo == '2')
    res = varargin{1};
    AM = varargin{2};
    
    TP = sum(sum(and(res,AM)));
    TN = sum(sum(and(not(res),not(AM))));
    FP = sum(sum(and(not(AM),res)));
    FN = sum(sum(and(not(res),AM)));
    
elseif(tipo =='3')
    maximos = varargin{1};
    AM = varargin{2};
    erro=0;
    for j = 1:length(maximos)
       
        cx=maximos(1,j);
        cy=maximos(2,j);
        if((cx+n < size(AM,1))&&(cy+n < size(AM,2))&&(cx-n > 0 )&&(cy-n > 0))
            if(any(AM(cx-n:cx+n,cy-n:cy+n))==1)
            TP = TP+1;
            else
            FP = FP+1;
            end
            
        else
           erro=erro+1; 
        end
        
    end
    FP=FP+erro;
end
 esp=TN/(TN +FP);
 sen=TP/(TP + FN);
 acc=TP/(size(AM,1)*size(AM,2));
 pre=TP/(FP+TP);
 
end

