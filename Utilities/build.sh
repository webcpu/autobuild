#!/bin/bash
dir=/Users/liang/Dropbox/OSX/autobuild

SWIFT_BUILD=`xcrun -f swift-build`
echo ${SWIFT_BUILD}
SWIFT_BUILD_TOOL=`xcrun -f swift-build-tool`
cd ${dir}
#swift-build -k
if ${SWIFT_BUILD} ; then
   #${dir}/Utilities/bootstrap --build-tests test
   #${dir}/.build/debug/autobuild --chdir ${dir}
   #${dir}/Utilities/bootstrap --sbt=${SWIFT_BUILD_TOOL} --build-tests test
   ${dir}/Utilities/bootstrap --sbt=`xcrun -find swift-build-tool` --swiftc=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swiftc --build-tests test
   echo
fi

