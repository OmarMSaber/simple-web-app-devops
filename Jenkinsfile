def awsCredentials = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-personal']]

pipeline {
  agent none

  options {
    disableConcurrentBuilds()
    timestamps()
    withCredentials(awsCredentials)
  }

  stages {
   stage('Build') {
     agent {
       node {
         label 'test-EC2'
        }
      }
      steps{
            echo "build Stage"
          }
       }
    stage('Test') {
     agent {
       node {
         label 'test-EC2'
        }
       }
       steps {
            echo "Test Stage"
          }
        }
    stage('Deploy') {
      agent {
        node {
          label 'Deployment-EC2'
         }
        }
      steps {
        echo "Deploy Stage"
      }
    }
  }
}
