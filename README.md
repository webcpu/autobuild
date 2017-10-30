# autobuild

Execute build script automatically when any specified files in working directory are modified.

## Example

```autobuild -s ./build.sh -t "{swift}"```

<img width="710" alt="screen shot 2017-10-30 at 11 03 18" src="https://user-images.githubusercontent.com/4646838/32166129-43137168-bd65-11e7-9ec6-ec623eb562fb.png">

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

