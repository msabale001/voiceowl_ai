node {

  // ---- CONFIG ----
  def IMAGE_NAME = "msabale/node-app"
  def IMAGE_TAG  = "${env.BUILD_NUMBER}"
  def FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

  stage('Git Checkout') {
    checkout scm
  }

  stage('Docker Build') {
    sh """
      docker build -t ${FULL_IMAGE} .
    """
  }

  stage('Trivy Image Scan (Security Gate)') {
    sh """
      mkdir -p trivy-reports

      # Human-readable table report
      trivy image \
        --severity CRITICAL \
        --format table \
        --output trivy-reports/trivy-report.txt \
        ${FULL_IMAGE}

      # FAIL pipeline if CRITICAL vulns found
      trivy image \
        --severity CRITICAL \
        --exit-code 1 \
        ${FULL_IMAGE}
    """
  }

  stage('Push to Docker Hub') {
    withCredentials([usernamePassword(
        credentialsId: 'dockerhub-creds',
        usernameVariable: 'DOCKER_USER',
        passwordVariable: 'DOCKER_PASS'
    )]) {
      sh """
        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
        docker push ${FULL_IMAGE}
        docker logout
      """
    }
  }

  stage('Cleanup') {
    sh """
      docker rmi ${FULL_IMAGE} || true
    """
  }

  post {
    failure {
      echo "❌ Pipeline failed"
    }
    success {
      echo "Image pushed to Docker Hub."
    }
  }
}
