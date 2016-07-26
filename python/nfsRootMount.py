#!/usr/bin/env python

# Creat nfs share on master node.
# export to client nodes
# mount client nodes to nfs share.

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
        remote_conn.send('service nfs-kernel-server stop\n')
        time.sleep(2)
        print('Stopping nfs-kernel-server on %s.' % (ip))
        time.sleep(2)
        remote_conn.send('cp /etc/exports /etc/exports.orig\n')
        time.sleep(2)
        print('Backing up "/etc/exports" file on %s.' % (ip))
        time.sleep(2)
        remote_conn.send('echo "/mirror/mpiu *(rw,sync)" | sudo tee -a /etc/exports\n')
        time.sleep(2)
        print('nfsroot filepath appended to "/etc/exports" on %s.' % (ip))
        time.sleep(2)
        remote_conn.send('service nfs-kernel-server start\n')
        time.sleep(2)
        print('Restarting nfs-kernel-server on %s.' % (ip))
        remote_conn.close()
        s.close()
    elif ip != clusterList[0]:
        s = paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(ip, port, username, password)
        print("SSH connection with %s established." % (ip))
        time.sleep(2)
        print("Invoking interactive command shell with %s . . ." % (ip))
        remote_conn = s.invoke_shell()
        print("Interactive command shell established with %s . . ." % (ip))
        time.sleep(2)
        remote_conn = s.invoke_shell()
        time.sleep(2)
        remote_conn.send('sudo -i\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('mount %s:/mirror/mpiu /mirror/mpiu\n' % (clusterList[0]))
        time.sleep(2)
        print('NFS client directory mounted to nfsroot directory on %s.' % (ip))
        time.sleep(2)
        remote_conn.close()
        s.close()
