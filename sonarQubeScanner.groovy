pipeline{
  node {
    stage('SCM') {
      git 'https://github.com/OmarMSaber/simple-web-app-devops.git'
    }
    stage('SonarQube analysis') {
      def scannerHome = tool 'SonarScanner 4.0';
      withSonarQubeEnv('SonarQubeServer') {
        sh "${scannerHome}/bin/sonar-scanner"
      }
    }
  }
}
