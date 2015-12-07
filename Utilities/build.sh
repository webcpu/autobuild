#!/bin/bash
dir=/Users/liang/Dropbox/OSX/autobuild
cd ${dir}
if swift-build ; then
   #${dir}/Utilities/bootstrap --build-tests test
   ${dir}/.build/debug/autobuild --chdir ${dir}
   echo
fi

