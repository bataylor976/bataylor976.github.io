#!/bin/bash
# My variation on the script of the same title in Linux From Scratch version 7.9
# This script begins my attempt to automate the Linux From Scratch installation.
# While there is an Automated Linux From Scratch project, for educational purposes, I'm carrying out my own independent project.
# Simple script to list version numbers of critical development tools

export LC_ALL=C

# Bash version check (3.2 minimum)
BASH_INSTa=$(bash --version | head -n1 | cut -d" " -f4-4 | cut -d"." -f1)
BASH_INSTb=$(bash --version | head -n1 | cut -d" " -f4-4 | cut -d"." -f2)
if [ "$BASH_INSTa" -gt 3 ]
then
    echo "Your bash version meets the minimum installation requirements"
elif [ "$BASH_INSTa" -eq 3 ] && [ "$BASH_INSTb" -ge 2 ]
then
    echo "Your bash version meets the minimum installation requirements"  
else 
    echo "Your bash version does not meet the minimum installation requirements."
    echo "Installing latest version of bash."
    apt-get update && apt-get -y install bash  
fi

# Verifying that /bin/sh is a symlink to /bin/bash.
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

# Check bison installation (2.3 minimum)
MYBIS=$(whereis bison)
if [ "$MYBIS" == "bison:" ]
then 
    echo "Bison is not installed."
    apt-get update && apt-get -y install bison
    echo "Bison installed."
elif [ "$MYBIS" == "bison: /usr/bin/bison.yacc /usr/bin/bison /usr/bin/X11/bison.yacc /usr/bin/X11/bison /usr/share/bison /usr/share/man/man1/bison.1.gz" ]
then
    MYBISa=$(bison --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYBISb=$(bison --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    if [ "$MYBISa" -gt 2 ] 
    then 
        echo "Your bison version meets requirements"
    elif [ "$MYBISa" -eq 2 ] && [ "$MYBISb" -ge 3 ]
    then
        echo "Your bison version meets requirements"
    else
        echo "Your bison version does not meet requirements."
        echo "Installing bison . . . "
        apt-get update && apt-get -y install bison
    fi
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

# Checking bzip2 version (1.0.4 minimum)
#bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
MYBZ=$(whereis bzip2)
if [ "$MYBZ" == "bzip2:" ]
then
    echo "Bzip2 is not installed"
    echo "Installing bzip2 . . ."
    apt-get update
    apt-get install bzip2
    echo "Bzip2 installed"
elif [ "$MYBZ" == "bzip2: /bin/bzip2 /usr/share/man/man1/bzip2.1.gz" ]
then
    MYBZa=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f8 | cut -d"." -f1)
    MYBZc=$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f8 | cut -d"." -f3 | cut -d"," -f1)
    if [ "$MYBZa" -eq 1 ] && [ "$MYBZc" -ge 4 ]
    then
        echo "Your bzip2 version meets requirements"
    else
        echo "Bzip2 does not meet requirements"
        echo "Installing bzip2 . . ."
        apt-get update
        apt-get install bzip2
        echo "Bzip2 installed"
    fi
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
#This LFS version's recommended minimim for gcc is 4.7
#This LFS version's recommended maximum for gcc is 5.3
MYGCC=$(whereis gcc)
if [ "$MYGCC" == "gcc:" ]
then
    echo "GCC not installed"
    echo "Installing gcc . . ."
    apt-get update
    apt-get -y install gcc-4.8.2
elif [ "$MYGCC" == "gcc: /usr/bin/gcc /usr/lib/gcc /usr/bin/X11/gcc /usr/share/man/man1/gcc.1.gz" ]
then
    MYGCCa=$(gcc --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    #echo "My GCCa is" $MYGCCa
    MYGCCb=$(gcc --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    #echo "My GCCb is" $MYGCCb
    if [ "$MYGCCa" -gt 5 ]
    then
        echo "WARNING: Installed gcc version is higher than the recommended packages. Versions higher than gcc-5.3 have not been tested with this version of LFS"
    elif [ "$MYGCCa" -eq 5 ] && [ "$MYGCCb" -gt 3]
    then
        echo "WARNING: Installed gcc version is higher than the recommended packages. Versions higher than gcc-5.3 have not been tested with this version of LFS" 
    elif [ "$MYGCCa" -eq 5 ] && [ "$MYGCCb" -eq 3 ]
    then
        echo "GCC version meets requirements"
    elif [ "$MYGCCa" -eq 4 ] && [ "$MYGCCb" -ge 7 ]
    then
        echo "GCC version meets requirements"
    else
        echo "Installing latest version of gcc"
        apt-get update
        apt-get -y install gcc
    fi 
fi

# Checking grep version (2.5.1a minimum)
#grep --version | head -n1
MYGRP=$(whereis grep)
if [ "$MYGRP" == "grep:" ]
then
    echo "grep not installed"
    echo "Installing grep . . ."
    apt-get update
    apt-get -y install grep
elif [ "$MYGRP" == "grep: /bin/grep /usr/share/man/man1/grep.1.gz" ]
then
    MYGRPa=$(grep --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYGRPb=$(grep --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    if [ "$MYGRPa" -eq 2 ] && [ "$MYGRPb" -ge 5 ]
    then
        echo "Grep meets the minimum requirements"
    else
        echo "Grep does not meet the mimimum requirements"
        echo "Installing grep . . . "
        apt-get update
        apt-get -y install grep
        echo "Grep installed."
    fi
fi
    
# Checking gzip version (1.3.12 minimum)
MYGZP=$(whereis gzip)
if [ "$MYGZP" == "gzip:" ]
then
    echo "Gzip not installed"
    echo "Installing gzip . . ."
    apt-get update && apt-get install gzip
elif [ "$MYGZIP" == "gzip: /bin/gzip /usr/share/man/man1/gzip.1.gz" ]
    then
    #MYGZPa=$(gzip --version | head -n1 | cut -d" " -f2 | cut -d"." -f1)
    MYGZPb=$(gzip --version | head -n1 | cut -d" " -f2 | cut -d"." -f2) 
    if [ "$MYGZIPb" -ge 3 ] 
    then
        echo "Gzip meets requirements"
    else
        echo "Gzip does not meet requirements"
        echo "Installing latest version of gzip"
        apt-get update
        apt-get install gzip
    fi
fi   

# Checking kernel version (2.6.32)
MYKERNa=$(cat /proc/version | head -n1 | cut -d" " -f3 | cut -d"." -f1)
MYKERNb=$(cat /proc/version | head -n1 | cut -d" " -f3 | cut -d"." -f2)
if [ "$MYKERNa" -gt 2 ] 
then
    echo "Kernel version meets requirements"
elif [ "$MYKERNa" -eq 2 ] && [ "$MYKERNb" -ge 6 ]
then
    echo "Kernel version meets requirements" 
else
    echo "Kernel does not meet requirements. Please see final messages for more details."
fi

# Checking M4 version (1.4.10 mimimum)
MYM4=$(whereis m4)
if [ "$MYM4" == "m4:" ]
then
    echo "M4 is not installed"
    echo "Installing M4"
    apt-get update
    apt-get install m4
elif [ "$MYM4" == "m4: /usr/bin/m4 /usr/bin/X11/m4 /usr/share/man/man1/m4.1.gz" ]
    then
    MYM4c=$(m4 --version | head -n1 | cut -d" " -f4 | cut -d "." -f3)
    if [ "$MYM4c" -ge 10 ]
    then
        echo "M4 meets requirements"
    else
        echo "M4 does not meet requirements"
        echo "Installing M4 . . ."
        apt-get update 
        apt-get install m4
        echo "M4 installed"
# Checking make version (3.81 minimum)
MYMKE=$(whereis make)
if [ "$MYMKE" == "make:" ]
then
    echo "Make is not installed"
    echo "Installing make . . ."
    apt-get update
    apt-get install make
elif [ "$MYMKE" == "make: /usr/bin/make /usr/bin/X11/make /usr/share/man/man1/make.1.gz" ]
    then
    MYMKEa=$(make --version | head -n1 | cut -d" " -f3 | cut -d"." -f1)
    MYMKEb=$(make --version | head -n1 | cut -d" " -f3 | cut -d"." -f2)
    if [ "$MYMKEa" -ge 3 ] && [ "$MYMKEb" -ge 81 ]
    then
        echo "Make meets requirements"
    else
        echo "Make does not meet requirements"
        echo "Installing latest version of make . . ."
        apt-get update
        apt-get install make
        echo "Make installed"
    fi
fi

# Checking patch version (2.5.4 minimum)
MYPTCH=$(whereis patch)
if [ "$MYPTCH" == "patch:" ]
then
    echo "Patch not installed"
    echo "Installing patch . . ."
    apt-get update
    apt-get install patch
    echo "Patch installed"
elif [ "$MYPTCH" == "patch: /usr/bin/patch /usr/bin/X11/patch /usr/share/man/man1/patch.1.gz" ]
    then
    MYPTCHa=$(patch --version | head -n1 | cut -d" " -f3 | cut -d"." -f1)
    MYPTCHb=$(patch --version | head -n1 | cut -d" " -f3 | cut -d"." -f2)
    MYPTCHc=$(patch --version | head -n1 | cut -d" " -f3 | cut -d"." -f3)
    if [ "$MYPTCHa" -eq 2 ] && [ "$MYPTCHb" -gt 5 ]
    then
        echo "Patch meets requirements"
    elif [ "$MYPTCHa" -eq 2 ] && [ "$MYPTCHb" -eq 5 ] && [ "$MYPTCHc" -ge 4 ]
    then
        echo "Patch meets requirements"
    else
        echo "Patch does not meet requirements"
        echo "Installing latest version of patch . . ."
        apt-get update
        apt-get install patch
    fi
fi


# Checking perl version (5.8.8 minimum)
MYPRL=$(whereis perl)
if [ "$MYPRL" == "perl:" ]
then
    echo "Perl is not installed"
    echo "Installing perl . . ."
    apt-get update
    apt-get install perl
elif [ "$MYPRL" == "perl: /usr/bin/perl /etc/perl /usr/lib/perl /usr/bin/X11/perl /usr/share/perl /usr/share/man/man1/perl.1.gz" ]
    then
    MYPRLa=$(echo Perl `perl -V:version` | cut -d"'" -f2 | cut -d"." -f1)
    MYPRLb=$(echo Perl `perl -V:version` | cut -d"'" -f2 | cut -d"." -f2)
    MYPRLc=$(echo Perl `perl -V:version` | cut -d"'" -f2 | cut -d"." -f3)
    if [ "$MYPRLa" -ge 5 ] && [ "$MYPRLb" -ge 8 ] && [ "$MYPRLb" -ge 8 ]
    then
        echo "Perl meets requirements"
    else
        echo "Perl does not meet requirements"
        echo "Installing latest version of perl"
        apt-get update
        apt-get install perl
    fi
fi

# Checking sed version (4.1.5 minimum)
MYSED=$(whereis sed)
if [ "$MYSED" == "sed:" ]
then
    echo "Sed is not installed"
    echo "Installing sed. . ."
    apt-get update
    apt-get intall sed
    echo "Sed installed"
elif [ "$MYSED" == "sed: /bin/sed /usr/share/man/man1/sed.1.gz" ]
then
    MYSEDa=$(sed --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYSEDb=$(sed --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    MYSEDc=$(sed --version | head -n1 | cut -d" " -f4 | cut -d"." -f3)
    # Most likely not going to have any version lower than 4
    if [ "$MYSEDb" -ge 1 ] && [ "$MYSEDc" ge 5 ]
    then
        echo "Sed meets requirements"
    else
        echo "Sed does not meet requirements"
        echo "Installing sed . . ."
        apt-get update
        apt-get install sed
        echo "Sed installed"
    fi
fi
    
# Checking tar version (1.22 minimum)
MYTAR=$(whereis tar)
if [ "$MYTAR" == "tar:" ]
then
    echo "Tar is not installed"
    echo "Installing tar. . ."
    apt-get update
    apt-get intall tar
    echo "Tar installed"
elif [ "$MYTAR" == "tar: /bin/tar /usr/lib/tar /usr/include/tar.h /usr/share/man/man1/tar.1.gz" ]
then
    MYTARa=$(tar --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYTARb=$(tar --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    if [ "$MYTARa" -ge 1 ] && [ "$MYTARb" -ge 22 ]
    then
        echo "Tar meets requirements"
    else
        echo "Tar does not meet requirements"
        echo "Installing tar . . ."
        apt-get update
        apt-get install tar
        echo "Tar installed"
    fi
fi

# Checking makeinfo version (4.7 minimum)
MYMKNFO=$(whereis makeinfo)
if [ "$MYMKNFO" == "makeinfo:" ]
then
    echo "Makeinfo is not installed"
    echo "Installing makeinfo. . ."
    apt-get update
    apt-get -y install texinfo
    echo "Makeinfo installed"
elif [ "$MYMKNFO" == "makeinfo: /usr/bin/makeinfo /usr/bin/X11/makeinfo /usr/share/man/man1/makeinfo.1.gz" ]
then
    MYMKNFOa=$(makeinfo --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYMKNFOb=$(makeinfo --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    if [ "$MYMKNFOa" -gt 4 ] 
    then
        echo "Makeinfo meets requirements"
    elif [ "$MYMKNFOa" -eq 4 ] && [ "$MYMKNFOb" -ge 7 ]
    then
        echo "Makeinfo meets requirements"
    else
        echo "Makeinfo does not meet requirements"
        echo "Installing makeinfo . . ."
        apt-get update
        apt-get install texinfo
        echo "Makeinfo installed"
    fi
fi

# Checking xz version

#xz --version | head -n1
MYXZ=$(whereis xz)
if [ "$MYXZ" == "xz:" ]
then
    echo "Xz is not installed"
    echo "Installing xz. . ."
    apt-get update
    apt-get -y install xz-utils
    echo "Xz installed"
elif [ "$MYXZ" == "xz: /usr/bin/xz /usr/bin/X11/xz /usr/share/man/man1/xz.1.gz" ]
then
    MYXZa=$(xz --version | head -n1 | cut -d" " -f4 | cut -d"." -f1)
    MYXZb=$(xz --version | head -n1 | cut -d" " -f4 | cut -d"." -f2)
    if [ "$MYXZa" -eq 5 ] && [ "$MYXZb" -ge 0 ]
    then
        echo "Xz meets requirements"
    else
        echo "Xz does not meet requirements"
        echo "Installing xz-utils . . ."
        apt-get update
        apt-get install xz-utils
        echo "Xz installed"
    fi
fi

# Final sanity check list (including test run of natively install g++ and ldd)
echo "Running final sanity check for software prerequisites"
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found" 
fi

bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else 
  echo "awk not found" 
fi

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
