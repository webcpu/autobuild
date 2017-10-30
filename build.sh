#!/bin/sh
swift build -c release -Xswiftc -static-stdlib -Xswiftc -L -Xswiftc ./Frameworks/HaskellSwift -Xswiftc -I./Frameworks/HaskellSwift/ -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" -Xlinker -L -Xlinker ./Frameworks/HaskellSwift -Xswiftc -L -Xswiftc ./Frameworks/HaskellSwift -Xlinker ./Frameworks/HaskellSwift/libHaskellSwift.a
if [ $? -eq 0 ]; then
    install -m0755 -v ./.build/release/autobuild /usr/local/bin
fi
