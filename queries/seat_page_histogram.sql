
-- query para os histogramas de todos os bancos
SELECT bar_1.id_assento AS id_assento,
        rate_1, rate_2, rate_3, rate_4, rate_5
FROM
    -- cada subquery pega o número de avaliações de nota x
    -- para os assentos, cada linha sendo de um assento
    (
        SELECT assento.id AS id_assento, COUNT(avalia.nota) AS rate_1
        FROM assento
            LEFT JOIN avalia ON assento.id = avalia.id_assento
                    AND avalia.nota = 1
        GROUP BY assento.id
    ) AS bar_1
    JOIN
    (
        SELECT assento.id AS id_assento, COUNT(avalia.nota) AS rate_2
        FROM assento
            LEFT JOIN avalia ON assento.id = avalia.id_assento
                    AND avalia.nota = 2
        GROUP BY assento.id
    ) AS bar_2 ON bar_2.id_assento = bar_1.id_assento
    JOIN
    (
        SELECT assento.id AS id_assento, COUNT(avalia.nota) AS rate_3
        FROM assento
            LEFT JOIN avalia ON assento.id = avalia.id_assento
                    AND avalia.nota = 3
        GROUP BY assento.id
    ) AS bar_3 ON bar_3.id_assento = bar_1.id_assento
    JOIN
    (
        SELECT assento.id AS id_assento, COUNT(avalia.nota) AS rate_4
        FROM assento
            LEFT JOIN avalia ON assento.id = avalia.id_assento
                    AND avalia.nota = 4
        GROUP BY assento.id
    ) AS bar_4 ON bar_4.id_assento = bar_1.id_assento
    JOIN
    (
        SELECT assento.id AS id_assento, COUNT(avalia.nota) AS rate_5
        FROM assento
            LEFT JOIN avalia ON assento.id = avalia.id_assento
                    AND avalia.nota = 5
        GROUP BY assento.id
    ) AS bar_5 ON bar_5.id_assento = bar_1.id_assento
ORDER BY bar_1.id_assento;
-- após os joins, o resultado é que cada linha representa
-- o histograma de notas daquele banco (notas 1, 2, 3, 4 ou 5 dadas)
-- Cada página de um banco precisaria de uma linha dessa query,
-- para o determinado banco.
--
-- Bastaria adicionar um WHERE que filtra pelo id do banco de interesse.
