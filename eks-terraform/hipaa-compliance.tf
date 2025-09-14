# HIPAA Compliance and Security Best Practices

# Network ACLs for additional security
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  # Allow inbound HTTPS
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 443
    to_port    = 443
  }

  # Allow inbound HTTP for health checks
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 80
    to_port    = 80
  }

  # Allow ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.cluster_name}-private-nacl"
  }
}

# VPC Flow Logs for audit trail
resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "/aws/vpc/flowlogs/${var.cluster_name}"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role" "flow_log" {
  name = "${var.cluster_name}-flow-log"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_log" {
  name = "${var.cluster_name}-flow-log"
  role = aws_iam_role.flow_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Pod Security Standards (apply manually after cluster is ready)
# kubectl apply -f - <<EOF
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: secure-workloads
#   labels:
#     pod-security.kubernetes.io/enforce: restricted
#     pod-security.kubernetes.io/audit: restricted
#     pod-security.kubernetes.io/warn: restricted
# EOF

# Network Policies for micro-segmentation (apply manually after cluster is ready)
# kubectl apply -f - <<EOF
# apiVersion: networking.k8s.io/v1
# kind: NetworkPolicy
# metadata:
#   name: deny-all
#   namespace: default
# spec:
#   podSelector: {}
#   policyTypes: ["Ingress", "Egress"]
# EOF

# Falco for runtime security
# resource "helm_release" "falco" {
#   namespace        = "falco-system"
#   create_namespace = true
#   name             = "falco"
#   repository       = "https://falcosecurity.github.io/charts"
#   chart            = "falco"
#   version          = "3.8.0"
#   timeout          = 600
#   wait             = true

#   values = [
#     yamlencode({
#       falco = {
#         grpc = {
#           enabled = true
#         }
#         grpcOutput = {
#           enabled = true
#         }
#       }
#     })
#   ]

#   depends_on = [helm_release.karpenter]
# }