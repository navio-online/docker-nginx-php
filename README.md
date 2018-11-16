Xdebug Configuration for IDE:

- xdebug.remote_host={{REMOTE_HOST}}               - Specify an IP Address -e REMOTE_HOST=<Your_ip>
- xdebug.remote_port=9000
- xdebug.idekey="PHPDEBUG"

1) - docker run -d  
       -   -e ENABLE_XDEBUG=1                     - Enable or disable Xdebug(1-enable/0-disable)
       -   -e REMOTE_HOST=<Your_ip>               - Selects the host where the debug client is running(default localhost)
       -   -e ENVIRONMENT=development             - (development/production)
       -   -p 80:80  alpine
2) - sftp -oIdentityFile=<Private key>/home/key nginx@172.17.0.2 - Log in with an specified SSH private key

- KEY:

-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAz0hDbHaB0xB5txHHEGLcvXI3li1tUeqUEc2LZFQuL5Z14YBZ
OAoGWHzb9gY9vu5JPRMLW33KP0L6oov6+vnrAad4rODvoQzZIVm826MvHKAae0NN
a7uhweDmOuE/8iGwuaZ9ytxan/2JSyqOjRYGXp+1zKPIsUfdHE9KuWTcB5Ub9lT3
oi0eW6G5aOKI/9jTiol9/lM3KpNCcvxiuevRd9c8mLqZz2c2bn9C74D0xCCxerU1
GVq4/f8FJquDHxclmf9frhQFpZ3dMCcFkQAm5iP6s7JIrZmCjqOpnTW0tauFceTh
92c5eOEe7IJf5o4nFjUD0t7ViiT84OolxHq5PQIDAQABAoIBAHRh8aFrpJcacAyv
CaMUrzYbdER4+yF8YWjhjLtnXItRopxbkTyavFdgu6wWcwLKDgshr0XOigkdFVbA
28mhGydRnbsLjOBTM3K7TQPRSvl6l4PQFR9BOaB/IyW6JUpRSkXiykxljui31SeE
HIfw7uCgMdZVu7B2Vhq4Fo+jprsGJWZcas2iyA1oYGI8AI3fjiFuMxk8KEA2DtE1
9Rkz8SylO2P/7jP72gZ/TxEm4fg76xftn2f7QXHZCrvUmxe4ttmkdi14UA5bqll1
bTTCgn9BmY5QAbKkevDvCH0EY09XrQ7F1xZwRt4aqGyVxat+SqD4vRvC1D1/FflA
FB7Z+eECgYEA9pZHr8Qz3JOStasTHskulK28jNxx+cJSONSIvVOiZpu2OI42B3dP
fgvlUTgOXi8Hw6wQQwp7qkrYg/84rzM9p8RQaYeExYBcfPjwPw3Nneth/XlUqtTj
O4H+4KSt1MqVOZG+vhwrehixVRvZ89JfOsLmgwBB2Cy+7yEkWSl08gUCgYEA1zHi
yurap6ce7UsrKpzZmHEsDjlPPfKEYAKdUSCRy92NZmffb9ERsDqha01sA06Wiznw
QrpxQ780IuhE0/0ToMG+BJZJeWlfyY1WWyKvBgACe5G/8OjfQffEAWnQW7qBftG4
f0/09slKbGEyb2VBKCXIq0yZaevF8KNoglF4t9kCgYAcohKs7EGBaXltsvHDb2UD
SrFMQgTSFahqhPNj2KRQ+d/M7WaEs2v9nPAB4Fp6wUdLh11UC5GUkqBVo3s3jOGp
63fS6TOXo3IZ6OYszDOGFOEKB962/4VrUYsBFt5AiU2Oo8fcV3UM9nURBuzmDRWV
wy/1IkCDE58QMW8BE3lK6QKBgHbHlFVI2LQdbNax3PvCY+De5uBbBcA9so+EIe17
ur36ZmgWAaCol8jcM+kUbQBOSo5CxrkuTAKG8XIrHoKceE8NYaMKiTe40CRiHT5k
oJMBQl2Oj5GcGE9DQS8+hsF66qtjeyDas23coXW9GKegDhzo7iCPQUbT2wf+SltU
OPvRAoGAB+GJzU8i6cv+88I07pNRCI6Zx/x4eBFOnSl37b32wTsjKg7C1FddEOqP
Dlpnn5V30Gk7gifPmysTljszxxaCpoGFc2EidcGaFfpgRQP/u583s8tnSBN1Wsgx
8KjHkAFSYum+X4YibOkalSP/9rsIT16UFJKUke5FDL6zaCocEiw=
-----END RSA PRIVATE KEY-----



3) - sftp nginx@172.17.0.2                          - Log in with an password 'ea01609e5cc4407f'
