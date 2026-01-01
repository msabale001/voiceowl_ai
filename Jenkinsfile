pipeline {
  agent any

  environment {
    IMAGE_NAME = "msabale/node-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
    FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
  }

  stages {

    stage('Git Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          docker build -t ${FULL_IMAGE} .
        '''
      }
    }

    stage('Trivy Image Scan (Security Gate)') {
      steps {
        sh '''
          mkdir -p trivy-reports

          # Human-readable report
          trivy image \
            --severity CRITICAL \
            --format table \
            --output trivy-reports/trivy-report.txt \
            ${FULL_IMAGE}

          # Fail pipeline if CRITICAL vulnerabilities are found
          trivy image \
            --severity CRITICAL \
            --exit-code 1 \
            ${FULL_IMAGE}
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-cred',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${FULL_IMAGE}
            docker logout
          '''
        }
      }
    }

    stage('Cleanup') {
      steps {
        sh '''
          docker rmi ${FULL_IMAGE} || true
        '''
      }
    }
  }

  post {
    success {
      echo "Image pushed to Docker Hub."
    }
    failure {
      echo "Image was NOT pushed."
    }
  }
}
