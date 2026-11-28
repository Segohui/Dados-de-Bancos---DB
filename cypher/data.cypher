// População do Grafo (similar ao schema.sql)

// Armazenamos nos nós apenas os atributos necessários para identificação 
// e filtragem no grafo. Dados como: biografia, foto_perfil_url, data_nascimento, 
// fotos, fabricante, tickets de manutenção e sugestões permanecem exclusivamente 
// no SQL.

// 1. Localizações
UNWIND [
  {nome: 'IC',   anguloX: -22.81372610472813,  anguloY: -47.06384660893944},
  {nome: 'CB',   anguloX: -22.817531128749707, anguloY: -47.06858811274335},
  {nome: 'IFGW', anguloX: -22.81749878775169,  anguloY: -47.067696591066365}
] AS row
MERGE (l:Localizacao {nome: row.nome})
SET l.anguloX = row.anguloX,
    l.anguloY = row.anguloY;

// 2. Usuários
UNWIND [
  {user_tag: 'ana',           username: 'AnaAvalia'},
  {user_tag: 'bruno',         username: 'Bru'},
  {user_tag: 'carla',         username: 'carla'},
  {user_tag: 'diego',         username: 'NaoEoDiego'},
  {user_tag: 'abobora',       username: 'Aboboras'},
  {user_tag: 'sixbancoseven', username: 'SIXS7VEN'},
  {user_tag: 'conta',         username: 'Aurelio'},
  {user_tag: 'bomDIA',        username: 'DIAbom'},
  {user_tag: 'yay',           username: 'yay :D'}
] AS row
MERGE (u:Usuario {user_tag: row.user_tag})
SET u.username = row.username;

// 3. Relacionamentos Sociais (:SEGUE)
UNWIND [
  ['ana', 'carla'],
  ['yay', 'bruno'],
  ['sixbancoseven', 'conta'],
  ['sixbancoseven', 'bomDIA'],
  ['yay', 'sixbancoseven'],
  ['yay', 'abobora'],
  ['sixbancoseven', 'yay'],
  ['carla', 'diego'],
  ['yay', 'ana'],
  ['yay', 'conta'],
  ['yay', 'bomDIA'],
  ['ana', 'diego'],
  ['bruno', 'ana'],
  ['ana', 'bruno'],
  ['sixbancoseven', 'abobora'],
  ['bruno', 'sixbancoseven'],
  ['sixbancoseven', 'bruno'],
  ['ana', 'sixbancoseven'],
  ['carla', 'sixbancoseven'],
  ['conta', 'sixbancoseven'],
  ['sixbancoseven', 'carla'],
  ['yay', 'carla'],
  ['yay', 'diego'],
  ['diego', 'sixbancoseven'],
  ['bomDIA', 'sixbancoseven']
] AS par
MATCH (u1:Usuario {user_tag: par[0]})
MATCH (u2:Usuario {user_tag: par[1]})
MERGE (u1)-[:SEGUE]->(u2);

// 4. Tags
UNWIND [
  'possui encosto',
  'possui braço',
  'acolchoado',
  'individual',
  'social',
  'poltrona',
  'material: madeira',
  'material: metal',
  'material: pedra',
  'material: plástico',
  'dá para deitar',
  'acompanha uma mesa',
  'carteira',
  'em interior',
  'ar livre',
  'air fryer acoplada'
] AS nome_tag
MERGE (:Tag {nome: nome_tag});

// 5. Assentos e Localização (:FICA_EM)
UNWIND [
  {id: 1,  data: '2026-10-01', estado: 'existe',     local: 'IC'},
  {id: 2,  data: '2026-09-01', estado: 'existe',     local: 'IC'},
  {id: 3,  data: '2026-08-01', estado: 'existe',     local: 'IC'},
  {id: 4,  data: '2026-07-01', estado: 'existe',     local: 'IC'},
  {id: 5,  data: '2026-06-01', estado: 'existe',     local: 'IC'},
  {id: 6,  data: '2026-05-01', estado: 'quebrado',   local: 'IC'},
  {id: 7,  data: '2026-04-01', estado: 'existe',     local: 'IFGW'},
  {id: 8,  data: '2026-03-01', estado: 'existe',     local: 'IFGW'},
  {id: 9,  data: '2026-02-01', estado: 'existe',     local: 'CB'},
  {id: 10, data: '2026-01-02', estado: 'existe',     local: 'CB'},
  {id: 11, data: '2026-01-01', estado: 'existe',     local: 'CB'},
  {id: 12, data: '2026-01-01', estado: 'nao existe', local: 'CB'}
] AS row
MERGE (a:Assento {id: row.id})
SET a.data_publicacao = date(row.data),
    a.estado = row.estado
WITH a, row
MATCH (l:Localizacao {nome: row.local})
MERGE (a)-[:FICA_EM]->(l);

// 6. Características dos Assentos (:TEM_TAG)
UNWIND [
  {id: 1,  tags: ['social', 'material: pedra', 'dá para deitar', 'acompanha uma mesa', 'ar livre']},
  {id: 2,  tags: ['possui encosto', 'acolchoado', 'social', 'dá para deitar', 'em interior']},
  {id: 3,  tags: ['possui encosto', 'individual', 'material: plástico', 'acompanha uma mesa', 'carteira', 'em interior']},
  {id: 4,  tags: ['individual', 'em interior']},
  {id: 5,  tags: ['possui encosto', 'possui braço', 'acolchoado', 'individual', 'em interior']},
  {id: 6,  tags: ['social', 'material: pedra', 'dá para deitar', 'ar livre']},
  {id: 7,  tags: ['social', 'acompanha uma mesa', 'ar livre']},
  {id: 8,  tags: ['social', 'material: pedra', 'dá para deitar', 'ar livre']},
  {id: 9,  tags: ['social', 'material: pedra', 'acompanha uma mesa', 'ar livre']},
  {id: 10, tags: ['social', 'material: pedra', 'dá para deitar', 'acompanha uma mesa', 'ar livre']},
  {id: 11, tags: ['social', 'material: pedra', 'dá para deitar', 'ar livre']},
  {id: 12, tags: ['social', 'material: pedra', 'dá para deitar', 'ar livre']}
] AS row
MATCH (a:Assento {id: row.id})
UNWIND row.tags AS nome_tag
MATCH (t:Tag {nome: nome_tag})
MERGE (a)-[:TEM_TAG]->(t);

// 7. Avaliações (:AVALIOU com propriedades na aresta)
UNWIND [
  {user: 'ana',           assento: 1,  nota: 5, data: '2026-10-02', comentario: 'Sombra o dia todo, ótimo para ler'},
  {user: 'ana',           assento: 6,  nota: 3, data: '2026-09-10', comentario: 'Ok, mas fica perto do barulho'},
  {user: 'ana',           assento: 7,  nota: 4, data: '2026-04-12', comentario: null},
  {user: 'bruno',         assento: 1,  nota: 4, data: '2026-10-05', comentario: 'Bom, só falta uma tomada'},
  {user: 'bruno',         assento: 3,  nota: 2, data: '2026-08-15', comentario: 'Dói quando eu sento'},
  {user: 'bruno',         assento: 12, nota: 1, data: '2026-01-20', comentario: 'Quebrado, não dá para sentar'},
  {user: 'carla',         assento: 1,  nota: 5, data: '2026-10-10', comentario: null},
  {user: 'carla',         assento: 8,  nota: 4, data: '2026-05-18', comentario: 'Tranquilo à tarde'},
  {user: 'carla',         assento: 9,  nota: 3, data: '2026-02-25', comentario: null},
  {user: 'sixbancoseven', assento: 4,  nota: 4, data: '2026-07-21', comentario: null},
  {user: 'sixbancoseven', assento: 11, nota: 5, data: '2026-01-14', comentario: 'Melhor do CB'},
  {user: 'sixbancoseven', assento: 12, nota: 2, data: '2026-06-30', comentario: 'Bate sol forte'}
] AS row
MATCH (u:Usuario {user_tag: row.user})
MATCH (a:Assento {id: row.assento})
MERGE (u)-[r:AVALIOU]->(a)
SET r.nota = row.nota,
    r.data_avaliacao = date(row.data),
    r.comentario = row.comentario;

MATCH (cb:Localizacao {nome: 'CB'})
WITH cb
MATCH (ifgw:Localizacao {nome: 'IFGW'})
MERGE (cb)-[r1:PERTO_DE]->(ifgw)
  SET r1.metros = 250, r1.caminhada_min = 3;