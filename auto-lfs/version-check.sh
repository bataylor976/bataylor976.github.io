#!/bin/bash
# My variation on the script of the same title in Linux From Scratch version 7.9
# This script begins my attempt to automate the Linux From Scratch installation.
# While there is an Automated Linux From Scratch project, for educational purposes, I'm carrying out my own independent project.
# Simple script to list version numbers of critical development tools
export LC_ALL=C

# Bash version check
BASH_MINa=3
#echo $BASH_MINa
BASH_MINb=2
#echo $BASH_MINb
BASH_INSTa=$(bash --version | head -n1 | cut -d" " -f4-4 | cut -d"." -f1)
#echo $BASH_INSTa
BASH_INSTb=$(bash --version | head -n1 | cut -d" " -f4-4 | cut -d"." -f2)
#echo $BASH_INSTb

if [ "$BASH_INSTa" -gt "$BASH_MINa" ]
then
    echo "Your bash version meets the minimum installation requirements"
elif [ "$BASH_INSTa" -eq "$BASH_MINa" ] && [ "$BASH_INSTb" -ge "$BASH_MINb" ]
then
    echo "Your bash version meets the minimum installation requirements"
   
else 
    echo "Your bash version does not meet the minimum installation requirements."
    echo "Installing latest version of bash."
    apt-get update && apt-get -y install bash  
fi

MYSH=$(readlink -f /bin/sh)
LFSSH=/bin/bash
#echo "/bin/sh -> $MYSH"
if [ $MYSH != $LFSSH ]
then
    echo "Symlink '/bin/sh' does not point to '/bin/bash'"
    echo "Creating symbolic link /bin/bash"
    ln -sf /bin/bash /bin/sh
else
    echo "Symlink '/bin/sh' points to '/bin/bash'"
    unset MYSH && unset LFSSH
fi

# Check binutils installation
#MYBINUa=ld --version | head -n1 | cut -d" " -f7 | cut -d"." -f1
MYBINUb=$(ld --version | head -n1 | cut -d" " -f7 | cut -d"." -f2)
#LFSBINMINa=2
LFSBINMINb=17
#LFSBINMAXa=2
LFSBINMAXb=26
if [ "$MYBINUb" -ge "$LFSBINMINb" ] && [ "$MYBINUb" -le "$LFSBINMAXb" ]
then
    echo "Your binutils version meets requirements"
else
    LFSBINFLAG=y
fi
unset LFSBINMINb && unset LFSBINMAXb

# Check bison installation
MYBIS=$(whereis bison)
BISMINa=2
BISMINb=3
if [ "$MYBIS" == "bison:" ]
then 
    echo "Bison is not installed."
    apt-get update && apt-get -y install bison
    echo "Bison installed."
fi

unset BISMINa
unset BISMINb

# Checking if installed bison version meets requirements.
MYBISa=$(bison --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
MYBISb=$(bison --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
if [ "$MYBISa" -gt "$BISMINa" ] 
then 
    echo "Your bison version meets requirements"
elif [ "$MYBISa" -eq "$BISMINa" ] && [ "$MYBISb" -ge "$BISMINb" ]
then
    echo "Your bison version meets requirements"
else
    echo "Your bison version does not meet requirements."
    echo "Installing bison . . . "
    apt-get update && apt-get -y install bison
fi
unset MYBISa && unset MYBISb


# Checking YACC.
# /usr/bin/yacc should be a link to bison or to a small script that executes bison

# if 'usr/bin/yacc exists, and it's a symlink
if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
# otherwise, if '/usr/bin/yacc exists and it's an executable . . . 
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

# Checking bzip2 version.
#bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-

MYBZa=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f8 | cut -d"." -f1)
MYBZb=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f8 | cut -d"." -f3 | cut -d"," -f1)
LFSBZa=1
LFSBZb=4
if [ "$MYBZa" -eq "$LFSBZa" ] && [ "$MYBZb" -ge "$LFSBZb" ]
then
   echo "Your bzip2 version meets requirements"
fi

#Checking coreutils
MYCOREa=$(chown --version | head -n1 | cut -d")" -f2 | cut -d" " -f2 | cut -d"." -f1)
MYCOREb=$(chown --version | head -n1 | cut -d")" -f2 | cut -d" " -f2 | cut -d"." -f2)
LFSCOREa=6
LFSCOREb=9

if [ "$MYCOREa" -gt "$LFSCOREa" ]; then
  echo "Coreutils version meets requirements"
elif [ "$MYCOREa" -eq "$LFSCORa" ] && [ "$MYCOREb" -ge "$MYCORE" ]; then
  echo "Coreutils version meets requirements"
else
  echo "Coreutils does not meet requirements"
  apt-get update && apt-get install coreutils
fi
  
# Checking diff version
MYDIFa=$(diff --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
MYDIFb=$(diff --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
LFSDIFa=2
LFSDIFb=8
if [ "$MYDIFa" -gt "$LFSDIFa" ]; then
  echo "Diffutils meets requirements"
elif [ "$MYDIFa" -eq "$LFSDIFa" ] && [ "$MYDIFb" -ge "$LFSDIFb" ]; then
  echo "Diffutils meets requirements"
else
  echo "Diffutils does not meet requirements"
  echo "Installing diffutils . . ."
  apt-get update && apt-get -y install diffutils
  echo
  echo "Diffutils installed"
fi

# Checking 
MYFINDa=$(find --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
MYFINDb=$(find --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
LFSFINDa=4
LFSFINDb=2
if [ "$MYFINDa" -eq "$LFSFINDa" ] && [ "$MYFINDb" -ge "$LFSFINDb" ]; then
  echo "Findutils meets requirements"
else
  echo "Findutils does not meet requirements"
  echo "Installing findutils . . . "
  apt-get update && apt-get install findutils
fi

#Checking gawk version
MYGAWK=$(whereis gawk)
if [ "$MYGAWK" == "gawk:" ]
then
    echo "Gawk not installed"
    echo
    echo "Installing gawk . . ."
    echo
    apt-get update 
    echo
    apt-get -y install gawk
else
    MYGAWKa=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"." -f1)
    MYGAWKb=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"." -f2)
    MYGAWKc=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"." -f3)
    LFSGAWKa=4
    LFSGAWKb=0
    LFSGAWKc=1
    if [ "$MYGAWKa" == "$LFSGAWKa" ] && [ "$MYGAWKb" > "$LFSGAWKb" ]
    then
        echo "Gawk meets minimum requirements"
    elif [ "$MYGAWKa" == "$LFSGAWKa" ] && [ "$MYGAWKb" == "$LFSGAWKb" ] && [ "$MYGAWKc" >= "$LFSGAWKc" ] 
    then
        echo "Gawk meets minimum requirements"
    else
        echo "Gawk does not meet minimum requirements"
    fi
fi

#Checking if '/usr/bin/awk' is a symlink to '/usr/bin/gawk'
if [ `readlink -f /usr/bin/awk` == "/usr/bin/gawk" ]
then
    echo "/usr/bin/awk is a symlink to /usr/bin/gawk" 
else 
    echo "No symlink to gawk"
    ln -sf /usr/bin/gawk /usr/bin/awk
fi

if [ -h /usr/bin/awk ]
then
    echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]
then
    echo awk is `/usr/bin/awk --version | head -n1`
else 
    echo "awk not found" 
fi

# Checking gcc installation information

gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2-  # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1
xz --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
