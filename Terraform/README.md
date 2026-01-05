3️⃣ **Infrastructure as Code – EKS Simulation (Terraform)**
🏗 Resources Defined

VPC
Public & private subnets
IAM roles (cluster & nodes)
EKS cluster
Managed node groups
No AWS account required — validated locally.

🧠 **How This Terraform Maps to Real AWS EKS**
| Terraform Resource | AWS Service            |
| ------------------ | ---------------------- |
| aws_vpc            | Amazon VPC             |
| aws_subnet         | Public/Private Subnets |
| aws_eks_cluster    | EKS Control Plane      |
| aws_eks_node_group | Worker Nodes           |
| aws_iam_role       | IAM for EKS            |
