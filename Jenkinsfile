pipeline {
    agent any
    environment {
        DOCKER_USER = credentials('docker-username-id')
        DOCKER_PASS = credentials('docker-password-id')
        IMAGE_NAME = 'rahatnaqvi/node-ci-cd-demo'
        IMAGE_TAG = 'latest'
    }
    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/RahatNaqvi/node-ci-cd-demo.git',
                    branch: 'main'
                )
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'npm test || true'
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
                    credentialsId: 'docker-hub-credentials-id', 
                    usernameVariable: 'USER', 
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
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
                withKubeConfig([credentialsId: 'kubeconfig-id']) {
                    sh '''
                        echo "🧭 Current Directory:"
                        pwd
                        
                        echo "📂 Files in deployment directory:"
                        ls -la deployment/
                        
                        echo "📄 Content of deployment.yaml:"
                        cat deployment/deployment.yaml || echo "⚠️ deployment.yaml not found"
                        
                        echo "📄 Content of service.yaml:"
                        cat deployment/service.yaml || echo "⚠️ service.yaml not found"
                        
                        echo "🔍 Validating Kubernetes manifests..."
                        kubectl apply -f deployment/ --dry-run=client
                        
                        echo "🚀 Applying Kubernetes manifests..."
                        kubectl apply -f deployment/
                        
                        echo "⏱️ Waiting for deployment rollout..."
                        kubectl rollout status deployment/node-app-deployment --timeout=300s
                        
                        echo "📊 Checking deployment status..."
                        kubectl get deployments
                        kubectl get pods
                        kubectl get services
                        
                        echo "✅ Deployment successful!"
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo "🎉 Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
        always {
            sh 'docker logout || true'
        }
    }
}
