properties(defaultVars.projectProperties)

def getTag(name) { new File("${name}/VERSION").text }

pipeline {
  agent any
  environment {
    DNS_TAG = getTag('local-dns')
  }
  stages {
    stage('Build') {
      steps { sh "docker build --no-cache -t docker.voxops.net/local-dns:$DNS_TAG ." }
    }
    stage('Push') {
      when { branch 'master' }
      steps { sh "docker push docker.voxops.net/local-dns:$DNS_TAG" }
    }
  }
}
