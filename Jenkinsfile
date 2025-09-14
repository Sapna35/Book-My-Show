pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node23'
    }

    environment {
        REGISTRY = "sapna350/bookmyshow"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout from Git') {
            steps {
                git(
                    url: 'https://github.com/Sapna35/Book-My-Show.git',
                    branch: 'main',
                    credentialsId: 'github-cred'
                )
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {   // 👈 make sure this name matches Jenkins config
                    sh '''
                        ./gradlew sonarqube \
                          -Dsonar.projectKey=BookMyShow \
                          -Dsonar.host.url=http://13.38.227.93:9000 \
                          -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
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

        stage('Install Dependencies') {
            steps {
                sh 'npm install --prefix bookmyshow-app'
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh """
                   docker build -t $REGISTRY:$IMAGE_TAG .
                   docker push $REGISTRY:$IMAGE_TAG
                """
            }
        }

        stage('Deploy to EKS Cluster') {
            steps {
                sh """
                   kubectl apply -f deployment.yml
                   kubectl apply -f service.yml
                """
            }
        }
    }

    post {
        always {
            emailext(
                to: 'sapna.rani@gmail.com',
                subject: "Build \${currentBuild.fullDisplayName} - \${currentBuild.currentResult}",
                body: "Check Jenkins for details: \${env.BUILD_URL}"
            )
        }
    }
}
