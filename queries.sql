-- Tela de Tickets para Moderadores

WITH TicketsModeracao AS (
    SELECT 
        'Manutenção' AS categoria,
        id_manutencao AS id_ticket,
        tipo_manutencao AS tipo,
        estado,
        data_de_envio,
        user_tag
    FROM manutencao
    
    UNION ALL
    
    SELECT 
        'Sugestão' AS categoria,
        id_sugestao AS id_ticket,
        'Novo Assento' AS tipo, -- Segestão nao tem tipo
        estado,
        data_de_envio,
        user_tag
    FROM sugestao
)
SELECT * 
FROM TicketsModeracao
WHERE estado = 'pendente' 
    -- Filtros: o moderador pode escolher o filtro da tabela de tickets. Tire o '--' para ver a tabela com filtros
    -- AND user_tag = 'bomDIA'
    -- AND categoria = 'Manutenção'                 
    -- AND tipo = 'inacessivel'                      
    -- AND data_de_envio >= '2026-08-01'            
ORDER BY data_de_envio ASC;






WITH BancosRegiao AS (
    SELECT *
    FROM localizacao
    WHERE localizacao.anguloX >= Xmin AND localizacao.anguloX <= Xmax AND localizacao.anguloY >= Ymin AND localizacao.anguloY <= Ymax
)
SELECT *
FROM BancosRegiao
JOIN assento
ON assento.nome_localizacao = BancosRegiao.nome
ORDER BY assento.id_assento





-- Bancos em alta (parte unica da tela inicial)
WITH AvaliacoesRecentes AS (
    SELECT id_assento
    FROM avalia
    ORDER BY data_avaliacao DESC
    LIMIT 50
),

NotaMedia AS (
    SELECT id_assento, ROUND(AVG(nota), 1) AS nota_media
    FROM avalia
    GROUP BY id_assento
),

FotoBanco AS (
    SELECT id_assento, MIN(file_path) AS foto
    FROM foto
    GROUP BY id_assento
),

TagsBanco AS (
    SELECT descreve.id_assento, GROUP_CONCAT(tag.nome, ', ') AS tags
    FROM descreve
    JOIN tag ON tag.id = descreve.id_tag
    GROUP BY descreve.id_assento
),

BancosEmAlta AS (
    SELECT assento.id_assento, assento.nome_localizacao AS nome_local, COUNT(*) AS qtd_avaliacoes
    FROM AvaliacoesRecentes
    JOIN assento ON assento.id_assento = AvaliacoesRecentes.id_assento
    WHERE assento.estado = 'existe'
    GROUP BY assento.id_assento
)
SELECT BancosEmAlta.nome_local,
       FotoBanco.foto,
       NotaMedia.nota_media,
       TagsBanco.tags,
       usuario.username,
       avalia.comentario
FROM BancosEmAlta
JOIN NotaMedia ON NotaMedia.id_assento = BancosEmAlta.id_assento
LEFT JOIN FotoBanco ON FotoBanco.id_assento = BancosEmAlta.id_assento
LEFT JOIN TagsBanco ON TagsBanco.id_assento = BancosEmAlta.id_assento
LEFT JOIN avalia ON avalia.id_assento = BancosEmAlta.id_assento
    AND avalia.comentario IS NOT NULL
    AND avalia.data_avaliacao = (
        SELECT MAX(data_avaliacao)
        FROM avalia
        WHERE id_assento = BancosEmAlta.id_assento AND comentario IS NOT NULL
    )
LEFT JOIN usuario ON usuario.user_tag = avalia.user_tag
ORDER BY BancosEmAlta.qtd_avaliacoes DESC, NotaMedia.nota_media DESC
LIMIT 3;