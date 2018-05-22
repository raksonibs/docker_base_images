properties(defaultVars.projectProperties)

def rubyBuild(rubyVersion) {
  libmysqlclient = rubyVersion == '2.5' ? 'default-libmysqlclient-dev' : 'libmysqlclient-dev'
  buildArgs = "--build-arg RUBY_VERSION=${rubyVersion} --build-arg LIBMYSQLCLIENT=${libmysqlclient}"
  build(image: 'ruby', buildArgs: buildArgs)
}

def build(image, buildArgs = nil) {
  version = sh(returnStdout: true, script: "cat ${image}/VERSION").trim()
  tag = "docker.voxops.net/${image}:${version}"
  sh "docker build --no-cache ${image} ${buildArgs} --no-cache -t ${tag}"
  if (env.BRANCH == 'master') { sh "docker push ${tag}" }
}

pipeline {
  agent any
  stages {
    stage('Build') {
      parallel {
        stage('local-dns') { steps { build(image: 'local-dns') } }
        stage('ruby 2.2') { steps { rubyBuild('2.2') } }
        stage('ruby 2.3') { steps { rubyBuild('2.3') } }
        stage('ruby 2.4') { steps { rubyBuild('2.4') } }
        stage('ruby 2.5') { steps { rubyBuild('2.5') } }
      }
    }
  }
}
