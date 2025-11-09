pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rahatnaqvi/node-ci-cd-demo:latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git(
                    url: 'https://github.com/RahatNaqvi/node-ci-cd-demo',
                    branch: 'main',
                    credentialsId: 'github-creds' // your GitHub credentials in Jenkins
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
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
        // Use the secret kubeconfig file
        withKubeConfig([credentialsId: 'kubeconfig-file']) {
            sh '''
		kubectl apply -f deployment/deployment.yaml
                kubectl apply -f deployment/service.yaml                
                kubectl get pods -A
            '''
        }
    }
}
    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed. Check logs above.'
        }
    }
}
