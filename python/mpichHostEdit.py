#!/usr/env/bin python

# MPICH cluster hosts file edit.
# Assumes that the default regular user on remote machines is a member of sudo group.
# Assumes that openssh-server is already installed.

import subprocess

def fileCopyDel():
    hostsOrig = open("/etc/hosts")
    hostsBu = open("/etc/hosts.bu", "w")
    for line in hostsOrig:      #Loop through hostsOrig (i.e., the original /etc/hosts file)
        hostsBu.write(line)  #Write each line to hostsBu (i.e., backup of /etc/hosts)
    hostsBu.close()
    hostsOrig.close()
    subprocess.call(["rm", "/etc/hosts"])       #Remove the old /etc/hosts file.

def hostsNew():
    hostsMpi = open("/etc/hosts", "w")  #Create a new empty hosts file.
    hostsMpi.write('127.0.0.1\tlocalhost\n')
    masterName = raw_input("Please enter master node's hostname: ")
    masterIp = raw_input("Please enter master node's ip address: ")
    hostsMpi.write(masterIp + '\t' + masterName + '\n')
    hostsMpi.close()

def slaveAdd():
    hostsMpi = open("/etc/hosts", "a")
    slaveName = raw_input("Please enter slave hostname: ")
    slaveIp = raw_input("Please enter slave ip address: ")
    hostsMpi.write(slaveIp + '\t' + slaveName + '\n')
    addMore = raw_input("Add another slave node? (y/n)? ")
    if addMore == 'y':
        slaveAdd()
    else:
        return
    hostsMpi.close()
    print('New cluster hosts file completed.')

def copyLeft():
    subprocess.call(['cp', '/etc/hosts', '/home/ubuntu/hosts'])
    subprocess.call(['chown', 'ubuntu', '/home/ubuntu/hosts'])
    print('Preparing hosts file for transfer to remote system.')

def fileReplace():
    print('Establishing SFTP connection with slave nodes. . . ')
    import paramiko
    import time
    port = 22
    username = "ubuntu"
    password ="XXXXXXX"
    ipList = []
    hosts = open("/etc/hosts", "r")
    for line in hosts:
        ipList.append(line.split()[0])
    clusterList = ipList[2:]
    for ip in clusterList:
        transport = paramiko.Transport((ip, port))
        transport.connect(username = username, password = password)
        sftp = paramiko.SFTPClient.from_transport(transport)
        filepath = '/home/ubuntu/hosts'
        localpath = '/home/ubuntu/hosts'
        sftp.put(filepath, localpath)
        print('SFTP transfer complete for %s' % (ip))
        transport.close()
        s = paramiko.SSHClient()
        s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        s.connect(ip, port, username, password)
        remote_conn = s.invoke_shell()
        print('Replacing local hosts file on %s with cluster hosts file . . .' % (ip))
        remote_conn.send('sudo -i\n')
        time.sleep(2)
        remote_conn.send('xxxxxx\n')
        time.sleep(2)
        remote_conn.send('rm /etc/hosts\n')
        time.sleep(2)
        remote_conn.send('cp /home/ubuntu/hosts /etc\n')
        time.sleep(1)
        print('Replacement complete.')

fileCopyDel()
hostsNew()
slaveAdd()
copyLeft()
fileReplace()
