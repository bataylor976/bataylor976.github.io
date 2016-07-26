#!/usr/bin/env python

# Install nfs-kernel-server on master node.
# Install nfs-client on slave nodes.

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
clusterList = ipList[1:]
for ip in clusterList:
    if ip == clusterList[0]:
        s = paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(ip, port, username, password)
        print("SSH connection with %s established." % (ip))
        time.sleep(2)
        print("Invoking interactive command shell with %s . . ." % (ip))
        remote_conn = s.invoke_shell()
        print("Interactive command shell established with %s . . ." % (ip))
        time.sleep(2)
        remote_conn.send('sudo -i\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('apt-get -y install nfs-kernel-server\n')
        time.sleep(2)
        print("nfs-kernel-server installed on %s." % (ip))
        time.sleep(2)
        remote_conn.send('logout\n')
        time.sleep(2)
        print("Logging out of %s." % (ip))
        remote_conn.close()
        s.close()
    elif ip != clusterList[0]:
        s = paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(ip, port, username, password)
        print("SSH connection with %s established." % (ip))
        time.sleep(1)
        print("Invoking interactive command shell with %s . . ." % (ip))
        remote_conn = s.invoke_shell()
        print("Interactive command shell established with %s . . ." % (ip))
        time.sleep(2)
        remote_conn.send('sudo -i\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('apt-get -y install nfs-common\n')
        time.sleep(2)
        print("nfs-common installed on %s." % (ip))
        time.sleep(2)
        remote_conn.send('logout\n')
        time.sleep(2)
        print("Logging out of %s." % (ip))
        remote_conn.close()
        s.close()
