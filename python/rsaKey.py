#!/usr/bin/env python

# Distribute rsa_pub key of mpiu user on master node.
# Generated inside mounted nfs share, so should automatically distribute 
# via nfs to the client nodes.

import paramiko
import time
port = 22
username = "mpiu"
password = "XXXXXX"

ipList = []
hosts = open("/etc/hosts", "r")
for line in hosts:
    ipList.append(line.split()[0])
hosts.close()
masterIp = ipList[1]

# Create rsa keys on master node.
def sshKeyGen():
    #def outPut():
        #print('*******************************************') 
        #print('*******************************************')
        #output = remote_conn.recv(5000)
        #print output
        #print('*******************************************') 
        #print('*******************************************')

    print("Establishing SSH connection with %s" % (masterIp))
    s = paramiko.SSHClient()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    time.sleep(2)
    s.connect(masterIp, port, username, password)
    print("SSH connection with %s established." % (masterIp))
    time.sleep(2)
    print("Invoking interactive command shell with %s . . ." % (masterIp))
    remote_conn = s.invoke_shell()
    print("Interactive command shell established with %s . . ." % (masterIp))
    time.sleep(2)
    print("Generating RSA keys on %s . . . " % (masterIp))
    time.sleep(2)
    remote_conn.send('ssh-keygen -t rsa\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('\n')
    time.sleep(2)
    remote_conn.send('xxxxxx\n')
    time.sleep(2)
    remote_conn.send('xxxxxx\n')
    time.sleep(5)
    print("RSA keys created.")
    time.sleep(2)
    #outPut()
    remote_conn.send('cat .ssh/id_rsa.pub >> .ssh/authorized_keys\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    print("RSA public key copied to authorized_keys file.")
    print("Installing keychain for mpiu@%s . . ." % (masterIp))
    remote_conn.send('sudo apt-get install keychain\n')
    time.sleep(2)
    remote_conn.send('xxxxxx\n')
    time.sleep(16)
    print("Keychain installed for mpiu@%s." % (masterIp))
    #time.sleep(2)
    #outPut()
    remote_conn.send('cat >> /mirror/mpiu/.bashrc << "EOF"\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('if type keychain >/dev/null 2>/dev/null; then\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('  keychain --nogui -q id_rsa\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('  [ -f ~/.keychain/${HOSTNAME}-sh ] && . ~/.keychain/${HOSTNAME}-sh\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('  [ -f ~/.keychain/${HOSTNAME}-sh-gpg ] && . ~/.keychain/${HOSTNAME}-sh-gpg\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    remote_conn.send('fi\n')
    time.sleep(2)
    remote_conn.send('EOF\n')
    time.sleep(2)
    #outPut()
    #time.sleep(2)
    print("SSH agent keychain script appended to mpiu's .bashrc file.")
    stdin, stdout, stderr = s.exec_command('touch /mirror/mpiu/.ssh/config')
    time.sleep(2)
    remote_conn.send('cat >> /mirror/mpiu/.ssh/config << "EOF"\n')
    time.sleep(2)
    remote_conn.send('Host *\n')
    time.sleep(2)
    remote_conn.send('    StrictHostKeyChecking no\n')
    time.sleep(2)
    remote_conn.send('EOF\n')
    time.sleep(2)
    remote_conn.close()
    s.close()

sshKeyGen()
