pipeline {
    agent any

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Sapna35/Book-My-Show.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('bookmyshow-app') {   // go inside app folder
                    sh 'npm install'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "SonarQube scan would run here"
            }
        }

        stage('Docker Build') {
            steps {
                dir('bookmyshow-app') {   // build Docker image from app folder
                    sh """
                        docker build -t sapna350/bookmyshow-app:${BUILD_NUMBER} .
                        docker tag sapna350/bookmyshow-app:${BUILD_NUMBER} sapna350/bookmyshow-app:latest
                    """
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push sapna350/bookmyshow-app:${BUILD_NUMBER}
                        docker push sapna350/bookmyshow-app:latest
                    """
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                    aws eks --region ap-south-1 update-kubeconfig --name sapna-eks-cluster
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                """
            }
        }
    }

    post {
        always {
            emailext (
                to: 'sapnarani3502@gmail.com',
                subject: "Jenkins Pipeline: ${currentBuild.currentResult}",
                body: """
                    Build result: ${currentBuild.currentResult}
                    Project: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Check console output at ${env.BUILD_URL}
                """
            )
        }
    }
}
