pipeline {
    agent any
    environment {
	DOCKER_USER = credentials('docker-hub-creds')
	DOCKER_PASS = credentials('docker-hub-creds')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/RahatNaqvi/node-ci-cd-demo',
                    credentialsId: 'github-creds'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t rahatnaqvi/node-ci-cd-demo:latest .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push rahatnaqvi/node-ci-cd-demo:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'minikube-kubeconfig']) {
                    sh '''
                    kubectl apply -f delpoyment/deployment.yaml
                    kubectl apply -f deployment/service.yaml
                    kubectl get pods -A
                    '''
                }
            }
        }
    } // end stages
} // end pipeline
