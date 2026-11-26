WITH BancosRegiao AS (
    --primeiro obtemos todas as locazicações presentes dentro da área delimitada pelo mapa que estamos observando
    SELECT *
    FROM localizacao
    -- Os parametros Xmin, Xmax, Ymin e Ymax serão passados pelo programa e serão substituidos na expressão
    -- Para testar aqui, substitua
    -- Xmin = -22.82
    -- Xmax = -22.81
    -- Ymin = -47.07
    -- Ymax = -47.06
    WHERE localizacao.anguloX >= -Xmin AND localizacao.anguloX <= Xmax AND localizacao.anguloY >= Ymin AND localizacao.anguloY <= Ymax
)
SELECT assento.id, BancosRegiao.*
FROM BancosRegiao
--agora, com as localizações obtidas, fazemos um join com a tabela assentos para obter todos os assentos contendo as localizações dentro do mapa observado
JOIN assento
ON assento.nome_localizacao = BancosRegiao.nome
    --finalmente ordebnamos a ordem por id do assento, mas na aplicação nao importa tanto pois sera colocado cada banco em seu local por coordenada no mapa
ORDER BY assento.id;