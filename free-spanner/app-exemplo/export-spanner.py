import os
os.environ["SPANNER_DISABLE_BUILTIN_METRICS"] = "true"
import csv
from google.cloud import storage, spanner

client = spanner.Client(project="evandro-project")
database = client.instance("spanner-free").database("fitjourney")

with database.snapshot() as snapshot:
    rows = snapshot.execute_sql("SELECT customer_id, name, subscription_status FROM customers")
    with open("customers.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["customer_id", "name", "subscription_status"])
        writer.writerows(rows)

bucket = storage.Client(project="evandro-project").bucket("evandro-project-spanner-exports")
bucket.blob("customers.csv").upload_from_filename("customers.csv")