properties(defaultVars.projectProperties)

def rubyDockerBuildAndPush(rubyVersion) {
  libmysqlclient = rubyVersion == '2.5' ? 'default-libmysqlclient-dev' : 'libmysqlclient-dev'
  version = sh(returnStdout: true, script: 'cat ruby/VERSION').trim()
  tag = "docker.voxops.net/ruby:${rubyVersion}-${version}"
  sh "docker build ruby --no-cache --build-arg RUBY_VERSION=${rubyVersion} --build-arg LIBMYSQLCLIENT=${libmysqlclient} -t ${tag}"
  if (env.BRANCH == 'master') { sh "docker push ${tag}" }
}

pipeline {
  agent any
  stages {
    parallel {
      stage('local-dns') {
        environment { version = sh(returnStdout: true, script: 'cat local-dns/VERSION').trim() }
        steps {
          sh "docker build local-dns --no-cache -t docker.voxops.net/local-dns:$version"
          script { if (env.BRANCH == 'master') { sh "docker push docker.voxops.net/local-dns:$version" } }
        }
      }
      stage('ruby 2.2') { steps { rubyDockerBuild('2.2') } }
      stage('ruby 2.2') { steps { rubyDockerBuild('2.3') } }
      stage('ruby 2.2') { steps { rubyDockerBuild('2.4') } }
      stage('ruby 2.2') { steps { rubyDockerBuild('2.5') } }
    }
  }
}
