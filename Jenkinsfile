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

    stage('SonarQube Analysis') {
      steps {
        script {
          def scannerHome = tool 'sonarqube'
          withSonarQubeEnv('sonarqube') {
            sh """
              ${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectKey=node_app \
                -Dsonar.sources=.
            """
          }
        }
      }
    }
    stage('Quality Gate') {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
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
    stage('Update Manifest') {
      steps {
        sh '''
          echo "Updating image tag in deployment.yaml"
          sed -i "s|image: msabale/node-app:.*|image: msabale/node-app:${BUILD_NUMBER}|" deployment.yaml
          grep "image:" deployment.yaml
        '''
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh '''
            kubectl apply -f deployment.yaml
            kubectl rollout status deployment/node-app
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
      echo "Quality Gate + Security Gate passed. Image pushed to Docker Hub."
    }
    failure {
      echo "Pipeline failed. Image was NOT pushed."
    }
  }
}

