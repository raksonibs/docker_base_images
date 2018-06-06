properties(defaultVars.projectProperties)

def lint(image) {
  sh "docker run -v \$(pwd)/${image}/Dockerfile:/Dockerfile -v \$(pwd)/${image}/.dockerfilelintrc:/.dockerfilelintrc replicated/dockerfilelint /Dockerfile"
}

def rubyDockerBuildAndPush(rubyVersion, branch) {
  def libmysqlclient = rubyVersion == '2.2' ? 'libmysqlclient-dev' : 'default-libmysqlclient-dev'
  def buildArgs = "--build-arg RUBY_VERSION=${rubyVersion} --build-arg LIBMYSQLCLIENT=${libmysqlclient}"
  dockerBuildAndPush('ruby', branch, buildArgs, "${rubyVersion}-")
}

def dockerBuildAndPush(image, branch, buildArgs = '', versionPrefix = '') {
  def version = sh(returnStdout: true, script: "cat ${image}/VERSION").trim()

  ['docker.voxops.net', 'voxmedia'].each {
    def tag = "${it}/${image}:${versionPrefix}${version}"
    sh "docker build ${image} ${buildArgs} -t ${tag}"
    if (branch == 'master') { sh "docker push ${tag}" }
  }
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
        stage('local-dns') { steps { dockerBuildAndPush('local-dns', env.GIT_BRANCH) } }
        stage('ruby 2.2') { steps { rubyDockerBuildAndPush('2.2', env.GIT_BRANCH) } }
        stage('ruby 2.3') { steps { rubyDockerBuildAndPush('2.3', env.GIT_BRANCH) } }
        stage('ruby 2.4') { steps { rubyDockerBuildAndPush('2.4', env.GIT_BRANCH) } }
        stage('ruby 2.5') { steps { rubyDockerBuildAndPush('2.5', env.GIT_BRANCH) } }
      }
    }
  }
}
