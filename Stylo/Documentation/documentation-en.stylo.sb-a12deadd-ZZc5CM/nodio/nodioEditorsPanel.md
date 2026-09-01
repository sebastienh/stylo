
# Editors Panes 

Nodio can display multiple _editors panes_ at the same time. In turn, each _editors pane_ supports displaying mulitple editors. 

## Editors Pane Title Bar 

Each _Editors Pane_ has its own title bar situated at the top. It allows to: 

  - close the current _editors pane_  using the left _Close Editors Pane_ button that represented by a `x`. 
  - navigate in the navigation history using the _Go Back_ and _Go Forward_ buttons each represented by an left and right arrow respectively.
  - change its name using the _Editors Pane Title_ text field name which is editable.
  - add a new text under the currently edited one using the _Add Editor_ button without needing to access the _Project Tool_ left sidebar's [files outline](#filesOutline). The newly created text file will automatically be inserted in the current _Editors Pane_ associated files outline selection. It will also be located directly under the _Add Editor_ button's panel's associated file in the same directory. 
- add a new _Editors Pane_ after the current one using the right _Add Editors Pane_ button.


### Navigation History

Each _Editors Pane_ keeps a complete history of all items added and removed to it and they allow to move this history using the `Go back` and `Go Forward` buttons. Any item addition or removal resulting from direct user action will remove all history forward from the current point ni history, a bit like a web browser.

#### Go back in navigation history 

To go back in navigation history:

- from the _Editors Pane Title Bar_, click on the  _Go Back_ button

- from the menu, go to `Editors` → `Go Back`

- from the keyboard, enter `⇧⌘←` 

#### Go forward in navigation history

To go forward in navigation history:

- from the _Editors Pane Title Bar_, click on the  _Go Forward_ button

- from the menu, go to `Editors` → `Go Forward`

- from the keyboard, enter `⇧⌘→` 

### Add a new _Editors Pane_ 

To add a new _Editors Pane_:

- from the _Editors Pane title bar_, click on the _Add Editors Pane_ button on the right of the _Editors Pane Title Bar_.   

- from menu, go to `Editors` → `Add Editors Pane`

- from the keyboard, enter `⇧⌘n`


### Close the current _Editors Pane_ 

To close the current _Editors Pane_:

- from the _Editors Pane title bar_, click on the left _Close Editors Pane_ button on the left.   

- from menu, go to `Editors` → `Close Current Editors Pane`

- from the keyboard, enter `⇧⌘w`


### Add new file in current _Editors Pane_ under currently edited file 

To add a new file in the current _Editors Pane_:

- from the _Editors Pane title bar_, click on the _Add Editor_ button situated just before on the right _Add Editors Pane_ button.   

- from menu, go to `Editors` → `Close Current Editors Pane`

- from the keyboard, enter `⇧⌘w`


# Editor 
 
Each _Editors Pane_ displays all the selected files from the corresponding [files outline](#filesOutline). Each editor displays a title bar and the text content in an editor.  

## Editor Title bar  
 
### File path 

The title bar displays the _file path_ on its left. For information compaction reason, and if there is enough space, only the top directory and the file name, at the end of the path are shown. The middle directories between the top and the file are represented with their first letter only and will expand when the mouse is over them. When there is not enough space even for the top item and the last (the file name), the will be gradually compressed also. 

It's always possible to change the file's name using the _file path_ by clicking on it to go in edition mode. 


### Audio controls 

The _audio controls_ show a _Record_ button and a _Show/Hide Editor_ button. 

The title bar can be used to moved the window, the same as a classical title. On double click, the filename becomes editable to allow to modify it from inside the editor. 


### _Show/Hide Editor_ button

As we already mentioned, the _Editors_ panel displays the selected files from the associated [files outline](#filesOutline). If for some reason, we need to temporarily hide an editor that we don't need but still want to keep in the selection. In this case, we can use the _Show/Hide_ button to do so. When hidden, only the title bar from will be shown and both the text editor and the plus panel will be hi

