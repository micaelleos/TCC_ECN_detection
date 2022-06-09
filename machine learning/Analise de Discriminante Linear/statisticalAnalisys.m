% variance analisys

v_Jc = zeros(size(Jc,2),3);
for t = 1 : size(Jc,2)
    media=sum(sum(Jc(t).img))/(21*21);
    desvio= sum(sum(abs(Jc(t).img-media)))/sqrt(21*21);
    variancia = desvio^2;
    v_Jc(t,:)= [media desvio variancia];
end

v_Js = zeros(size(Js,2),3);
for t = 1 : size(Js,2)
    media=sum(sum(Js(t).img))/(21*21);
    desvio= sum(sum(abs(Js(t).img-media)))/sqrt(21*21);
    variancia = desvio^2;
    v_Js(t,:)= [media desvio variancia];
end
figure
subplot(1,2,1)
plot(v_Js(:,3))
title('Variancia sem')
subplot(1,2,2)
plot(v_Jc(:,3))
title('Variancia com')


figure
histogram(v_Jc(:,2),100,'Normalization','probability')
title('Distribuição de janela com P')
figure
histogram(v_Js(:,2),100,'Normalization','probability')
title('Distribuição de janela com S')