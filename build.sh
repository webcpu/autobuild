#!/bin/sh
swift build -c release 
if [ $? -eq 0 ]; then
    install -m0755 -v ./.build/release/autobuild /usr/local/bin
fi
