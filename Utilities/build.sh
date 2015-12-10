#!/bin/bash
dir=/Users/liang/Dropbox/OSX/autobuild
cd ${dir}
#swift-build -k
if swift-build ; then
   #${dir}/Utilities/bootstrap --build-tests test
   #${dir}/.build/debug/autobuild --chdir ${dir}
   ${dir}/Utilities/bootstrap --build-tests test
   echo
fi

