pipeline {
    agent any

    environment {
        CONTAINER_NAME = "nestjs-app"
        IMAGE_NAME = "nestjs-image"
        EMAIL = "ajay.sood9@gmail.com"
        PORT = "3000"
        EC2_USER = "ec2-user"      // add your EC2 username
        EC2_HOST = "3.84.8.158"   // replace with EC2 public IP or DNS
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning GitHub repository..."
                git branch: 'main', url: 'https://github.com/ajayhsood/cicd.git'
            }
        }

        stage('Verify SSH Connection to EC2') {
            steps {
                echo "Verifying SSH connection to AWS EC2..."
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "echo ✅ SSH connection successful on $(hostname)"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Stop & Remove Previous Container') {
            steps {
                echo "Stopping and removing existing container (if any)..."
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running new Docker container..."
                sh '''
                    docker run -d -p ${PORT}:${PORT} --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo "Checking container status..."
                sh '''
                    docker ps | grep $CONTAINER_NAME
                '''
            }
        }

        stage('Send Email Notification') {
            steps {
                echo "Sending deployment success email..."
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
