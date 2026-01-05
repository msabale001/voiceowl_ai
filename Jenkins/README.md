2️⃣ **CI/CD Pipeline Security**
🔐 **Pipeline Stages**

Code checkout
Static code analysis (SonarQube)
Docker build
Container image scanning (Trivy)
Fail pipeline on Critical vulnerabilities
Push image only if all security gates pass

🚫** Security Gates**

Build fails if:
Static analysis finds critical issues
Trivy finds HIGH or CRITICAL vulnerabilities
