-- Bancos em alta (parte unica da tela inicial)
-- Os 3 bancos com mais avaliações entre as 50 mais recentes do sistema
WITH AvaliacoesRecentes AS (
    -- "recente" foi arbritariamente decidido para ser as 50 últimas avaliações
    SELECT id_assento
    FROM avalia
    ORDER BY data_avaliacao DESC
    LIMIT 50
),

-- média de todas as avaliações do banco (para as estrelas do card)
NotaMedia AS (
    SELECT id_assento, ROUND(AVG(nota), 1) AS nota_media
    FROM avalia
    GROUP BY id_assento
),

-- um banco pode ter várias fotos então pega só uma
FotoBanco AS (
    SELECT id_assento, MIN(file_path) AS foto
    FROM foto
    GROUP BY id_assento
),

-- tags do banco juntas num texto só para o card
TagsBanco AS (
    SELECT descreve.id_assento, GROUP_CONCAT(tag.nome, ', ') AS tags
    FROM descreve
    JOIN tag ON tag.id = descreve.id_tag
    GROUP BY descreve.id_assento
),

-- quantas das avaliações recentes são de cada banco (só bancos que existem)
BancosEmAlta AS (
    SELECT assento.id, assento.nome_localizacao AS nome_local, COUNT(*) AS qtd_avaliacoes
    FROM AvaliacoesRecentes
    JOIN assento ON assento.id = AvaliacoesRecentes.id_assento
    WHERE assento.estado = 'existe'
    GROUP BY assento.id
)
SELECT BancosEmAlta.id,
       BancosEmAlta.nome_local,
       FotoBanco.foto,
       NotaMedia.nota_media,
       TagsBanco.tags,
       usuario.user_tag,
       avalia.comentario
FROM BancosEmAlta
JOIN NotaMedia ON NotaMedia.id_assento = BancosEmAlta.id
-- LEFT JOIN para o card aparece mesmo sem foto, tags ou comentário
LEFT JOIN FotoBanco ON FotoBanco.id_assento = BancosEmAlta.id
LEFT JOIN TagsBanco ON TagsBanco.id_assento = BancosEmAlta.id
-- comentário de destaque: o mais recente do banco (ignora avaliações sem comentário)
LEFT JOIN avalia ON avalia.id_assento = BancosEmAlta.id
    AND avalia.data_avaliacao = (
        SELECT MAX(data_avaliacao)
        FROM avalia
        WHERE id_assento = BancosEmAlta.id
    )
LEFT JOIN usuario ON usuario.user_tag = avalia.user_tag
-- mais avaliados primeiro e em caso de empate vai pela melhor nota
ORDER BY BancosEmAlta.qtd_avaliacoes DESC, NotaMedia.nota_media DESC
LIMIT 3;