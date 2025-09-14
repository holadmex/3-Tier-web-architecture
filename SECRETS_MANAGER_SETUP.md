# AWS Secrets Manager Setup for RDS

## 1. Create Secret in AWS Secrets Manager

```bash
# Create RDS secret with connection string
aws secretsmanager create-secret \
  --name "prod/rds/credentials" \
  --description "RDS credentials for production" \
  --secret-string '{
    "DATABASE_URI": "postgresql://username:password@your-rds-endpoint.region.rds.amazonaws.com:5432/ecommerce_db"
  }'
```

## 2. Install External Secrets Operator

```bash
# Add External Secrets Operator Helm repo
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

# Install External Secrets Operator
helm install external-secrets external-secrets/external-secrets -n external-secrets-system --create-namespace
```

## 3. Setup IAM Role for Service Account (IRSA)

Your EKS cluster needs IAM permissions to access Secrets Manager:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:region:account:secret:prod/rds/credentials*"
    }
  ]
}
```

## 4. Update Helm Values

Update `backend/helm/backend-chart/values.yaml`:

```yaml
aws:
  region: "your-region"
  secretName: "prod/rds/credentials"

serviceAccount:
  create: true
  name: "backend-service-account"
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::account:role/backend-secrets-role"
```

## 5. Deploy

```bash
helm upgrade --install backend-release ./backend/helm/backend-chart --namespace dev
```

## 6. Verify Secret Creation

```bash
kubectl get secrets -n dev
kubectl describe externalsecret rds-external-secret -n dev
```