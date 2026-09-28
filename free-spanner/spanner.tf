resource "google_spanner_instance" "free" {
  name = "spanner-free"
  display_name = "Spanner Free"

  config = "regional-us-central1"

  instance_type = "FREE_INSTANCE"
}

resource "google_spanner_database" "app" {
    instance = google_spanner_instance.free.name
    name = "fitjourney"

    database_dialect = "POSTGRESQL"

    ddl = [
        <<-EOT
            CREATE TABLE customers (
                customer_id varchar(36) NOT NULL,
                name varchar(200),
                subscription_status varchar(50),
                PRIMARY KEY (customer_id)
            );
        EOT
    ]
}