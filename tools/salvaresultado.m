function salvaresultado(varargin)
%Salva resultados por data. Comentário salvo em txt. Variáveis salvas
%separadamente ou workspace completo.
%   salvaresultado(nota) - salva workspace completo mais a nota em txt. Se
%   nota ='0', então não se salva nota no diretório.
%   Salva workspace completo na pasta.

argcont=length(varargin);

%pega a data
data = date;

%define os diretórios
diretorio=dir('./resultados');
arqname={diretorio(:).name};


if(any(strcmp(arqname(:),data))==0)
    dircom=strcat('./resultados/',data,'/1/');
else
    arqcont=length(dir(strcat('./resultados/',data)))-2;
    dircom=strcat('./resultados/',data,'/',int2str(arqcont+1),'/'); 
end

%cria diretório novo
mkdir(dircom);

if(varargin{1}~='0')
    nota = fopen(fullfile(dircom,'nota.txt'),'wt');
    fprintf(nota, strcat(varargin{1},'\n\r'));
    fclose(nota);
end

if(nargin>1)
   for i = 2:nargin
       eval([inputname(i),'= varargin{i};']);
       save(strcat(dircom,inputname(i)),inputname(i));
   end
else
    save(strcat(dircom,'workspace'));
end

end

