# Technical Notes

## Kubernetes

aws sso login --profile prodAdmin
aws eks update-kubeconfig --region us-east-1 --name aide-prod --profile prodAdmin
kubectl get pods --all-namespaces

kubectl -n domain-trust port-forward pod/clickhouse-0 9000:9000
