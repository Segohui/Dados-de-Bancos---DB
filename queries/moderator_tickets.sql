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