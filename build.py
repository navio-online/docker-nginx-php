from navio.builder import task,nsh, sh, dump


@task()
def docker_login():
  docker_login = sh.aws('ecr get-login --profile shoeshiii --no-include-email'.split(' ')).strip()[7:].split(' ')
  nsh.docker(docker_login)

@task(docker_login)
def build():
  nsh.docker('build --rm=true -t nginx-php .'.split(' '))

@task(docker_login)
def push():
  nsh.docker.tag(
      'nginx-php:latest', 
      '688592707036.dkr.ecr.eu-west-1.amazonaws.com/nginx-php:latest'
    )
  nsh.docker.push(
      '688592707036.dkr.ecr.eu-west-1.amazonaws.com/nginx-php:latest'
    )

@task(docker_login)
def pull():
  nsh.docker.pull('688592707036.dkr.ecr.eu-west-1.amazonaws.com/nginx-php:latest')

