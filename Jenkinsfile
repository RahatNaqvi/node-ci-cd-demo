pipeline {
    agent any

    environment {
        APP_NAME   = "node-ci-cd-demo"
        IMAGE_NAME = "rahatnaqvi/${APP_NAME}"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RahatNaqvi/node-ci-cd-demo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test || true'  // Remove "|| true" to fail pipeline on test failure
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred', 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'minikube-kubeconfig']) {
                    sh '''
                        echo "🧭 Current Directory:"
                        pwd
                        echo "📂 Files:"
                        ls -R

                        echo "🚀 Deploying to Kubernetes..."
                        kubectl apply -f deployment/deployment.yaml
                        kubectl apply -f deployment/service.yaml
                        kubectl get pods -A
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
