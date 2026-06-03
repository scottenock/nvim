# Technical Notes

## Kubernetes

aws sso login --profile prodAdmin
aws eks update-kubeconfig --region us-east-1 --name aide-prod --profile prodAdmin
kubectl get pods --all-namespaces
kubectl -n domain-trust port-forward pod/clickhouse-0 9000:9000

## Terraform

AWS_PROFILE=prodAdmin tofu plan -var-file="../vars/prod.tfvars"
AWS_PROFILE=prodAdmin tofu apply -var-file="../vars/prod.tfvars"
AWS_PROFILE=prodAdmin tofu output -var-file="../vars/prod.tfvars" -raw manrs_attachments_cf_public_key_id

## Find and Replace (global cli)

```
find cmd/server pkg -name "*.go" -type f -exec sed -i '' 's/failed to / /g' {} \;
```

v1 vs v2 gap solution
claude --resume 6e658d9f-4e48-4d74-957b-d623f7bacbd6
