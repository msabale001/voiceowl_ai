pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'Auto_Approve',
            defaultValue: false,
            description: 'If true, Terraform will auto-approve'
        )
        choice(
            name: 'Action',
            choices: ['apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
        TF_IN_AUTOMATION      = "true"
        TF_CLI_ARGS           = "-no-color"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/msabale001/terraform-tfsec.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('tfsec Security Scan') {
            steps {
                sh '''
                    echo "Running tfsec security scan..."
                    tfsec . --no-color
                    echo "tfsec scan completed."
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.Action == 'apply') {
                        sh 'terraform plan -out=tfplan'
                        sh 'terraform show tfplan > tfplan.txt'
                    } else {
                        sh 'terraform plan -destroy -out=tfdestroy'
                        sh 'terraform show tfdestroy > tfdestroy.txt'
                    }
                }
            }
        }

        stage('Terraform Apply / Destroy') {
            steps {
                script {
                    if (params.Action == 'apply') {
                        if (params.Auto_Approve) {
                            sh 'terraform apply --auto-approve tfplan'
                        } else {
                            input message: "Approve Terraform APPLY?", ok: "Apply"
                            sh 'terraform apply tfplan'
                        }
                    }
                    else if (params.Action == 'destroy') {
                        if (params.Auto_Approve) {
                            sh 'terraform apply --auto-approve tfdestroy'
                        } else {
                            input message: "Approve Terraform DESTROY?", ok: "Destroy"
                            sh 'terraform apply tfdestroy'
                        }
                    }
                }
            }
        }
    }
    post{
        success {
            echo "Pipeline completed successfully."
        }
    }
}
