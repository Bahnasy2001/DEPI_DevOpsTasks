pipeline {
    agent {label 'docker'}
    parameters {
        choice choices: ['dev', 'prod', 'nginx'], name: 'environment'
    }
    stages {
        stage('preparation') {
            steps {
                // Clone the repository with explicit parameters
                git(
                    url: 'https://github.com/Bahnasy2001/spring-pet-clinic',
                    branch: 'main'
                )
            }
        }
        // stage('ci') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        //             // Build Docker image
        //             sh 'docker build . -t hassanbahnasy/spring-pet-clinic'
                    
        //             // Log in to Docker Hub
        //             sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    
        //             // Push Docker image to Docker Hub
        //             sh 'docker push hassanbahnasy/spring-pet-clinic'
        //         }
        //     }
            
        // }
        stage('cd') {
            steps {
                // Explicitly use bash
                echo "Test"
                echo "Environment parameter: ${params.environment}"
                sh "docker compose -f docker-compose.yml -f docker-compose-${params.environment}.yml down --remove-orphans"
                sh "docker compose -f docker-compose.yml -f docker-compose-${params.environment}.yml up -d --build"
            
            }
        } 
    }
     post {
            success {
                // One or more steps need to be included within each condition's block.
                slackSend(channel:"depi", color:'#00FF00',message: "Succeeded: Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'")
            }
            failure {
                // One or more steps need to be included within each condition's block.
                 slackSend(channel:"depi", color:'#FF0000',message: "Failed: Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'")
            }
        }
}
