pipeline {
    agent any
    
    environment {
        CONTAINER_NAME = "nestjs-app"
        IMAGE_NAME = "nesths-image"
        EMAIL = "ajay.sood9@gmail.com"
        PORT = "3000"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/ajayhsood/cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Stop & Remove Previous Container') {
            steps {
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker run -d -p ${PORT}:${PORT} --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }

        stage('Send Email Notification') {
            steps {
                emailext(
                    subject: "NestJS APP Deployed Successfully on EC2!",
                    body: "Your NestJS app has been deployed successfully. Please verify the deployment.",
                    to: "${EMAIL}"
                )
            }
        }
    }
}
