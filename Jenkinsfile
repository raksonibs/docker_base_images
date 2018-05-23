properties(defaultVars.projectProperties)

def lint(image) {
  sh "docker run -v \$(pwd)/${image}/Dockerfile:/Dockerfile -v \$(pwd)/${image}/.dockerfilelintrc:/.dockerfilelintrc replicated/dockerfilelint /Dockerfile"
}

def rubyDockerBuildAndPush(rubyVersion) {
  libmysqlclient = rubyVersion == '2.5' ? 'default-libmysqlclient-dev' : 'libmysqlclient-dev'
  buildArgs = "--build-arg RUBY_VERSION=${rubyVersion} --build-arg LIBMYSQLCLIENT=${libmysqlclient}"
  dockerBuildAndPush('ruby', buildArgs)
}

def dockerBuildAndPush(image, buildArgs = '') {
  version = sh(returnStdout: true, script: "cat ${image}/VERSION").trim()
  tag = "docker.voxops.net/${image}:${version}"
  sh "docker build ${image} ${buildArgs} --no-cache -t ${tag}"
  if (env.BRANCH == 'master') { sh "docker push ${tag}" }
}

pipeline {
  agent any
  stages {
    stage('Lint') {
      parallel {
        stage('local-dns') { steps { lint('local-dns') } }
        stage('ruby') { steps { lint('ruby') } }
      }
    }
    stage('Build and Push') {
      parallel {
        stage('local-dns') { steps { dockerBuildAndPush('local-dns') } }
        stage('ruby 2.2') { steps { rubyDockerBuildAndPush('2.2') } }
        stage('ruby 2.3') { steps { rubyDockerBuildAndPush('2.3') } }
        stage('ruby 2.4') { steps { rubyDockerBuildAndPush('2.4') } }
        stage('ruby 2.5') { steps { rubyDockerBuildAndPush('2.5') } }
      }
    }
  }
}