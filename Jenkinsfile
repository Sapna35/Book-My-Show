pipeline {
    agent any

    tools {
        maven 'Maven'          // Configure in Jenkins Global Tool Configuration
        jdk 'JDK17'            // Configure JDK in Jenkins
        nodejs 'NodeJS'        // If frontend build is needed
    }

    environment {
        REGISTRY = "sapna350"
        IMAGE_NAME = "bookmyshow-app"
    }

    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/Sapna35/Book-My-Show.git', 
                    credentialsId: 'github-cred'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {   // Name must match Jenkins SonarQube config
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh """
                        docker build -t $REGISTRY/$IMAGE_NAME:${BUILD_NUMBER} .
                        docker tag $REGISTRY/$IMAGE_NAME:${BUILD_NUMBER} $REGISTRY/$IMAGE_NAME:latest
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker push $REGISTRY/$IMAGE_NAME:${BUILD_NUMBER}
                        docker push $REGISTRY/$IMAGE_NAME:latest
                    """
                }
            }
        }

        stage('Deploy to EKS Cluster') {
            steps {
                script {
                    sh """
                        aws eks --region ap-south-1 update-kubeconfig --name sapna-eks-cluster
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    """
                }
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
