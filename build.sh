#!/bin/bash
#swift build -c release -Xswiftc -static-stdlib
swift build -c release -Xswiftc -static-stdlib -Xswiftc -L -Xswiftc ./Frameworks/HaskellSwift -Xswiftc -I./Frameworks/HaskellSwift/ -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.11" -Xlinker -L -Xlinker ./Frameworks/HaskellSwift -Xswiftc -L -Xswiftc ./Frameworks/HaskellSwift -Xlinker ./Frameworks/HaskellSwift/HaskellSwift.a
if [ $? -eq 0 ]; then
    install -m0755 -v ./.build/release/autobuild /usr/local/bin
fi
