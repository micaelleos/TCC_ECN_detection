function rse(b,l,dir)
%Função que cria versões escalonadas da imagem "b"
%no diretório "dir".
    b_rse1= imresize(b,0.75);
    b_rse1= imresize(b_rse1,[21,21]);
    imwrite(uint8(b_rse1),strcat(dir,int2str(l),...
        '_','b_rse1_.tif'));
    
    b_rse2= imresize(b, 0.5);
    b_rse2= imresize(b_rse2, [21,21]);
    imwrite(uint8(b_rse2),strcat(dir,int2str(l),...
        '_','b_rse2_.tif'));
    
    b_rse3= imresize(b, 1.25);
    a= ceil((length(b_rse3) - length(b))/2): ...
        length(b_rse3) - floor((length(b_rse3)...
        - length(b))/2) -1;  
    b_rse3= b_rse3(a,a); 
    imwrite(uint8( b_rse3),strcat(dir,int2str(l),...
        '_','b_rse3_.tif'));
    
    b_rse4= imresize(b, 1.5);
    c= ceil((length(b_rse4) - length(b))/2): ...
        length(b_rse4) - floor((length(b_rse4)...
        - length(b))/2) -1; 
    b_rse4= b_rse4(c,c);
    imwrite(uint8(b_rse4),strcat(dir,int2str(l),...
        '_','b_rse4_.tif'));
end

