**Risks Identified**

| Area             | Risk                                  |
| ---------------- | ------------------------------------- |
| Container Images | Vulnerable OS packages                |
| CI/CD            | Risk of pushing vulnerable images     |
| Kubernetes       | Privilege escalation, Other Pods      |
| Networking       | Lateral movement without policies     |
| IaC              | Over-permissive IAM roles             |
| Observability    | Blind spots without alerts            |

**Hardening Measures Implemented**

**Container Security**

Multi-stage builds

Minimal base images

Non-root execution

Trivy scans integrated into CI


**CI/CD Security**

Static code analysis

Image scanning before push

Security-based pipeline failure

Immutable image tags


**Infrastructure Security**

Least-privilege IAM roles

Private subnets for nodes


**Kubernetes Hardening**

PodSecurityContext enforced

NetworkPolicy for isolation

Resource quotas to prevent DoS

HPA for scalability

**What Remains Before Production**

| Area              | Recommendation                             |
| ----------------- | ------------------------------------------ |
| Secrets           | Use AWS Secrets Manager / External Secrets |
| Admission Control | Enable OPA Gatekeeper / Kyverno            |
| Image Provenance  | Enable image signing (Cosign)              |
| Access Control    | Fine-grained RBAC & IRSA                   |
