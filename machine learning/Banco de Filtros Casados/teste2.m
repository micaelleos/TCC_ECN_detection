%% Plot do histogrma da distribuição de valores máximos
for g= 1:1%4
figure
histogram(res(g).max,50);
A =res(g).img;
AM =res(g).mascara;
maximos = [res(g).x; res(g).y; res(g).max];

%% Classificador/Descritor
cp=[];
lim= 0.5:0.01:1; 
masc=zeros(size(A));
mascFP=zeros(size(A));
mascFN=zeros(size(A));
for t =1:1%length(lim)
    n=1;
    m = maximos(3,maximos(3,:)>lim(t));
    cp(t).t = [ maximos(:,maximos(3,:)>lim(t)); zeros(1,length(m))];
    
    
    for j = 1 : length(m)
        x = maximos(1,j);
        y = maximos(2,j);
        if((x+10 < size(A,1)) && (y+10 < size(A,2))...
                && (x-10 > 0) && (y-10 > 0))
            if(any(any(AM(x-10:x+10,y-10:y+10))))
                masc(x-10:x+10,y-10:y+10)=1;
                cp(t).t(4,j)=1;
                mascFP(x-10:x+10,y-10:y+10)=1;
            else
                mascFP(x-10:x+10,y-10:y+10)=1;
            end
            
        end    
    end

    cp(t).TP=sum(cp(t).t(4,:));
    cp(t).TN =0;
    
    [row,col] = find(mascFP==0);
    for i = 1:length(row)
        k = row(i);
        p = col(i);
            
            if((k+10 < size(A,1)) && (p+10 < size(A,2))...
                && (k-10 > 0) && (p-10 > 0))
                if (any(any(mascFP(k-10:k+10,p-10:p+10)))==0 && any(any(mascFN(k-10:k+10,p-10:p+10)))==0)
                    if(any(any(AM(k-10:k+10,p-10:p+10)))==0)
                        cp(t).f(1,n)=k;
                        cp(t).f(2,n)=p;
                        cp(t).TN=cp(t).TN+1;
                        n=n+1;
                        mascFN(k-10:k+10,p-10:p+10) = 1;
                    end
                end
           
        end
    end
    
%     TP = cp(t).TP;
%     FP = length(cp(t).t)- TP;
%     TN = cp(t).TN;
%     FN = length(cp(t).f) - TN;

end

end