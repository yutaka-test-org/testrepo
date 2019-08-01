pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh """
                eval \$(aws ecr get-login --no-include-email --region ap-northeast-1)
                docker build -t yutaka-testrepo .
                docker tag yutaka-testrepo:latest 566423514641.dkr.ecr.ap-northeast-1.amazonaws.com/yutaka-testrepo:latest
                docker push 566423514641.dkr.ecr.ap-northeast-1.amazonaws.com/yutaka-testrepo:latest
                """
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
