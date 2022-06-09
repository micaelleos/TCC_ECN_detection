function [varargout] = extrakernels( lista,tk )
%Extrai kernels de dimensões tk X tk dos exames especificados pela lista, de acordo com suas
%máscaras. É necessário que as imagens dos exames e suas máscaras esteja
%nos diretórios .\Exames e .\Mascaras, respectivamente.
%   egg. lista = {'5961.1','9793.2'}

ni = length(lista);

dados=[];
nota=[];
n=0;
for j = 1 : ni
    %Abertura das imagens
    nomex=lista(j); 
    dirI=char(strcat('../Exames/',nomex,'.jpg'));   %exame
    dirM=char(strcat('./Mascaras/',nomex,'.jpg'));  %mascara
    [A,Am] = abririm(dirI,dirM); 
    
    %extração de kernels
    [x y]=find(Am==255);
    index = [x y];
    d=floor(tk/2);
    p=1;%padding de recorte.
    masc=zeros(size(A)); % para guardar o que já foi recortado para n ter que recortar novamente.
    m=zeros(tk+1,tk+1); %janela recortada
    coor=[];
    
    for i = 1: length(index)
       if(any(masc(index(i,1)-d:index(i,1)+d,index(i,2)-d:index(i,2)+d))==0)
       m=A(index(i,1)-d:index(i,1)+d,index(i,2)-d:index(i,2)+d);
       masc(index(i,1)-p:index(i,1)+p,index(i,2)-p:index(i,2)+p)=1; 
       coor=[coor;index(i,:)];
       n=n+1;
       
       if(nargout>0)
       dados(n).exame=char(lista(j));
       dados(n).img=uint8(m);
       dados(n).x = index(i,1);
       dados(n).y = index(i,2);
       dados(n).mascara=Am(index(i,1),index(i,2)); 
       else
       m=uint8(m);
       save(strcat('./kernels/',int2str(n),'.mat'),'m');    
       %imwrite(uint8(m),strcat('./kernels/',int2str(n),'.jpg'));
       nota = strcat(nota,int2str(n),',',char(nomex),',',int2str(index(i,1)),',',int2str(index(i,2)),'\n');
       end
       
       end
    end
    
end
    if(nargout==0)
    notaw = fopen(fullfile('./kernels/','nota.txt'),'wt');
    fprintf(notaw, nota);
    fclose(notaw);
    end
  %salvaresultado(nota,dados);
  varargout={dados};
end

