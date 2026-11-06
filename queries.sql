-- Tela de Tickets para Moderadores

WITH TicketsModeracao AS (
    -- Fazer a união entre manutenção e sugestão, renomeando os atributos
    -- Para que sejam equivalentes
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
    --primeiro obtemos todas as locazicações presentes dentro da área delimitada pelo mapa que estamos observando
    SELECT *
    FROM localizacao
    -- Os parametros Xmin, Xmax, Ymin e Ymax serão passados pelo programa e serão substituidos na expressão
    WHERE localizacao.anguloX >= Xmin AND localizacao.anguloX <= Xmax AND localizacao.anguloY >= Ymin AND localizacao.anguloY <= Ymax
)
SELECT *
FROM BancosRegiao
--agora, com as localizações obtidas, fazemos um join com a tabela assentos para obter todos os assentos contendo as localizações dentro do mapa observado
JOIN assento
ON assento.nome_localizacao = BancosRegiao.nome
    --finalmente ordebnamos a ordem por id do assento, mas na aplicação nao importa tanto pois sera colocado cada banco em seu local por coordenada no mapa
ORDER BY assento.id;





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
-- LEFT JOIN para o card aparece mesmo sem foto, tags ou comentário
LEFT JOIN FotoBanco ON FotoBanco.id_assento = BancosEmAlta.id_assento
LEFT JOIN TagsBanco ON TagsBanco.id_assento = BancosEmAlta.id_assento
-- comentário de destaque: o mais recente do banco (ignora avaliações sem comentário)
LEFT JOIN avalia ON avalia.id_assento = BancosEmAlta.id_assento
    AND avalia.comentario IS NOT NULL
    AND avalia.data_avaliacao = (
        SELECT MAX(data_avaliacao)
        FROM avalia
        WHERE id_assento = BancosEmAlta.id_assento AND comentario IS NOT NULL
    )
LEFT JOIN usuario ON usuario.user_tag = avalia.user_tag
-- mais avaliados primeiro e em caso de empate vai pela melhor nota
ORDER BY BancosEmAlta.qtd_avaliacoes DESC, NotaMedia.nota_media DESC
LIMIT 3;


--- Ranking dos bancos
SELECT
    a.id_assento,
    a.nome_localizacao AS nome_local,
    a.data_publicacao,

    -- Como um banco pode ter varias fotos, pegamos a menor delas (achei mais simples)
    (SELECT MIN(f.file_path)
       FROM foto f
      WHERE f.id_assento = a.id_assento) AS foto_capa,

    -- fazemos algumas agregacoes para fazer a media e pegar o numero de avaliacoes de cada banco
    ROUND(AVG(av.nota), 1) AS nota_media,
    COUNT(av.nota)         AS n_avaliacoes,

    --"Conforto" eh quantas tags de conforto o banco tem
    (SELECT COUNT(*)
       FROM descreve d
       JOIN tag t ON t.id = d.id_tag
      WHERE d.id_assento = a.id_assento
        AND t.nome IN ('possui encosto', 'possui braço', 'acolchoado',
                       'poltrona', 'dá para deitar')) AS pontos_conforto,

    -- Do mesmo modo do conforto acessibilidade eh calculada com base nos comentarios de "inacessivel"
    (SELECT COUNT(*)
       FROM manutencao m
      WHERE m.id_assento = a.id_assento
        AND m.tipo_manutencao = 'inacessivel'
        AND m.estado = 'aprovada') AS relatos_inacessivel

FROM assento a
JOIN avalia av ON av.id_assento = a.id_assento   -- so bancos com avaliação
WHERE a.estado = 'existe'                        -- quebrados/inexistentes ficam defora

    --Se quisessemos colocar alguns filtros (quando o usuario quiser) so precisariamos retirar os comentarios

    -- Filtro Local:
    --AND a.nome_localizacao = 'CB'

    -- Filtro Tags do banco:
    --AND a.id_assento IN (SELECT d.id_assento
    --                       FROM descreve d
    --                       JOIN tag t ON t.id = d.id_tag
    --                      WHERE t.nome = 'ar livre')

GROUP BY a.id_assento, a.nome_localizacao, a.data_publicacao

    -- Avaliacao minima
    --HAVING AVG(av.nota) >= 4 (n)

-- Sort by: nota geral (deixei como padrão). Uso o id para desempatar
ORDER BY AVG(av.nota) DESC, COUNT(av.nota) DESC, a.id_assento
-- Se quisessemos ordenar por outras metricas:

--ORDER BY pontos_conforto DESC, AVG(av.nota) DESC, a.id_assento        -- Conforto
--ORDER BY relatos_inacessivel ASC, AVG(av.nota) DESC, a.id_assento     -- Acessibilidade
--ORDER BY a.data_publicacao DESC                                       -- Idade (mais recente primeiro)
--ORDER BY pontos_conforto DESC, relatos_inacessivel ASC, AVG(av.nota) DESC, a.id_assento  -- Conforto + Acessibilidade + Nota

-- Paginação
LIMIT 10 OFFSET 0;


-- 3 primeiras tags do banco com id==1
-- Para ver dos outros, so trocar no WHERE
SELECT t.nome
FROM descreve d
JOIN tag t ON t.id = d.id_tag
WHERE d.id_assento = 1
ORDER BY t.id
LIMIT 3;
