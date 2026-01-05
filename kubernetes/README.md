**I have used Killerkoda terminal**

Created 2 namespaces named **dev** and **sit**.
Network policies applied so that pods within respective namespaces should not able to communicate with each other.

4️⃣** Kubernetes Hardening (Local Cluster)**
🔒 Security Controls Applied

securityContext:
runAsNonRoot: true
allowPrivilegeEscalation: false
Resource requests & limits
NetworkPolicy for namespace isolation
HPA
