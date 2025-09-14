# RDS Migration Guide

## Changes Made for RDS Integration

### 1. Backend Helm Chart Updates

#### ConfigMap (`backend/helm/backend-chart/templates/configmap.yaml`)
- **OLD**: Points to local PostgreSQL service in cluster
- **NEW**: Uses Helm values for RDS endpoint configuration
- **Action**: Update `values.yaml` with your RDS details

#### Values (`backend/helm/backend-chart/values.yaml`)
- **NEW**: Added `database` section with RDS configuration
- **Action**: Replace placeholder values with actual RDS endpoint

#### Secret Template (`backend/helm/backend-chart/templates/secret.yaml`)
- **NEW**: Template for secure credential management
- **Action**: Uncomment and use for production deployments

### 2. Local Development Updates

#### Backend .env (`backend/.env`)
- **OLD**: Points to localhost PostgreSQL
- **NEW**: Points to RDS endpoint
- **Action**: Update with your RDS connection string

### 3. What to Remove/Comment Out

#### No Longer Needed with RDS:
```yaml
# k8s-manifests/database-deployment.yaml - ENTIRE FILE
# k8s-manifests/database-service.yaml - ENTIRE FILE  
# k8s-manifests/database-storage.yaml - ENTIRE FILE
```

#### Docker Compose Database Service:
```yaml
# docker-compose.yaml - Remove postgres service section
```

### 4. Required Actions

1. **Get RDS Endpoint** from your Terraform output
2. **Update values.yaml** with actual RDS details
3. **Create RDS database** and user if not done via Terraform
4. **Run database migrations** against RDS
5. **Update security groups** to allow EKS access to RDS

### 5. Security Considerations

- Use AWS Secrets Manager for production credentials
- Ensure RDS security groups allow EKS subnet access
- Enable RDS encryption at rest
- Use IAM database authentication if possible

### 6. Testing Migration

1. **Local**: Update `.env` and test backend connection
2. **Kubernetes**: Deploy with new Helm values
3. **Verify**: Check backend logs for successful RDS connection