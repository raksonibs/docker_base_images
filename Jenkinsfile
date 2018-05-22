properties(defaultVars.projectProperties)

def getTag(name) { new File("${name}/VERSION").text }

pipeline {
  environment {
    DNS_TAG = getTag('local-dns')
  }
  stages {
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
