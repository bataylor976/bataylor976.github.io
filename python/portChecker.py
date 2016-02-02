#!/usr/bin/env python
# Special thanks to Noah Gift and Jeremy Jones

# Run script as follows: python portChecker.py -a <address> -p <port>

import socket
import re
import sys

def portChecker(address, port):
    s = socket.socket()	
    print "Connecting to %s on port %s" % (address, port)
    try:
        s.connect((address, port))
        print "Successfully connected to %s on port %s" % (address, port)
        return True
    except socket.error, e:
        print "Failed connection to %s on port %s: %s" % (address, port, e)
        return False

if __name__=='__main__':
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option("-a", "--address", dest="address", default='localhost', help="ADDRESS for server", metavar="ADDRESS")

    parser.add_option("-p", "--port", dest="port", type="int", default=80, help="PORT for server", metavar="PORT")

    (options, args) = parser.parse_args()
    print 'options: %s, args: %s' % (options, args)
    check = portChecker(options.address, options.port)
    print 'portChecker returned %s' % check
    sys.exit(not check)
