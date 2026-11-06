# Interfaces

## Interface 1: Página de Usuário
![pagina usuario](https://gitlab.ic.unicamp.br/ra322985/mc536-2026-2s-projeto-d/-/blob/master/03-consultas/Vers%C3%B5es%20polidas%20das%20interfaces/tela_usuario_polida.jpeg)

### Explicação

  Na parte superior da página se encontra as informações esperadas do usuário, sendo elas seu nome, foto de perfil, bio, numero de seguidores e numero de quantas pessoas estão seguindo ele. Alem disso, tambêm esta presente um botão que possibilita o usuário customizar suas informações

  Abaixo, se encontra uma sequencia das ultimas avaliações feitas pelo usuário, ordenadas em ordem de criação por uma query trivial.

  À direita das avaliações recentes, se encontra uma tabela demonstrando as estatísticas do usuário referente à suas avaliações no site, mostrando o número total de bancos juntamente com o total de bancos avaliados no ultimo ano, sendo obtido novamente por uma query trivial.
  Abaixo aparece um gráfico demonstrando a distribuição de avaliações do usuário, abrangindo de 1 a 5 estrelas, junto com a média dele.

### Relevância
  Para qualquer site com função de ser uma rede social que se preza necessita de uma págia de usuário, onde seja possivel criar uma presença tangível no app. 
  
  A escolha de demonstrar de forma clara e processada as avaliações que um usuário tenha feito é vital para um outro usuário qualquer seja capaz de ter uma ideia da forma que o avaliador escolhe avaliar os bancos juntamente com o quão crítico ele é em suas avaliações.


## Interface 2: Tela para Moderadores
![(Moderação)](https://gitlab.ic.unicamp.br/ra322985/mc536-2026-2s-projeto-d/-/blob/master/03-consultas/Vers%C3%B5es%20polidas%20das%20interfaces/Moderacao_polida.pdf)

### Explicação
  A tela possui duas seções principais, uma que mostra os tickets (manutenções ou sugestões), e a outra que define o filtro para quais aparecem. O filtro pode filtrar tickets por estado (**pendente**, **aprovada**, **rejeitada**), por tag de usuário, pelo tipo (**existe**, **não existe**, **quebrado**, **inacessivel**) e pela data de envio (seleciona todos depois de uma data minima).

### Relevância
  Essa tela é utilizada para o moderador ter acesso aos tickets, sendo importantes para a vericidade dos dados no banco de dados, que são inerentes à mudanças no mundo real. Além disso, os tickets um sentimento de comunidade com a ajuda dos usuários.


## Interface 3: Em alta (query da página principal)
![Bancos em alta](https://gitlab.ic.unicamp.br/ra322985/mc536-2026-2s-projeto-d/-/blob/master/03-consultas/Vers%C3%B5es%20polidas%20das%20interfaces/tela_principal_polida.jpeg)

### Explicação
  Um dos módulos da página principal é "Bancos em alta", que destaca os assentos mais relevantes do momento com base no volume de avaliações recentes (o que pode indicar bancos novos, mudanças relevantes etc.). Os três bancos com maior número de novas menções são exibidos em cards na interface, contendo suas informações e um comentário de destaque.

  A query seleciona os 3 bancos que mais receberam avaliações recentemente. Ela começa pegando as 50 últimas avaliações do sistema (número arbitrário que deve ser uma boa amostra) e conta quantas delas pertencem a cada banco, considerando apenas bancos que existem ("nao existe" ou "quebrado" não entram). Em seguida, calcula a nota média de cada banco (considerando todas as suas avaliações, não só as recentes), busca a foto principal, agrupa as tags descritivas e recupera o comentário e o autor mais recentes (informações exibidas na UI). O resultado final é ordenado do mais avaliado para o menos avaliado, com desempate pela maior nota média.

### Relevância
  Essa funcionalidade apresenta bancos de interesse por um caminho alternativo à localização geográfica, destacando locais que provavelmente vêm despertando a atenção da comunidade recentemente e que, por isso, tendem a ser mais relevantes no momento. Além disso, a seção atua como incentivo direto ao engajamento, o que fomenta a coleta de dados.

## Interface 4: Tela de Ranking
![Ranking](https://gitlab.ic.unicamp.br/ra322985/mc536-2026-2s-projeto-d/-/blob/master/03-consultas/Vers%C3%B5es%20polidas%20das%20interfaces/ranking_polida.pdf)

### Explicação
  A tela mostra o ranking dos bancos em uma lista paginada, com a posição, a foto, o local, as principais tags, a nota média e o número de avaliações de cada banco. Ao lado, um painel de filtros permite filtrar por local, avaliação mínima e tags, e outro painel de "Ordenar por" aceita uma ou mais métricas: nota geral, idade, conforto e acessibilidade.

  A query junta os assentos às suas avaliações, considerando apenas bancos que existem (nao mostrando os bancos com "nao existe" e "quebrado"), agrupa por banco e calcula a nota média e o número de avaliações. A foto de capa vem de uma subconsulta (decidi pegar a menor foto), já que um banco pode ter várias fotos. Como o banco de dados não tem colunas de conforto e acessibilidade, elas são calculadas por subconsultas: o conforto é a quantidade de tags de conforto do banco, e a acessibilidade é a quantidade de tickets de manutenção "inacessivel" já aprovados por um moderador. Os filtros entram no WHERE (local e tag) e no HAVING (avaliação mínima), a ordenação é feita pelo ORDER BY (por padrão, a nota média) e a paginação usa LIMIT e OFFSET. As principais tags de cada banco vêm de uma segunda consulta simples.

### Relevância
  O ranking permite comparar os bancos e encontrar os melhores sem depender da localização no mapa. Os filtros e as métricas de ordenação deixam cada usuário escolher o que mais importa, como conforto, acessibilidade ou apenas a nota. A tela também incentiva o engajamento, já que avaliar e reportar problemas influencia a posição dos bancos.



## Interface 5: Tela do Assento
![Tela do Assento](https://gitlab.ic.unicamp.br/ra322985/mc536-2026-2s-projeto-d/-/blob/master/03-consultas/Vers%C3%B5es%20polidas%20das%20interfaces/tela_banco_polida.png)

### Explicação
  A tela do assento mostra todas as informações coletadas sobre um dado banco, assim como permite que usuários deixem avaliações sobre o banco e vejam avaliações de outros usuários. São mostrados, também, dados agregados sobre o quão bem avaliado foi o banco. Em específico, para esse design e para a consulta, focamos no histograma das avaliações (pois as outras consultas relacionadas a obter informações e avaliações seriam mais triviais). O histograma mostra quantas avaliações de cada nota o banco possui (nota 1, 2, 3, 4 ou 5). A consulta feita obtém, de modo geral, os histogramas de todos os bancos, e para filtrar por um banco específico basta adicionar um WHERE especificando o id do banco de interesse.

### Relevância
  A tela do assento é o coração do site Dados de Bancos. É nela que são fornecidas as informações sobre qualquer banco e onde usuários podem tomar conhecimento de um banco e obter/fornecer informações sobre suas características e sua qualidade. Para quem está navegando, o histograma é muito conveniente para dar uma ideia geral de como foram os ratings que certo banco recebeu logo ao entrar na página, sendo muito útil e informativo na experiência de avaliação de bancos.
