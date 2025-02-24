pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/your-app-name' // Replace with your Docker image name
        K8S_NAMESPACE = 'your-namespace' // Replace with your Kubernetes namespace
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your code from GitHub repository using GitHub credentials
                git credentialsId: 'Github-cred', branch: 'main', url: 'https://github.com/Pranavmanish/Feedback.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    // Log in to DockerHub using credentials in Jenkins
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'

                    // Push the Docker image to DockerHub
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use the pre-configured Kubernetes credentials (kubeconfig) in Jenkins
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        // Apply the Kubernetes YAML files (deployment.yaml and service.yaml)
                        sh '''
                            kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml --namespace=$K8S_NAMESPACE
                            kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml --namespace=$K8S_NAMESPACE
                        '''
                    }
                }
            }
        }

        stage('Update Deployment with New Docker Image') {
            steps {
                script {
                    // Update the deployment with the new Docker image in case the image has changed
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh '''
                            kubectl --kubeconfig=$KUBECONFIG set image deployment/your-deployment your-container=$DOCKER_IMAGE --namespace=$K8S_NAMESPACE
                            kubectl --kubeconfig=$KUBECONFIG rollout status deployment/your-deployment --namespace=$K8S_NAMESPACE
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
