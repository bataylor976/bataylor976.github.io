#! python3
# backupToZip.py - Copies an entire folder and its contents into
# a ZIP file whose filename increments.
# Special thanks to Automate the Boring Stuff with Python

import zipfile, os, sys

def backupToZip(folder):
    # Backup the entire contents of "folder" into a ZIP file.

    folder = os.path.abspath(folder)

    # Figure out the filename this code should use based on
    # what files already exist.

    number = 1
    while True:
        zipFilename = os.path.basename(folder) + '_' + str(number) + '.zip'
        if not os.path.exists(zipFilename):
            break
        number += 1

    # Create the zip file.
    print('Creating %s. . .' % (zipFilename))
    backupZip = zipfile.ZipFile(zipFilename, 'w')

    # Walk the entire folder tree and compress the files in each folder.
    # Use os.walk() in a for loop, and on each iteration it will return
    # the iteration's current folder name, the subfolders in that folder,
    # and the filenames in that folder.
    for foldername, subfolders, filenames in os.walk(folder):
        print('Adding files in %s. . .' % (foldername))
        # Add the current folder in the for loop to the ZIP file.
        backupZip.write(foldername)
        # Add all the files in this folder to the ZIP file (except for previously
        # made backup ZIPs. 
        for filename in filenames:
            newBase = os.path.basename(folder) + '_'
            if filename.startswith(newBase) and filename.endswith('.zip'):
                continue	# don't backup the backup ZIP files
            backupZip.write(os.path.join(foldername, filename))
    backupZip.close()
    print('Done')

backupToZip(sys.argv[1])

