#!/usr/env/bin python

# Set up the mpiu user account on master and slave nodes.

import paramiko
import time
port = 22
username = "ubuntu"
password = "XXXXXX"

def mpiUserAdd():
    ipList = []
    hosts = open("/etc/hosts", "r")
    for line in hosts:
        ipList.append(line.split()[0])
    hosts.close()
    clusterList = ipList[1:]
    # Set up SSH connectiion with cluster members.
    print("Establishing SSH connection with cluster members. . .")
    for ip in clusterList:
        print("Establishing SSH connection with %s . . ." % (ip))
        s = paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(ip, port, username, password)
        time.sleep(1)
        print("SSH connection with %s established." % (ip))
        remote_conn = s.invoke_shell()
        print("Invoking interactive command shell with %s . . ." % (ip))
        time.sleep(1)
        remote_conn.send('sudo -i\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('mkdir -p /mirror/\n')
        print("nfsroot created on %s" % (ip))
        time.sleep(1)
        remote_conn.send('addgroup --gid 3000 mpiu\n')
        time.sleep(2)
        remote_conn.send('adduser --home /mirror/mpiu --uid 3000 --gid 3000 mpiu\n')
        print("Adding special user 'mpiu' to %s. . . " % (ip))
        time.sleep(1)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('\n')
        time.sleep(2)
        remote_conn.send('Y\n')
        print("Special user mpiu created on %s" % (ip))
        time.sleep(1)
        remote_conn.send('chown -R mpiu /mirror\n')
        print("Recursive ownership of '/mirror' granted to user mpiu on %s" % (ip))
        time.sleep(1)
        remote_conn.send('adduser mpiu sudo\n')
        print("Added user mpiu to sudo group on %s." % (ip))
        time.sleep(1)
    remote_conn.close()
    s.close()

mpiUserAdd()
