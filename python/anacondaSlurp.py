#!/bin/python

"""Initial download of anaconda cloud repo. Once all packages are downloaded,
then anacondaRepoCheck.py can be run to update the repo."""

import json
import subprocess
url1 = 'https://repo.continuum.io/pkgs/free/linux-64/'
jsonurl = url1 + 'repodata.json'

# Download the newest repodata.json file:
subprocess.call(["wget", jsonurl])

# Open repodata.json file, and convert json file to python dictionary:
with open('repodata.json') as json_data:
    d = json.load(json_data)
    packages = d['packages']
    # iterate through nested dictionary 'packages,' and download package names
    for k in packages.iterkeys():
        url2 = str(url1 + k)
        subprocess.call(["wget", url2])
