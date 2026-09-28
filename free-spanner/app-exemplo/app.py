import os
os.environ["SPANNER_DISABLE_BUILTIN_METRICS"] = "true"

from google.cloud import spanner

PROJECT_ID = "evandro-project"
INSTANCE_ID = "spanner-free"
DATABASE_ID = "fitjourney"

def main():
    client = spanner.Client(project=PROJECT_ID)

    instance = client.instance(INSTANCE_ID)
    database = instance.database(DATABASE_ID)

    rows = [
        ("c001", "João da Silva", "ACTIVE"),
        ("c002", "Maria Souza", "ACTIVE"),
        ("c003", "Carlos Oliveira", "CANCELED"),
        ("c004", "Ana Santos", "TRIAL"),
        ("c005", "Pedro Almeida", "ACTIVE"),
    ]

    def upsert_customers(transaction):
        transaction.insert_or_update(
            table="customers",
            columns=("customer_id", "name", "subscription_status"),
            values=rows,
        )

    database.run_in_transaction(upsert_customers)

    print("Clientes inseridos com sucesso!")

    with database.snapshot() as snapshot:
        results = snapshot.execute_sql(
            """
            SELECT customer_id, name, subscription_status
            FROM customers
            ORDER BY customer_id
            """
        )

        for row in results:
            print(
                f"ID={row[0]} | "
                f"Nome={row[1]} | "
                f"Status={row[2]}"
            )

if __name__ == "__main__":
    main()