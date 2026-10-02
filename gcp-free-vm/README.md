# Terraform GCP

## Conectar a uma instância via IAP sem IP externo
```
gcloud compute ssh user@free-vm --zone us-central1-a --tunnel-through-iap
```

## SCP vai IAP

```
gcloud compute scp --recurse ./boto-packages/ evandro@free-vm:/tmp/ --zone us-central1-a --tunnel-through-iap
```

## Acessar endpoint de metadados na instância
```
curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/
```

### Policy Analyzer

O Policy Analyzer permite rodar uma query para identificar algo como "Quais recursos essa principal (service account, user, group, etc) pode acessar?"

Também é possível obter o mesmo resultado via Cloud Asset Inventory com o seguinte comando:

```
gcloud asset analyze-iam-policy --project evandro-project --identity="serviceAccount:bucket-reader@evandro-project.iam.gserviceaccount.com"
```