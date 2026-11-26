--- Ranking dos bancos
SELECT
    a.id,
    a.nome_localizacao AS nome_local,
    a.data_publicacao,

    -- Como um banco pode ter varias fotos, pegamos a menor delas (achei mais simples)
    (SELECT MIN(f.file_path)
       FROM foto f
      WHERE f.id_assento = a.id) AS foto_capa,

    -- fazemos algumas agregacoes para fazer a media e pegar o numero de avaliacoes de cada banco
    ROUND(AVG(av.nota), 1) AS nota_media,
    COUNT(av.nota)         AS n_avaliacoes,

    --"Conforto" eh quantas tags de conforto o banco tem
    (SELECT COUNT(*)
       FROM descreve d
       JOIN tag t ON t.id = d.id_tag
      WHERE d.id_assento = a.id
        AND t.nome IN ('possui encosto', 'possui braço', 'acolchoado',
                       'poltrona', 'dá para deitar')) AS pontos_conforto,

    -- Do mesmo modo do conforto acessibilidade eh calculada com base nos comentarios de "inacessivel"
    (SELECT COUNT(*)
       FROM manutencao m
      WHERE m.id_assento = a.id
        AND m.tipo_manutencao = 'inacessivel'
        AND m.estado = 'aprovada') AS relatos_inacessivel

FROM assento a
JOIN avalia av ON av.id_assento = a.id   -- so bancos com avaliação
WHERE a.estado = 'existe'                        -- quebrados/inexistentes ficam defora

    --Se quisessemos colocar alguns filtros (quando o usuario quiser) so precisariamos retirar os comentarios

    -- Filtro Local:
    --AND a.nome_localizacao = 'CB'

    -- Filtro Tags do banco:
    --AND a.id IN (SELECT d.id_assento
    --                       FROM descreve d
    --                       JOIN tag t ON t.id = d.id_tag
    --                      WHERE t.nome = 'ar livre')

GROUP BY a.id, a.nome_localizacao, a.data_publicacao

    -- Avaliacao minima
    --HAVING AVG(av.nota) >= 4 (n)

-- Sort by: nota geral (deixei como padrão). Uso o id para desempatar
ORDER BY AVG(av.nota) DESC, COUNT(av.nota) DESC, a.id
-- Se quisessemos ordenar por outras metricas:

--ORDER BY pontos_conforto DESC, AVG(av.nota) DESC, a.id        -- Conforto
--ORDER BY relatos_inacessivel ASC, AVG(av.nota) DESC, a.id     -- Acessibilidade
--ORDER BY a.data_publicacao DESC                                       -- Idade (mais recente primeiro)
--ORDER BY pontos_conforto DESC, relatos_inacessivel ASC, AVG(av.nota) DESC, a.id  -- Conforto + Acessibilidade + Nota

-- Paginação
LIMIT 10 OFFSET 0;