pipeline {
    agent any
    
    environment {
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
                withKubeConfig([credentialsId: 'kubeconfig-id']) {
                    sh '''
                        echo "🧭 Current Directory:"
                        pwd
                        
                        echo "📂 Files in deployment directory:"
                        ls -la deployment/
                        
                        echo "📄 Content of deployment.yaml:"
                        cat deployment/deployment.yaml
                        
                        echo "📄 Content of service.yaml:"
                        cat deployment/service.yaml
                        
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
        
        stage('Cleanup') {
            steps {
                sh 'docker logout || true'
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
    }
}
