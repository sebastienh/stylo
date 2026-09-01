
# Files Outline View 

A _Files Outline View_ is a specific view of the files in a document. It's an outline view which contains user selected items and expanded ones. A specific navigation history is also associated with each _Files Outline View_. Each _Files Outline View_ is also associated with a corresponding [_Editors Panel_](../nodio#editorsPanel) which shows the selected text files computed based on the _Files Outline View_'s user selected items. 

## Select the _Files Outline View_

If the Navigator is not opened, click on the [left sidebar button](#sidebarButtons). 

To select the _Files Outline View_:

- from the [Navigator Title Bar](#navigatorTitleBar)'s [_navigator tool selector button_](#toolSelectorButton): click on the `Files` popup menu item. 

## Items types 

There is three items types that can go inside the directory structure: `Group`, `Directory` and `File`.

### Group

A group is a "promoted" directory. The `group` concept is used to differentiate between top level directories and the other directories inside the files structure. 

A `group` being a directory, any directory can become a group and any group can become a directory. To create a group from an existing directory, simply drag it at the top level of the outline. 

To create a directory from an existing group, drag the group under another group or directory. 

### Directory

The directory is the same as the file's system directory. It is used as a container for other directories and/or files.  

### File

A file is any source file and can only be of text type currently. The files outline view allows to move them around under existing directories/groups by dragging them but they can not be put at the root and become groups. In fact, in general, a text cannot morph into a directory and vice-versa. The two concepts are not interchangeable. 

## Subviews 

The _Files Outline View_ contains two subviews: 

- _Files Outline Actions Bar_
- _Outline View_

### Files Outline Actions Bar

The _Files Outline Actions Bar_ is located at the top of the _Files Outline View_ and shows two buttons to add and/or remove items. 

The _Add Item_ button, represented by a plus sign, allows to add an item of any type: `Group`, `Directory` or `File` after the current selection last item if it's a `File` or at the end of the current container if it's a `Group` or `Directory`.

The _Delete Item_ button, represented by a minus sign, allows to remove all user selected items and their descendants.  

### Outline View 

The outline view follows a simple structure. At the top level we can only have groups. Under a group there could be any number of files or directory, and recursively, the same applies for the directory.  

## Actions

### Select/deselect an item

To select an item: 

- click on the item in the outline. 

To add an item to the selection: 

- Press `Command` and click on the item to be added to the selection. 

To extend the selection:

- Press `Shift` and click the last file that needs to be included in the selection, either above or below the current selection. 

### Rename an item

To rename an item:

- from the _Files Outline View_: click on a uniquely selected item. 

It's also possible to rename a file from the [_File Editor_](../nodio#fileEditor)

- from the [_File Editor_](../nodio#fileEditor): click on the file name in the file path located on the left of the _Editor Title Bar_. The title will go in edit mode. 

### Add a group (`⇧⌘R`)

To add a group:

- From the files outline title view, press the `+` (_Add Item_) button from the _Files Outlines Panel Title Bar_ and chose `Group`

- From the menu, go to `File` -> `New Group`

- Using the keyboard, press `⇧⌘R`

### Delete a group 

To delete a group:

- From the files outline title view, select the group to be deleted and press the `-`(_Delete Item_) button from the _Files Outlines Panel Title Bar_.

- From the group popup menu, right click (`⌥+Click`) the group to be deleted, and chose the option: `Delete`

### Move a group

Dragging a group under another group or directory will automatically convert this group into a directory. 

To move a group: 

  1. click on the group in the outline
  2. drag the group to the target position  


### Expand/Collapse a group 

To expand a group: 

  1. Move the pointer over the target group, a Show/Hide indicator should appear on the right. 
  2. Click on the indicator.  

### Add a directory (`⇧⌘D` )

To add a directory:

- From the files outline title view, press the `+`(_Add Item_)  button from the _Files Outlines Panel Title Bar_ and chose `Directory`

- From the menu, go to `File` -> `New Directory`

- Using the keyboard, press `⇧⌘D`

- From the popup menu, right click (`⌥+Click`) any item in the files outline, and chose the option: `Add Directory`

### Move a directory

Dragging a directory at the top level will convert this directory into a group. The concepts of directory and files, like in a real directory are not interchangeble, so dragging a file at the top level is not possible and will cause an error. Remember, no magic! a document is simply a directory on the file system.

To move a directory: 

  1. click on the directory in the outline
  2. drag the directory to the target position  


### Delete a directory 

To delete a directory:

- From the files outline title view, select the directory to be deleted and press the `-`(_Delete Item_) button from the _Files Outlines Panel Title Bar_.

- From the directory popup menu, right click the directory to be deleted, and chose: `Delete`

### Expand/Collapse a directory 

To expand a group: 

- click on the left expand/collapse indicator.  

### Add a file (`⇧⌘T` )

To add a file:

- From the files outline title view, press the `+`(_Add Item_)  button from the _Files Outlines Panel Title Bar_ and chose `File`

- From the menu, go to `File` -> `New File`

- Using the keyboard, press `⇧⌘T`

- From the popup menu, right click (`⌥+Click`) any item in the files outline view, and chose the option: `Add File`

- From the _Editors_ panel, press any of the _Add Editor_ buttons under each editor. 

### Move a file

Note that a file cannot be moved at the top level, only groups/directory can be found at the top.

To move a file: 

  1. click on the file in the outline
  2. drag the file to the target position  


### Delete a file 

To delete a file:

- From the files outline title view, select the file to be deleted and press the `-` (_Delete Item_) button from the _Files Outlines Panel Title Bar_.

- From the file popup menu, right click the file to be deleted, and chose the option: `Delete`

