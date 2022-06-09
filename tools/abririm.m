function [ varargout ] = abririm(varargin)
%Abreturas da imagem do exame e máscara
Ag = imread(varargin{1});

if length(size(Ag))==3
   A=double(rgb2gray(Ag));
else
    A=double(Ag);
end 

% if (size(A1,1) > 1000)
%    A=imresize(A1,0.75);
% else
%     A=A1;
% end

varargout{1}=A;

if(length(varargin)==2)
    Am = imread(varargin{2});

    if length(size(Am))==3
       AM=double(rgb2gray(Am));
    else
        AM=double(Am);
    end 
    
%     if (size(AM,1) > 1000)
%        AM1=imresize(AM,0.75);
%     else
%         AM1=AM;
%     end
    
    varargout{2}=AM;
end

end

