# Spanner e BigTable

## Pontos sobre o Spanner

- Não consome IPs da subnet. A infraestrutura do Spanner é gerenciada pelo Google. A conectividade tradicionalmente ocorre através dos endpoints do serviço.

- O controle de acesso é principalmente através de IAM. O próprio Spanner usa autenticação IAM para os clientes.

- Para isolamento de perímetro, existe também VPC Service Controls, que é uma camada diferente do VPC Firewall.

- Os dialetos disponíveis são: Google Standard SQL (default) e PostgreSQL.

## Conectar-se ao Spanner (Dialeto Postgres)

- Para conectar-se precisa do PGAdapter, um proxy local da Google que traduz o protocolo PostgreSQL para o Spanner.

- Sua conta precisa de um papel como roles/spanner.databaseUser (ou databaseAdmin) no projeto ou no banco:

```
gcloud auth application-default login
```

- Download do PGAdapter

```
wget https://storage.googleapis.com/pgadapter-jar-releases/pgadapter.tar.gz \
&& tar -xzvf pgadapter.tar.gz
    
```

- Inicie o PGAdapter com o seguinte comando

```
java -jar pgadapter.jar -p PROJECT_ID -i INSTANCE_ID -d DATABASE_ID \
-c CREDENTIALS_FILE_PATH \
ADDITIONAL_OPTIONS
```

- Exemplo com valores válidos:

```
java -jar pgadapter.jar -p evandro-project -i spanner-free -d fitjourney
```

- Conectse- com o psql
```
psql -h localhost -p 5432
```

- Comandos úteis para teste

```
SELECT * FROM customers;
SELECT current_database();
```


## Testes no BigTable

- A Row Key aparece codificada em Base64 nas consultas do BiQuery.

- Instalar a CLI cbt

```
sudo apt-get install google-cloud-cli-cbt
```

- Listar a estrutura da tabela/colum familes:

```
cbt --instance teste-bigtable --project evandro-project ls customer_activity
```

- Ler os dados da tabela:

```
cbt --instance teste-bigtable --project evandro-project read customer_activity
```

- Inserir eventos no BigTable

```
cbt --instance teste-bigtable --project evandro-project set customer_activity c001 events:type=login
cbt --instance teste-bigtable --project evandro-project set customer_activity c001 events:action=app_open
cbt --instance teste-bigtable --project evandro-project set customer_activity c002 events:type=purchase
cbt --instance teste-bigtable --project evandro-project set customer_activity c003 events:type=login
cbt --instance teste-bigtable --project evandro-project set customer_activity c003 events:action=subscription_cancel
```

## Testes no BigQuery

- Consulta básica em uma tabela externa

```
bq query --use_legacy_sql=false 'SELECT * FROM `evandro-project.fitjourney_analytics.spanner_customers`'
```

- Join entre o export do .csv e os dados do BigTable. OBS: É preciso tratar as informações do BigTable que são exportadas em Bsae64

```
SELECT
  s.customer_id,
  s.name,
  s.subscription_status,
  c.name AS event_type,
  CAST(c.cell[SAFE_OFFSET(0)].value AS STRING) AS event_value,
  c.cell[SAFE_OFFSET(0)].timestamp AS event_timestamp
FROM
  `evandro-project.fitjourney_analytics.spanner_customers` AS s
JOIN
  `evandro-project.fitjourney_analytics.bigtable_activity` AS b
ON
  s.customer_id = CAST(b.rowkey AS STRING)
CROSS JOIN
  UNNEST(b.events.column) AS c;
```