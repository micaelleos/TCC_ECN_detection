# Reconhecimento de Padõres de Enterocolite Necrosante

Neste repostirório encontra-se as implementações dos experimentos do trabalho de conclusão de curso com título: Reconhecimento de Padrões de Pneumatose Intestinal para o Diagnóstico Radiológico de Enterocolite Necrosante. O texto da monografia, com mais informações encontra-se na pasta \doc. 

O intúito desse trabalho foi o desenvolvimento de um estudo comparativo de métodos de classificação para detecção de Enterocolite Necrosante em radiografias, visando o desenvolvimento de um sistema de Diagnóstico Assistido por Computador (CAD), para ser usado por médicos na Maternidade Nossa Senhora de Lourdes - MNSL, em Aracaju - SE.

Neste repositório você vai encontrar:

  - Implementações de métodos de machine learning: Análise de discriminante linear, banco de filtros casados, redes neurais artificiais, redes neurais convolutivas.
  - Implementação de métodos de redução dimensional como: Discriminante Linear de Fisher, PCA.
  - Processamento de imagens: manipulações de histograma, remoção de fundo, recorte de regiões de interesse.
  - Algoritmos de aumento de dados.
  - Métodos de amostragem de dados: holdout e validação cruzada.
  - Implementação de métodos de avaliação de comparação de peformance de classificadores.

A grande maioria dos algoritmos foram escritos em Matlab (C), mas alguns outros foram escritos em Python.
 
## Sobre a Enterocolite Necrosante (ECN)
A Enterocolite Necrosante (ECN) é uma doença inﬂamatória intestinal, e é considerada uma das piores emergências gastrointestinais em UTI's neonatais. Um diagnóstico rápido e preciso é imprescindível para aumentar as chances de sobrevida do paciente. A principal ferramenta utilizada para esse propósito são os exames de imagem abdominais.

Dentre as modalidades de exames de imagem, a radiografa plana é a mais utilizada para o diagnóstico de ECN. Entretanto, há uma certa difculdade em reconhecer os  padrões de imagem da doença, por conta da sutileza de seus marcadores radiológicos, o que faz com que haja pouca concordância entre especialistas, na avaliação de um mesmo exame. Em vista disso, o diagnóstico assistido por computador poderia ser uma importante ferramenta para auxiliar especialistas.

<p align="center">
  <img src="https://github.com/micaelleos/TCC_ECN_detection/blob/main/res/cad.png" width="100" title="hover text">
</p>

## Base de Dados
Para a detecção da doença, um marcador radiológico conhecido como Pneumatose intestinal foi selecionado para fazer o diagnóstico da doença, por se tratar de um marcador quase específico. 

A base de dados desenvolvida no trabalho de conclusão de curso por ser encontrada no link: 

No arquivo do site há duas bases de dados, uma com amostragem por holdout e outra com amostras organizadas para ser feito a validação crusada dos dados. Ao todo são 32.340 amostras de imagens sem e com PI. Para a construção dessas bases técnicas de aumentdo de dados foram implementados, já que a disponibilidade de exames com PI eram muito pequenos.
