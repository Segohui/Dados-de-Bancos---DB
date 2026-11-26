// Constrains funcionam similarmente às PRIMARY KEYs do SQL, craindo 
// índices que aceleram a busca de nós iniciais em consultas

CREATE CONSTRAINT usuario_tag_unique IF NOT EXISTS
FOR (u:Usuario) REQUIRE u.user_tag IS UNIQUE;

CREATE CONSTRAINT assento_id_unique IF NOT EXISTS
FOR (a:Assento) REQUIRE a.id IS UNIQUE;

CREATE CONSTRAINT localizacao_nome_unique IF NOT EXISTS
FOR (l:Localizacao) REQUIRE l.nome IS UNIQUE;

CREATE CONSTRAINT tag_nome_unique IF NOT EXISTS
FOR (t:Tag) REQUIRE t.nome IS UNIQUE;