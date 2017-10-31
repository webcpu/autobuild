# autobuild

Execute build script automatically when any specified files in working directory are modified.

## Examples

```autobuild -s ./playground.sh -t "{red}"```
<img width="744" alt="screen shot 2017-10-31 at 09 46 08" src="https://user-images.githubusercontent.com/4646838/32214912-a36e2b3c-be20-11e7-95ed-115f9ffe82d4.png">

```autobuild -s ./build.sh -t "{swift}"```

<img width="710" alt="screen shot 2017-10-30 at 11 03 18" src="https://user-images.githubusercontent.com/4646838/32166129-43137168-bd65-11e7-9ec6-ec623eb562fb.png">

## Installation
### Prerequisites
- macOS 10.13
- Xcode 9+ & Xcode command line tools
- fswatch
```
brew install fswatch
```

### Install
``` 
git clone https://github.com/unchartedworks/autobuild.git
cd autobuild
./build.sh 
```

## Usage
```
Usage: autobuild [options]
  -c, --chdir:
      Change working directory before any other operation
  -s, --script:
      Build script path
  -t, --types:
      file extensions to be monitored, such as "{swift,m,h}".
      If there is no file extensions specified, all kinds of files in working directory will be monitored.
  -h, --help:
      print usage
      
autobuild (-c|--chdir workingdirectory) (-s|--script scriptpath) (-t|--types fileextensions)

Execute build script automatically when any specified files in working directory are modified.
```

