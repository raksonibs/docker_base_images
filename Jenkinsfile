properties(defaultVars.projectProperties)

pipeline {
  agent any
  environment {
    DNS_TAG = sh(returnStdout: true, script: 'cat local-dns/VERSION').trim()
  }
  stages {
    stage('local-dns') {
      steps {
        sh "docker build --no-cache -t docker.voxops.net/local-dns:$DNS_TAG local-dns"
        script { if (env.BRANCH == 'master') { sh "docker push docker.voxops.net/local-dns:$DNS_TAG" } }
      }
    }
  }
}
