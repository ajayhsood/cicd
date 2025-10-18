pipeline {
    agent any

    environment {
        CONTAINER_NAME = "nestjs-app"
        IMAGE_NAME = "nestjs-image"
        EMAIL = "ajay.sood9@gmail.com"
        PORT = "3000"
    }

    stages {
        stage('Clone Repository') {
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

        stage('Health Check') {
            steps {
                sh '''
                    echo "Checking container status..."
                    docker ps | grep $CONTAINER_NAME
                '''
            }
        }

        stage('Send Email Notification') {
            steps {
                emailext(
                    subject: "✅ NestJS App Deployed Successfully on EC2",
                    body: """
                    <h2>Deployment Successful!</h2>
                    <p>Your NestJS application has been deployed successfully.</p>
                    <p><b>Container:</b> ${CONTAINER_NAME}</p>
                    <p><b>Port:</b> ${PORT}</p>
                    <p><b>Deployed on:</b> AWS EC2</p>
                    """,
                    mimeType: 'text/html',
                    to: "${EMAIL}"
                )
            }
        }
    }

    post {
        failure {
            emailext(
                subject: "❌ NestJS Deployment Failed on EC2",
                body: "The pipeline failed. Please check Jenkins logs for more details.",
                to: "${EMAIL}"
            )
        }
    }
}
