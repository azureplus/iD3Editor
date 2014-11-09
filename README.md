About
=====
This project is an attempt to create an easy-to-use music tag editor under Mac. While there are excellent tag tools under window, such as [mp3tag](http://www.mp3tag.de/en/), there is no one under Mac that can satisfy my needs. Thus I decided to make one for myself.

iD3Editor provides features listed below:
* batch processing music files;
* formating tags to lowercase, uppercase and capitalizations;
* fixing the character encoding of tags (more than 30 language encodings);
* conversion between tags and file names;

iD3Editor supports popular music file types such as mp3, mp4, ape, flac, ogg, oga, spx, wav and more. Please check www.id3Editor.com for detailed introductions.

How to Build
======
iD3Editor uses [taglib](http://taglib.github.io) to parse tags. To build iD3Editor, you need to make a minor change to taglib as below:
* make `void addValue(const String &key, const String &value, bool replace = true);` in `apetag.h` `public`. It is declared as `protected` in taglib.

After the change, run the command below and `make; make install` to compile taglib as a static lib.
```
  cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.6 \
    -DCMAKE_OSX_ARCHITECTURES="i386;x86_64" \
    -DENABLE_STATIC=ON \
    -DCMAKE_INSTALL_PREFIX="<folder you want to build to>"
```    

At last, please open iD3Editor in XCode, and change the user header and user lib search paths in project configuration. These paths are pointing to some directories on my computer by default.

Apple Store
======
You can also purchase a compiled version of iD3Editor from [Apple Store](https://itunes.apple.com/us/app/id3-editor/id910408628?ls=1&mt=12)

