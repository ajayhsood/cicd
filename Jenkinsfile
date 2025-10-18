pipeline {
    agent any

    environment {
        CONTAINER_NAME = "nestjs-app"
        IMAGE_NAME = "nestjs-image"
        EMAIL = "ajay.sood9@gmail.com"
        PORT = "3000"
        EC2_USER = "ec2-user"
        EC2_HOST = "44.208.22.76"
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

        stage('Build & Deploy on EC2') {
            steps {
                echo "Building Docker image and deploying on EC2..."
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        cd /home/$EC2_USER || exit 1
                        rm -rf cicd && git clone https://github.com/ajayhsood/cicd.git
                        cd cicd
                        echo 🔨 Building Docker image...
                        docker build -t $IMAGE_NAME .
                        echo 🧹 Cleaning up old container...
                        docker stop $CONTAINER_NAME || true
                        docker rm $CONTAINER_NAME || true
                        echo 🚀 Running new container...
                        docker run -d -p ${PORT}:${PORT} --name $CONTAINER_NAME $IMAGE_NAME
                    "
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                echo "Checking container status on EC2..."
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                        docker ps | grep $CONTAINER_NAME
                    "
                    '''
                }
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
                    <p><b>Deployed on:</b> ${EC2_HOST}</p>
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
