from pathlib import Path
from neo4j import GraphDatabase

URI = "bolt://neo4j:7687"
AUTH = ("neo4j", "banco1984")

def execute_file(driver, path):
    content = Path(path).read_text(encoding="utf-8")
    lines = [l for l in content.splitlines() if not l.strip().startswith("//")]
    commands = [c.strip() for c in "\n".join(lines).split(";") if c.strip()]

    print(f"\n=== Executing {path} ===")
    for cmd in commands:
        records, _, _ = driver.execute_query(cmd, database_="neo4j")
        for r in records:
            print(dict(r))

with GraphDatabase.driver(URI, auth=AUTH) as driver:
    driver.verify_connectivity()
    execute_file(driver, "cypher/schema.cypher")
    execute_file(driver, "cypher/data.cypher")
    execute_file(driver, "cypher/queries.cypher")