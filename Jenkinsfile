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
                dir('bookmyshow-app') {   
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
                dir('bookmyshow-app') {   
                    sh 'docker build -t sapna350/bms-app:latest .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push sapna350/bms-app:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 3000:3000 sapna350/bms-app:latest'
            }
        }
    }
     post {
        success {
            emailext(
                subject: " SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>The build completed <b>SUCCESSFULLY</b>.</p>
                         <p>Project: ${env.JOB_NAME}</p>
                         <p>Build Number: ${env.BUILD_NUMBER}</p>
                         <p>URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'sapnarani3502@gmail.com'
            )
        }

        failure {
            emailext(
                subject: " FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>The build has <b>FAILED</b>.</p>
                         <p>Project: ${env.JOB_NAME}</p>
                         <p>Build Number: ${env.BUILD_NUMBER}</p>
                         <p>URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'sapnarani3502@gmail.com'
            )
        }

        always {
            echo "Build finished. Email notification sent."
        }
    }
}
