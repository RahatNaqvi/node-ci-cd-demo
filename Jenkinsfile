pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rahatnaqvi/node-ci-cd-demo:latest"
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
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'minikube-kubeconfig']) {
                    sh '''
                        kubectl apply -f deployment/deployment.yaml
                        kubectl apply -f deployment/service.yaml
                        kubectl get pods -A
                    '''
                }
            }
        }
    } // end stages
} // end pipeline
