from navio.builder import task,nsh, sh, dump

def _truncate_file(filename, header_line, footer_line):
  pos = 0
  with open(filename,"r") as f:
    lines = f.readlines()

  with open(filename,"w") as f:
    for line in lines:
      if pos == 0 and header_line not in line:
        continue
      elif pos == 0:
        pos = 1
        continue

      if pos == 1 and footer_line in line:
        pos = 2

      if pos == 1:
        if 'COPY docker-php-' in line:
          continue
        elif 'RUN docker-php-' in line:
          continue
        elif 'WORKDIR /var/www/html' in line:
          continue
        elif 'ENTRYPOINT ["docker-php-entrypoint"]' in line:
          continue
        else:
          f.write(line)

@task()
def get_php():
  nsh.curl(
    '-o','Dockerfile-php',
    'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/Dockerfile'
  )
  nsh.curl(
    '-o', 'files/usr/local/bin/docker-php-ext-configure',
    'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/docker-php-ext-configure'
  )
  nsh.curl(
    '-o', 'files/usr/local/bin/docker-php-ext-enable',
    'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/docker-php-ext-enable'
  )
  nsh.curl(
    '-o', 'files/usr/local/bin/docker-php-ext-install',
    'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/docker-php-ext-install'
  )
  nsh.curl(
    '-o', 'files/usr/local/bin/docker-php-source',
    'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/docker-php-source'
  )

@task()
def get_python():
  nsh.curl(
    '-o','Dockerfile-python',
    'https://raw.githubusercontent.com/docker-library/python/master/3.7/alpine3.8/Dockerfile'
  )

@task()
def get_nginx():
  nsh.curl(
    '-o','Dockerfile-nginx',
    'https://raw.githubusercontent.com/nginxinc/docker-nginx/master/stable/alpine/Dockerfile'
  )

@task(get_php, get_nginx, get_python)
def get_all():
  pass


  
# @task()
# def python():
#   nsh.curl(
#     '-o','Dockerfile-python',
#     'https://raw.githubusercontent.com/docker-library/python/master/3.7/alpine3.8/Dockerfile'
#   )
#   nsh.git.add('Dockerfile-python')
#   nsh.git.commit('Dockerfile-python', '-m', 'original clone')

#   _truncate_file('Dockerfile-python', 'FROM alpine:3.8', 'CMD ["python3"]')

#   nsh.git.add('Dockerfile-python')
#   nsh.git.commit('Dockerfile-python', '-m', 'header/footer removed')

# @task()
# def php():
#   nsh.curl(
#     '-o','Dockerfile-php',
#     'https://raw.githubusercontent.com/docker-library/php/master/7.2/alpine3.8/fpm/Dockerfile'
#   )
#   nsh.git.add('Dockerfile-php')
#   nsh.git.commit('Dockerfile-php', '-m', 'original clone')

#   _truncate_file('Dockerfile-php', 'FROM alpine:3.8', 'EXPOSE 9000')

#   nsh.git.add('Dockerfile-php')
#   nsh.git.commit('Dockerfile-php', '-m', 'header/footer removed')

# @task()
# def nginx():
#   nsh.curl(
#     '-o','Dockerfile-nginx',
#     'https://raw.githubusercontent.com/nginxinc/docker-nginx/master/stable/alpine/Dockerfile'
#   )
#   nsh.git.add('Dockerfile-nginx')
#   nsh.git.commit('Dockerfile-nginx', '-m', 'original clone')

#   _truncate_file('Dockerfile-nginx', 'LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"', 'COPY nginx.conf /etc/nginx/nginx.conf')

#   nsh.git.add('Dockerfile-nginx')
#   nsh.git.commit('Dockerfile-nginx', '-m', 'header/footer removed')

@task()
def combine():

  with open('Dockerfile-template', "r") as f:
    docker_file = f.readlines()  

  with open('Dockerfile', "w") as f:
    for dline in docker_file:
      if '## REPLACE ##' not in line:
        f.write(dline)
      else:
        f.write('## PYTHON START ########################################\n\n')
        with open('Dockerfile-python','r') as p:
          for line in p.readlines():
            f.write(line)
        f.write('## PYTHON STOP ########################################\n\n')

        f.write('## NGINX START ########################################\n\n')
        with open('Dockerfile-nginx','r') as p:
          for line in p.readlines():
            f.write(line)
        f.write('## NGINX STOP ########################################\n\n')

        f.write('## PHP START ########################################\n\n')
        with open('Dockerfile-php','r') as p:
          for line in p.readlines():
            f.write(line)
        f.write('## PHP STOP ########################################\n\n')



