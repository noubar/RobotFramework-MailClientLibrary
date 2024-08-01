import os
import time
from os import error
import subprocess

class dockerControl:
    def __init__(self):

        if os.name == 'posix':
            # print('This is Linux')
            prefix = ""
        elif os.name == 'nt':
            # print('This is Windows')
            prefix = "Powershell "
        else:
            raise(error('The system is neither Linux nor Windows'))
        self.start_command = prefix + r"docker run --name greenmail --rm -d --platform linux -e GREENMAIL_OPTS='-Dgreenmail.setup.test.all -Dgreenmail.hostname=0.0.0.0 -Dgreenmail.users=user0:password0@mail.com,user1:password1@mail.com,user2:password2@mail.com,user3:password3@mail.com' -p 3143:3143 -p 3993:3993 -p 3110:3110 -p 3995:3995 -p 3025:3025 -p 3465:3465 -p 8080:8080 greenmail/standalone:2.1.0-rc-1"
        self.restart_command = prefix + r"docker container restart greenmail"
        self.stop_command = prefix + r"docker container stop greenmail"
        self.running_command = r'docker inspect -f "{{.State.Running}}" greenmail'


    def start_mail_server_docker(self):
        output =  subprocess.run(self.start_command, shell=True, capture_output=True, text=True)
        print("start docker command: returncode= ", output.returncode, " stdout= ",output.stdout, " stderr= ",output.stderr)
        if output.returncode != 0:
            raise(error("Mail server docker cannot be started"))
        self.wait_until_mail_server_docker_container_is_running()
        time.sleep(5)  # mail server init time

    def restart_mail_server_docker(self):
        output =  subprocess.run(self.restart_command, shell=True, capture_output=True, text=True)
        print("restart docker command: returncode= ", output.returncode, " stdout= ",output.stdout, " stderr= ",output.stderr)
        if output.returncode != 0:
            raise(error("Mail server docker cannot be restarted"))
        self.wait_until_mail_server_docker_container_is_running()

    def stop_mail_server_docker(self):
        output =  subprocess.run(self.stop_command, shell=True, capture_output=True, text=True)
        print("stop docker command: returncode= ", output.returncode, " stdout= ",output.stdout, " stderr= ",output.stderr)
        if output.returncode != 0:
            raise(error("Mail server docker cannot be stoped"))

    def wait_until_mail_server_docker_container_is_running(self):
        timeout = 0
        while (timeout) < 10:
            output =  subprocess.run(self.running_command, shell=True, capture_output=True, text=True )
            print("\nif docker running command: returncode= ", output.returncode, " stdout= ",output.stdout, " stderr= ",output.stderr)
            if bool(output.stdout) == True:
                return True
            time.sleep(2)
            timeout += 1
        raise(error("Mail server docker is not running"))