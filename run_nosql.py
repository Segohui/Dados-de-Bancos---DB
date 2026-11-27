from pathlib import Path
from neo4j import GraphDatabase

URI = "bolt://neo4j:7687"
AUTH = ("neo4j", "banco1984")

def executar_arquivo(driver, caminho):
    conteudo = Path(caminho).read_text(encoding="utf-8")
    linhas = [l for l in conteudo.splitlines() if not l.strip().startswith("//")]
    comandos = [c.strip() for c in "\n".join(linhas).split(";") if c.strip()]

    print(f"\n=== Executando {caminho} ===")
    for cmd in comandos:
        records, _, _ = driver.execute_query(cmd, database_="neo4j")
        for r in records:
            print(dict(r))

with GraphDatabase.driver(URI, auth=AUTH) as driver:
    driver.verify_connectivity()
    executar_arquivo(driver, "cypher/schema.cypher")
    executar_arquivo(driver, "cypher/data.cypher")
    executar_arquivo(driver, "cypher/queries.cypher")