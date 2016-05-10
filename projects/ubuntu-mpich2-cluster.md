# Setting Up an MPICH2 Cluster in Ubuntu
# Special thanks to Ubuntu MPICH2 Documentation.

# In this demonstration, we have four nodes running Ubuntu Server 12.04 with these 
# host names: # mpich00, mpich01, mpich02, and mpich03.

![The following diagram generalized depiction of the cluster to be built.](project-imgs/mpich-diagram.png?raw=true "Cluster Diagram")

# Define hostnames in /etc/hosts/
# Edit /etc/hosts so that it looks like the example below: 

# Example
127.0.0.1     localhost
192.168.133.100 mpich00
192.168.133.101 mpich01
192.168.133.102 mpich02
192.168.133.103 mpich03

# Install openssh-server on each node.

blackbox@mpich00:~$ sudo apt-get install openssh-server
blackbox@mpich01:~$ sudo apt-get install openssh-server
blackbox@mpich02:~$ sudo apt-get install openssh-server

# NFS allows us to create a folder on the master node and have it sync with all the # other nodes. This folder can be used to store files and programs.

# To do this, install nfs-server on the master node, and then install nfs-client on 
# each slave node.  

blackbox@mpich00:~$ sudo apt-get install nfs-server
blackbox@mpich01:~$ sudo apt-get install nfs-client
blackbox@mpich02:~$ sudo apt-get install nfs-client
blackbox@mpich03:~$ sudo apt-get install nfs-client

# In the master node, create a master directory to store programs and files. For 
# the purposes of this demonstration, we’ll call this directory /mirror. 

blackbox@mpich00:~$ sudo mkdir /mirror
blackbox@mpich01:~$ sudo mkdir /mirror
blackbox@mpich02:~$ sudo mkdir /mirror 
blackbox@mpich03:~$ sudo mkdir /mirror

# Defining an MPI User. In master and slave nodes add mpiu user as described in 
# example below. Also, change ownership of /mirror to mpiu.
# Example: 

blackbox@mpich00:~$ sudo addgroup --gid 3000 mpiu
blackbox@mpich00:~$ sudo addgroup --gid 3000 mpiu
blackbox@mpich00:~S sudo adduser --home /mirror/mpiu --uid 3000 --gid 3000 mpiu
blackbox@mpich00:~$ sudo chown mpiu /mirror

# Repeat in each slave node.

# In both master and slave nodes, add mpiu to the sudo group.

blackbox@mpich00:~$ sudo visudo
blackbox@mpich01:~$ sudo visudo
blackbox@mpich02:~$ sudo visudo
blackbox@mpich03:~$ sudo visudo

# In the visudo shell, add the the following line just below "root    ALL=(ALL:ALL) 
# ALL":

mpiu     ALL=(ALL) ALL

# Next, we will map the /mirror/mpiu path created in the master node with 
# the /mirror directories in each of our slave nodes. To do this we will use a text 
# editor to add the following line to the end of the /etc/exports file on the 
# master node:

/mirror/mpiu *(rw,sync)

# Below is an example of the properly edited /etc/exports file in the master node.

# Example: 
# /etc/exports: the access control list for filesystems which may be exported
#to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
/mirror/mpiu *(rw,sync)

# Next, mount the /mirror directory on the other nodes. This can be done in a couple of ways. 

# Option 1: One-time command-line mount of /mirror 

# Example 6:
blackbox@mpich01:~$ sudo mount mpich00:/mirror/mpiu /mirror/mpiu
blackbox@mpich02:~$ sudo mount mpich00:/mirror/mpiu /mirror/mpiu
blackbox@mpich03:~$ sudo mount mpich00:/mirror/mpiu /mirror/mpiu

#Option 2: Edit the /etc/fstab file in each slave node to permanently mount 
# /mirror. This will ensure that the mount remains in the event of a reboot. To do # so, append the following line to the end of each slave node’s /etc/fstab file:

mpich00:/mirror/mpiu	/mirror/mpiu	nfs	 rw,hard,intr    0    0

/*
The following is a brief explanation of the options “rw,hard,intr    0    0”:

“rw”--This tells the system that in the event of a reboot, mount the /mirror directory as “read-write.”
“hard”--In the event of a server crash or network outage, this option causes the nfs-client to continue trying to remount the slave-node's /mirror to the same directory in the master until the server responds.
“intr”--In the event of a server crash or network outage, a process attempting to access a file in /mirror on the master node may hang. Without “intr” specified, the process cannot be killed or interrupted. With “intr” specified, the process process will then be able to pick up again where it left off once everything is back online. 

“0    0”--The first “0” tells the dump utility not to make a backup of the file system. For the purposes of this demonstration, such a backup will not be necessary. The second “0” tells fsck not to check the file system. This will also not be necessary. 
*/

# The fstab file on each slave node should appear as follows: 

Example:
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    nodev,noexec,nosuid 0       0
# / was on /dev/sda1 during installation  /        ext4    errors=remoun$
# swap was on /dev/sda5 during installation none	swap	sw	0	0
mpich00:/mirror/mpiu	/mirror/mpiu		nfs	rw,hard,intr    0    0 

# After editing the /etc/fstab file on each slave node, enter the following 
# command: 

blackbox@mpich01:~$ sudo mount -a

# Be sure to repeat these steps on each of the remaining slave nodes. 

# Set up passwordless SSH for communication between nodes on the cluster.
# First log in to the master node as user mpiu:

blackbox@mpich00:~$ su - mpiu

# Generate an RSA key pair for mpiu on master node.

mpiu@mpich00:~$ ssh-keygen -t rsa

# Keep the default ~/.ssh/id_rsa location. For security reasons, it is suggested 
# that you enter a strong passphrase.

mpiu@mpich00:~$ cd .ssh
mpiu@mpich00:~/.ssh$ cat id_rsa.pub >> authorized_keys

# Install and setup keychain:
mpiu@mpich00:~$ sudo apt-get install keychain

# On the master node, append the following script to mpiu's .bashrc file.

# Example 12:
if type keychain >/dev/null 2>/dev/null; then
  keychain --nogui -q id_rsa
  [ -f ~/.keychain/${HOSTNAME}-sh ] && . ~/.keychain/${HOSTNAME}-sh
  [ -f ~/.keychain/${HOSTNAME}-sh-gpg ] && . ~/.keychain/${HOSTNAME}-sh-gpg
fi

# Install the GNU Compiler Collection (GCC) on the master node.

mpiu@mpich00:~$ sudo apt-get install build-essential

# Install mpich2 on all nodes.

mpiu@mpich00:~$ sudo apt-get install mpich2

# Test MPICH2 installation by running the following commands:
mpiu@mpich00:~$  which mpiexec
mpiu@mpich00:~$  which mpirun

# It should return /usr/bin/mpiexec and /usr/bin/mpirun, respectively.

# Create a machinefile on the master node in user mpiu's home directory.

mpiu@mpich00:~$ touch machinefile

# Enter node names followed by a colon and a number of processes to spawn (Note: 
# The number of processes for each depends on the number of cpu cores in each node, 
# as well as the kinds of processes you seek to run. See below.).   

mpiu@mpich00:~$ vi machinefile

mpich03:4  # mpich03's processor has four cores, hence four processes spawned 
mpich02:2  # mpich02's has two cores, hence 2 processes spawned 
mpich01    # mpich01 has only one single-core rocessor, hence one process spawned
mpich00    # mpich00 has one processor, hence one process spawned

# Create the following c script on the master node in user mpiu's home directory:
# Name it "mpi_hello.c". 

#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv) {
    int myrank, nprocs;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

    printf("Hello from processor %d of %d\n", myrank, nprocs);

    MPI_Finalize();
    return 0;
}

# Compile mpi_hello.c with the following command:

mpiu@mpich00:~$ mpicc mpi_hello.c -o mpi_hello

# After compiling it, run it using the following command (the parameter next to -n # specifies the number of processes to spawn and distribute among nodes): 

mpiu@mpich00:~$ mpiexec -n 8 -f machinefile ./mpi_hello

# You should now see output similar to this:

Hello from processor 0 of 8
Hello from processor 1 of 8
Hello from processor 2 of 8
Hello from processor 3 of 8
Hello from processor 4 of 8
Hello from processor 5 of 8
Hello from processor 6 of 8
Hello from processor 7 of 8

# MPI cluster is complete.








