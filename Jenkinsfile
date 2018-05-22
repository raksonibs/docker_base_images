properties(defaultVars.projectProperties)

pipeline {
  agent any
  environment {
    DNS_TAG = sh(returnStdout: true, script: 'cat local-dns/VERSION').trim()
  }
  stages {
    stage('local-dns') {
      steps {
        script {
          stage('Build') {
            steps { sh "docker build --no-cache -t docker.voxops.net/local-dns:$DNS_TAG local-dns" }
          }
          stage('Push') {
            when { branch 'master' }
            steps { sh "docker push docker.voxops.net/local-dns:$DNS_TAG" }
          }
        }
      }
    }
  }
}
