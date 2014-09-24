Welcome To iD3 Editor
==============

**iD3 Editor** is an application that facilitates tag processing of music files. It provides following features: 

1. Batch processing tags;
1. Fix character encoding of tags;
1. Fetch tags from file names;
1. Renaming files using tag information;

**iD3 Editor** supports MP3, APE, FLAC, OGG, OGA, SPX and WAV files.

## Tag Batch Processing ##
![main window](mainwin.png)

Above is the main window of **iD3 Editor**. To edit tags of a group of music files, select those files, and then enter corresponding tag values using the input fields on the right side of the window.

Button "To All" allows you to apply an existing tag value to all music files, which may be useful under many situations.

## Fixing Character Encoding Of Tags ##
Tags of many music files are not properly encoded. The result is those tags are not readable in music players. To fix those incorrectly encoded tags,

1. Highlight music files to be fixed in the main window of **iD3 Editor**;
1. Click the toobar button "Tag Fix";
1. In the new popup window, select the correct encoding used by those tags;

![encoding](encoding.png)

If a correct encoding has been selected, tags will be fixed automatically.

## Fetching Tag Information From File Names ##


![file name to tag](n2t.png)

Some music files have artist, album, title and track information in their file names. For those files, instead of manually entering tag values, you can use **iD3 Editor** to retrieve them automatically. 

![file names](fn.png)

Here is an example. File names in the picture above contain track numbers, artist, album name and MP3 title. To convert those them into tags:

1. Open these files with **iD3 Editor**, and have them selected;
1. Click the button "Tag Tools", and make sure tab "File Name To Tag" is highlighted;
1. Enter text *:T.:a-:A-:t-:y.*, and then click button "Apply";
1. Track number, artist, album and MP3 tag values are automatically filled;

Text *<font color=red>:T</font>.<font color=red>:a</font>-<font color=red>:A</font>-<font color=red>:t</font>-<font color=red>:y</font>.* mentioned in step 3 tells **iD3 Editor**:

1. At the beginning of the file name, is the track numbers, which is followed by a '.';
1. Artist comes after the '.', but before a '-';
1. Then it is the Album, followed by another '-';
1. After the '-' is the title;
1. At last, it is a '-' and the year, which is in front of a '.';

As you can see, *:T*, *:a*, *:A*, *:t* and *:y* are symbols to indicate locations of track number, artist, album, title and year in file names. Table below lists the meaning of all symbols supported by **iD3 Editor**:

| Symbol | Tags values to fetch |
|---|---|
|:a|artist|
|:A|album|
|:g|genre|
|:t|title|
|:T|track|
|:y|year|
|::|:|
|:x|arbitary text|

Symbol *:x* can be used to indicate arbitrary text not interesting to you; *::* is to indicate a single *:* in a file name (if any).

##Renaming Files With Tag Information##

![tag to file name](t2n.png)

Similarly, you can also rename a group of music files using their tag information. To do so,

1. Select files you want to rename;
1. Click the button "Tag Tools", and make sure tab "Tag To File Name" is highlighted;
1. Enter text *:T.:a-:A-:t-:y.*, and then click button "Apply";
1. Select files will be renamed using the pattern *track number.artist-album-title-year*

Below are two more examples:

1. renaming files to ***track.title***: 
  * :T.:t
1. renaming files to ***title-album-artist***:
  * :t-:A-:a







