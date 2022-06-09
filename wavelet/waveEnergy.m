function [ energy ] = waveEnergy( niveisdec )
%C�lculo do n�vel de energia de decomposi��o de subbanda wavelet
%   energy(n�vel,:)= [energyWLL ,energyWLH ,energyWHL ,energyWHH]

energy=zeros(length(niveisdec),4);

for i = 1:length(niveisdec)
   
    energy(i,1)= sum(sum((niveisdec(i).WLL)^2));
    energy(i,2)= sum(sum((niveisdec(i).WLH)^2));
    energy(i,3)= sum(sum((niveisdec(i).WHL)^2));
    energy(i,4)= sum(sum((niveisdec(i).WHH)^2));
end
end

