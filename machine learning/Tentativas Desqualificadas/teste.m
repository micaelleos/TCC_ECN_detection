% Teste com manipulação de processamento de imagem para encontrar uma boa
% máscara de classificação.
ind=1
soma = res(ind).soma;
AMR = res(ind).mascara;
limiar_r = (max(max(soma))-min(min(soma))) * 0.5 + min(min(soma));

pos=soma;
pos(pos>limiar_r)=0;
pos = -1*pos;
poseq = histeq(pos);
poseq(poseq>max(max(poseq))*20) =0
poseq = 255*(poseq - min(min(poseq)))/(max(max(poseq))- min(min(poseq)));
possoma = -soma .* poseq;

pos2=soma;
pos2(pos2<limiar_r)=0;
poseq2 = histeq(pos2);
poseq2(poseq2>max(max(poseq2))*20) =0
poseq2 = 255*(poseq2 - min(min(poseq2)))/(max(max(poseq2))- min(min(poseq2)));
possoma2 = soma .* poseq2;

 IMF=imfuse(possoma2,possoma);
 figure
 colormap('gray')
 image(IMF,'CDataMapping','scaled')
 title('IMF')
 
 IMF2=imfuse(AMR,possoma);
 figure
 colormap('gray')
 image(IMF2,'CDataMapping','scaled')
 title('IMF2')
 
 figure
 colormap('gray')
 image(possoma,'CDataMapping','scaled')
 colorbar
 title('possoma')
 
 figure
 colormap('gray')
 image(pos,'CDataMapping','scaled')
 title('pos')
 
 figure
 colormap('gray')
 image(poseq,'CDataMapping','scaled')
 title('poseq')