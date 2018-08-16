properties(defaultVars.projectProperties)

def lint(image) {
  sh "docker run -v \$(pwd)/${image}/Dockerfile:/Dockerfile -v \$(pwd)/${image}/.dockerfilelintrc:/.dockerfilelintrc replicated/dockerfilelint /Dockerfile"
}

def rubyDockerBuildAndPush(rubyVersion, branch) {
  def buildArgs = "--build-arg RUBY_VERSION=${rubyVersion}"
  dockerBuildAndPush('ruby', branch, buildArgs, "${rubyVersion}-")
}

def dockerBuildAndPush(image, branch, buildArgs = '', versionPrefix = '') {
  def version = sh(returnStdout: true, script: "cat ${image}/VERSION").trim()
  def tag = "docker.voxops.net/${image}:${versionPrefix}${version}"
  sh "docker build ${image} ${buildArgs} -t ${tag} --build-arg IMAGE_VERSION=${version}"
  if (branch == 'master') { sh "docker push ${tag}" }
}

pipeline {
  agent any
  stages {
    stage('Lint') {
      parallel {
        stage('local-dns') { steps { lint('local-dns') } }
        stage('ruby') { steps { lint('ruby') } }
        stage('capistrano') { steps { lint('capistrano') } }
      }
    }
    stage('Build and Push') {
      when { branch 'master' }
      parallel {
        stage('local-dns') {
          when { changeset 'local-dns/VERSION' }
          steps { dockerBuildAndPush('local-dns', env.GIT_BRANCH) }
        }
        stage('ruby 2.3') {
          when { changeset 'ruby/VERSION' }
          steps { rubyDockerBuildAndPush('2.3', env.GIT_BRANCH) }
        }
        stage('ruby 2.4') {
          when { changeset 'ruby/VERSION' }
          steps { rubyDockerBuildAndPush('2.4', env.GIT_BRANCH) }
        }
        stage('ruby 2.5') {
          when { changeset 'ruby/VERSION' }
          steps { rubyDockerBuildAndPush('2.5', env.GIT_BRANCH) }
        }
        stage('capistrano') {
          when { changeset 'capistrano/VERSION' }
          steps { dockerBuildAndPush('capistrano', env.GIT_BRANCH) }
        }
      }
    }
  }
}
