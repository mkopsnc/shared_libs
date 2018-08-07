#!/bin/bash

make clean

make lib MINOR=1 MAJOR=1
make lib MINOR=2 MAJOR=2
make exe MINOR=2 MAJOR=2

test "$?BASH_VERSION" != "0" || goto tcshcmd

export LD_LIBRARY_PATH=`pwd`/shared/1.1/lib:${LD_LIBRARY_PATH}
find bin -name "exe*" -exec echo {} \; -exec {} \;
exit 0

tcshcmd:
setenv LD_LIBRARY_PATH `pwd`/shared/1.1/lib:${LD_LIBRARY_PATH}
find bin -name "exe*" -exec echo {} \; -exec {} \;

