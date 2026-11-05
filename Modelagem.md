## Escolha SGBD

O SGBD escolhido foi o SQLlite. O principal motivo para a escolha é a simplicidade do uso. Utilizamos o gitgub para sincronizar mudanças de todos os membros por um arquivo.sql, com cada um podendo criar um .db localmente com o sqlite3.

## Modelagem Lógica
![diagrama banco de dados](https://raw.githubusercontent.com/Segohui/Dados-de-Bancos---DB/e48dfebc475c50a8aab48bb0ea47245343a5d79f/diagram.drawio.svg)


## Justificativa para Decisões de Modelagem e Implementação
### Usuário
  Para a criação da TABLE de usuário, escolhemos dedicar ao espaço referente á foto de perfil como um VARCHAR, onde apenas se guardaria o nome do arquivo da imagen, permitindo que no momento de busca para obter a foto seja obtido chamando diretamente ela pelo diretório. A forma seria semelhante à : "/dadosdebanco/imagensUser/"**usuario.foto_perfil_url**".
  
  Alem disso, fizemos a escolha de armazenar no próprio usuário os numeros referentes a cada rate que o usuário deu para cada banco avaliado, permitindo maior controle dos dados individuais, e usar eles para obter o numero de avaliações junto com a média da avaliação usando eles, sem necessitar de duas consultas extras para cada.
