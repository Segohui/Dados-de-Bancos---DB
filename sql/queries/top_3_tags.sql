-- 3 primeiras tags do banco com id==1
-- Para ver dos outros, so trocar no WHERE
SELECT t.nome
FROM descreve d
JOIN tag t ON t.id = d.id_tag
WHERE d.id_assento = 1
ORDER BY t.id
LIMIT 3;