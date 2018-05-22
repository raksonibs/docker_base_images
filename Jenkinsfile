properties(defaultVars.projectProperties)

pipeline {
  environment {
    DNS_TAG = new File('local-dns/VERSION').text
  }
  stages {
    parallel {
      stage('local-dns') {
        stage('build') {
          steps { sh "docker build --no-cache -t docker.voxops.net/local-dns:$DNS_TAG ." }
        }
        stage('push') {
          when { branch 'master' }
          steps { sh "docker push docker.voxops.net/local-dns:$DNS_TAG" }
        }
      }
    }
  }
}
