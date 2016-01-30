#!/usr/bin/env python

#Script-title: masqEdit.
#Author: Ben Taylor

#Purpose: to learn a little more about scripting 
#by creating an interactive prompt for making additional
#entries to dnsmasq.conf a little easier and less time-consuming.


from IPy import IP	#module to convert ip addresses to python objects.
import subprocess	#module to run bash commands in python scripts.

def masqEdit():
    #Open the current dnsmasq.conf file and store it as variable "f_old".
    f_old = open("/etc/dnsmasq.conf")
    
    #Open a new blank text file, store it as "f_new". 
    #This is the target file to which we will copy contents of "f_old".	
    f_new = open("/etc/dnsmasq.conf.new", "w")

    #Enter a comment line describing machine's purpose and owner.
    commentLine = raw_input("Enter a comment line: ")

    #Enter the hostname of the machine.
    hostName = raw_input("Enter hostname: ")

    #IP address of machine.
    ipAddr = raw_input("Enter ip address: ")

    #Mac address of machine.
    macAd = raw_input("Enter MAC address: ")
    
    #Using the IP module, we convert the ip address string to a an IP object, and store in variable "ipIpy".
    ipIpy = IP(ipAddr)
    
    #Call the reverseName method on variable "ipIpy" to reverse the ip address (e.g., 192.168.50.1 --> 1.50.168.192).
    #I included this because we might want to puppetize a machine, and Puppet requires a pointer record (i.e., ptr-record) for reverse dns lookups. 
    #However, I left the ptr-record line commented out by default. If we wish to puppetize, we will need to uncomment the ptr-record line.
    ipRev = ipIpy.reverseName()
    
    for line in f_old:		#Loop through f_old (i.e., the original dnsmasq.conf file)
        f_new.write(line)	#Write each line to f_new (i.e., dnsmasq.conf.new). 
        if '#address=/double-click.net/127.0.0.1' in line:		#Open up a line below this one, and write the following:
            f_new.write("# " + commentLine + "\n")
            f_new.write("address=" + "/" + hostName + "/" + ipAddr + "\n")
            f_new.write("#ptr-record=" + str(ipRev)[:-1] + "," + hostName + "\n")
        if '# is ignored and these names are not activated if DHCP doesn\'t assign' in line: #open a line below this line, and write the following:
            f_new.write("# " + commentLine + "\n")
            f_new.write("dhcp-host=" + macAd + "," + ipAddr + "," + hostName + "\n")
    f_old.close()
    f_new.close()
    subprocess.call(["rm", "/etc/dnsmasq.conf"]) 	#Remove the old dnsmasq.conf file.
    subprocess.call(["mv", "/etc/dnsmasq.conf.new", "/etc/dnsmasq.conf"])  #Replace the old dnsmasq.conf file with the new dnsmasq.conf file.

    addMore = raw_input("Add another entry? (y/n)? ")
    if addMore == "y":
        masqEdit()
    else:
        return
        
masqEdit()
