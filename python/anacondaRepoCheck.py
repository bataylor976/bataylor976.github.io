#!/bin/python

'''
Script run as a cronjob. Checks anaconda repository at repo.continuum.io for new packages, then downloads packages and updates anaconda repository.
'''

import json
import subprocess

url1 = 'https://repo.continuum.io/pkgs/free/linux-64/repodata.json'
url2 = 'https://repo.continuum.io/pkgs/free/linux-64/'
filepath = '/repo/anaconda/linux-64/'
rj = 'repodata.json'
rjpath = filepath + rj

def getCurrentRepoData():
    '''
    Returns existing repodata.json file as python dictionary.
    '''
    with open('/repo/anaconda/linux-64/repodata.json.orig') as json_data:
        currentRepoDataDict = json.load(json_data)
    return currentRepoDataDict

def getNewRepoData():
    '''
    Returns newly downloaded repodata.json file as python dictionary.
    '''
    with open('/repo/anaconda/linux-64/repodata.json.new') as json_data:
        newRepoDataDict = json.load(json_data)
    return newRepoDataDict

def getCurrentPackageNames():
    '''
    returns sub-nested dictionary 'packages' from currentRepoDataDict.
    '''
    return currentrepodatadict['packages']

def getNewPackageNames():
    '''
    returns sub-nested dictionary 'packages' from newRepoDataDict.
    '''
    return newrepodatadict['packages']
    

def currentPackageList():
    '''
    Return nested dictionary of package names in currentRepoDataDict
    as python list.
    '''
    currentPackageList = []
    for k in currentpackagenames.iterkeys():
        currentPackageList.append(k)
    return currentPackageList

def newPackageList():
    '''
    Return nested dictionary of packages names in newRepodataDict 
    as python list.
    '''
    newPackageList = []
    for k in newpackagenames.iterkeys():
        newPackageList.append(k)
    return newPackageList

def diffPackageList():
    '''
    Returns a list of packages that are not in the current package list.
    '''
    diffPackageList = []
    for package in newpackagelist:
        if package not in currentpackagelist:
            diffPackageList.append(package)
    return diffPackageList

def removedPackageList():
    '''
    Return a list of packages that are in current package list,
    but not in new one; i.e., they've been removed.
    '''
    removedPackageList = []
    for package in currentpackagelist:
        if package not in newpackagelist:
            removedPackageList.append(package)
    return removedPackageList


def downloadPackages():
    '''
    Download packages, if applicable.
    '''
    # Iterate through diffpackagelist and download packages.
    if diffpackagelist > 0:
        for package in diffpackagelist:
            url3 = str(url2 + package)
            outPath = str(filepath + package)
            subprocess.call(["/usr/bin/wget", "-O", outPath, url3])
            #print url3

def removePackages():
    '''
    Remove no longer supported packages, if applicable.
    '''
    if removedpackagelist > 0:
        for package in removedpackagelist:
            package = str(package)
            packagepath = filepath + package
            print package
            subprocess.call(["/usr/bin/rm", packagepath])

def cleanUp():
    '''
    Remove old repodata.json file, and change name of new file to its normal name
    so it can be indexed.
    '''
    subprocess.call(["/usr/bin/mv", "/repo/anaconda/linux-64/repodata.json.new", "/repo/anaconda/linux-64/repodata.json"])
    # Remove old repodata.json file:
    subprocess.call(["/usr/bin/rm", "/repo/anaconda/linux-64/repodata.json.orig"])

def newIndexFile():
    '''
    Create new index based on newly downloaded packages.
    '''
    subprocess.call(["/home/b1n/anaconda2/bin/conda", "index", "/repo/anaconda/linux-64"])

def oldIndexFile():
    '''
    If nothing new to download, or nothing old to remove, restore old index file.
    '''
    if len(diffpackagelist) == 0 and len(removedpackagelist) == 0:
        #print "Nothing to update ..."
        #print "Restoring old repodata.json file." 
        subprocess.call(["/usr/bin/mv", "/repo/anaconda/linux-64/repodata.json.orig", "/repo/anaconda/linux-64/repodata.json"])
        subprocess.call(["/usr/bin/rm", "/repo/anaconda/linux-64/repodata.json.new"])
    

# For testing purposes only. Clean up files from previous test runs.
#subprocess.call(["bash", "setuprepotest.sh"])

# To avoid confusion, change name of existing repodata.json file:
subprocess.call(["/usr/bin/mv", "/repo/anaconda/linux-64/repodata.json", "/repo/anaconda/linux-64/repodata.json.orig"])

# Download the newest repodata.json file:
subprocess.call(["/usr/bin/wget", "-O", rjpath, url1])

# To avoid confusion, change name of new repodata.json to repodata.json.new:
subprocess.call(["/usr/bin/mv", "/repo/anaconda/linux-64/repodata.json", "/repo/anaconda/linux-64/repodata.json.new"])


currentrepodatadict = getCurrentRepoData()
newrepodatadict = getNewRepoData()
currentpackagenames = getCurrentPackageNames()
newpackagenames = getNewPackageNames()
currentpackagelist = currentPackageList()
newpackagelist = newPackageList()
diffpackagelist = diffPackageList()
removedpackagelist = removedPackageList()

if len(diffpackagelist) > 0 or len(removedpackagelist) > 0:
    downloadPackages()
    removePackages()
    cleanUp()
    newIndexFile()
else:
    oldIndexFile()
