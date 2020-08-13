def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-personal']]

pipeline {
  agent {
    node {
      label 'test-EC2'
    }
  }

  options {
    disableConcurrentBuilds()
    timestamps()
    withCredentials(awsCredentials)
  }

  stages {
    stage('Build') {
      steps{
            echo "build Stage"
          }
        }
    stage('Test') {
          steps {
            echo "Test Stage"
          }
        }
    stage('Deploy') {
      steps {
        echo "Deploy Stage"
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
