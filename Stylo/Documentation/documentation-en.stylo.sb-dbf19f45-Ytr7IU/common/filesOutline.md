# Files Outline 

The files outlines helps to keep the source text files organized into a tree structure, mirroring the directory structure of the file format. 


## Files types 

There is three files types that can go inside the directory structure: `Group`, `Directory` and `File`.


### Group

A group is a "promoted" directory. The `group` concept is used to differentiate between top level directories and the other directories inside the files structure. 

A `group` being a directory, any directory can become a group and any group can become a directory. To create a group from an existing directory, simply drag it at the top level of the outline. 

To create a directory from an existing group, drag the group under another group or directory. 


#### Add a group (`⇧⌘R`)

To add a group:

- From the files outline title view, press the `+` button and chose `Group`

- From the menu, go to `File` -> `New Group`

- Using the keyboard, press `⇧⌘R`


#### Delete a group 

To delete a group:

- From the files outline title view, select the group to be deleted and press the `-` button.

- From the group popup menu, right click (`⌥+Click`) the group to be deleted, and chose the option: `Delete`

### Directory

The directory is the same as the file's system directory. It is used as a container for other directories and/or files.  


#### Add a directory (`⇧⌘D` )

To add a directory:

- From the files outline title view, press the `+` button and chose `Directory`

- From the menu, go to `File` -> `New Directory`

- Using the keyboard, press `⇧⌘D`

- From the popup menu, right click (`⌥+Click`) any item in the files outline, and chose the option: `Add Directory`

#### Delete a directory 

To delete a directory:

- From the files outline title view, select the directory to be deleted and press the `-` button.

- From the directory popup menu, right click the directory to be deleted, and chose: `Delete`

### File

A file is any source file and can only be of text type currently. The outline allows to move them around under existing directories/groups by dragging them but they can not be put at the root and become groups. In fact, in general, a text cannot morph into a directory and vice-versa. The two concepts are not interchangeable. 

#### Add a file (`⇧⌘T` )

To add a file:

- From the files outline title view, press the `+` button and chose `File`

- From the menu, go to `File` -> `New File`

- Using the keyboard, press `⇧⌘T`

- From the popup menu, right click (`⌥+Click`) any item in the files outline, and chose the option: `Add File`

- From the _Editors_ panel, press any of the _Add Editor_ buttons under each editor. 

#### Delete a file 

To delete a file:

- From the files outline title view, select the file to be deleted and press the `-` button.

- From the file popup menu, right click the file to be deleted, and chose the option: `Delete`

## Title bar 


The title bar shows the title of the document and two buttons to add or remove items. The `Add` button, represented by a plus sign, allows to add an item of any type: `Group`, `Directory` or `File` after the current selection last item.

The `Delete` button, represented by a minus sign, allows to remove all currently selected items. 


## Selecting/deselecting files

To select an item: 

- click on the item in the outline. 

To add an item to the selection: 

- Press `Command` and click with the mouse the item to be added to the selection. 

To extend the selection:

- Press `Shift` and click the last file that needs to be included in the selection, either above or below the current selection. 

