%% Probabilidade associada a cada píxel pertencente à uma janela de uma classe específica
v_Jc=[];
for t = 1 : size(Jc,2)
v_Jc= [v_Jc; Jc(t).img(:)];
end

v_Js_z=[];
for t = 1 : size(Js,2)
v_Js_z= [v_Js_z; Js(t).img(:)];
end

v_Js = v_Js_z(find(v_Js_z>1));

v_Jt = [v_Js;v_Jc ];

v_Jc=[];
for t = 1 : size(Jc,2)
v_Jc= [v_Jc; Jc(t).img(:)];
end

media=sum(sum(v_Jc))/size(v_Jc,1)
desvio= sum(sum(abs(v_Jc-media)))/size(v_Jc,1)
variancia = desvio^2

media2=sum(sum(v_Js))/size(v_Js,1)
desvio2= sum(sum(abs(v_Js-media2)))/size(v_Js,1)
variancia2 = desvio2^2

figure
histogram(v_Jc,200,'Normalization','probability')
title('Distribuição de janela com P')

figure
histogram(v_Js,200,'Normalization','probability')
title('Distribuição de janela sem P')

figure
histogram(v_Jt,200,'Normalization','probability')
title('Distribuição Total')