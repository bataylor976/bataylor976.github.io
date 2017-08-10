#!/bin/python

'''
Returns a list of users with a last-sign-in prior to a specified date, and then block those users.
'''

import yaml
import gitlab
import time
from datetime import datetime, date, time, timedelta
import dateutil.parser

# List of users who have, for various reasons, requested to be ignored.
ignored = ["email@email.com", "email2@email.com"]

def privateTokenGitLab():
    '''
    Open token.yaml file to retrieve gitlab private token.
    '''
    with open('/path/to/token.yaml', 'r') as f:
	tokenGitLab = yaml.load(f)
    return tokenGitLab["tokens"]["name-of-gitlab-instance"]

def glGitLab():
    '''
    Return connection object to GitLab instance.
    '''
    return gitlab.Gitlab('https://gitlab@company.com', privateTokenGitLab())

def totalGitLabUserObjects():
    '''
    Return user objects for all users on gitlab.
    '''
    glGitLabObj = glGitLab()
    codeIntUsers = []
    page = 0
    try:
        while True:
            nextList = glGitLabObj.users.list(per_page=20, page=page)
            if not nextList:
                break
            codeIntUsers.extend(nextList)
            page += 1
        return codeIntUsers
    except:
        print "Error: not sure what happened."

def codeIntBlocked():
    '''
    Return list of already blocked users.
    '''
    alreadyBlocked = []
    for user in totalgitlabusers:
	us = user.state
        #print us
	if us == 'blocked' or us == 'ldap_blocked':
	    alreadyBlocked.append(user)
    return alreadyBlocked

def netUser():
    '''
    Return list of users prior who are not already blocked.
    '''
    net = []
    for user in totalgitlabusers:
        if user not in gitlabblocked and user.email not in ignored:
	    net.append(user)
    return net

def cutOffList():
    '''
    Return list of users w/ last-sign-in prior to one year (thereabouts).
    '''
    cutOffList = []
    today = datetime.today()
    cutoff = 364
    for user in net:
        csi = user.current_sign_in_at
        csi = str(csi)
        if csi == 'None':
            csi = str(user.created_at)
        csiparse = str(dateutil.parser.parse(csi))
        csiparse = csiparse[:10]
        csiparse = datetime.strptime(csiparse, "%Y-%m-%d")
        diff = today-csiparse
        if diff.days >= cutoff:
            cutOffList.append(user)
    return cutOffList

def cutOffDate():
    '''
    Return a specific cutoff date.
    '''
    #aug16 = dateutil.parser.parse('2016-08-01')
    #jul20 = dateutil.parser.parse('2016-07-20')
    #cutoffdate = today - aug16
    #cutoffdate = today - jul20 
    return cutoffdate         


# Get all user objects.
totalgitlabusers = totalGitLabUserObjects()

# Get all already-blocked.
gitlabblocked = codeIntBlocked()

# Get the difference between previous two lists minus ignored.
net = netUser()

# Create cutoff list with users whose last sign is prior to a year ago.
cutofflist = cutOffList()

# Create the oneyear variable for the print-out message (see below).
oneyear = str(datetime.today() - timedelta(days=365))
oneyear_ = oneyear[:10]

# Get the length of the current cutofflist, i.e. number of those to be cut off.  
totalCutOff = len(cutofflist)

if totalCutOff != 0:
    for user in cutofflist:
        user.block()
elif totalCutOff == 0:
    print "No users to block."

# Print that list w/ user emails to stdout.
print "Total Last Sign-in on Code-Int Prior to %s: %d " % (oneyear_, totalCutOff)
print
print "Code-Int users blocked: %d " % totalCutOff
print
for user in cutofflist:
    print user.email	    
