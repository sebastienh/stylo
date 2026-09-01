#  Outline tests specifications


## Insertion 

### Into group 

#### Into selected group

##### Empty group 

###### Insert file inside empty selected group should add the file at the start of the group, and display it in the editors pane   

###### Insert directory inside empty selected group should add the directory at the start of the group 

##### Non-empty group  

###### Insert a file inside a non-empty selected group should add the file at the end of the group, and display it in the editors pane 

###### Insert a directory inside a non-empty selected group should add the directory at the end of the group, and editors pane should be empty


#### Into group with selected file inside it 

##### Insert a file inside a non-empty group with selected file inside it, should add the file after the selected file, and display it in the editors pane 

##### Insert a directory inside a non-empty group with selected file inside it, should add the directory after the selected file, and editors pane should be empty


### Into directory 

#### Into selected directory 

##### Empty directory 

###### Insert file inside empty selected directory should add the file at the start of the directory, and display it in the editors pane   

###### Insert directory inside empty selected directory should add the directory at the start of the group 

##### Non-empty directory  

###### Insert a file inside a non-empty selected directory should add the file at the end of the directory, and display it in the editors pane 

###### Insert a directory inside a non-empty selected directory should add the directory at the end of the directory, and editors pane should be empty


#### Into directory with selected file inside it 

##### Insert a file inside a non-empty directory with selected file inside it, should add the file after the selected file, and display it in the editors pane 

##### Insert a directory inside a non-empty directory with selected file inside it, should add the directory after the selected file, and editors pane should be empty

## Deletion 

### From group 

#### Delete a file selected from a group should remove the file from the outline and the editor pane 

#### Delete a directory selected from a group should remove the file from the outline and the editor pane 


### From directory 

#### Delete a file selected from a directory should remove the file from the outline and the editor pane 

#### Delete a directory selected from a directory should remove the file from the outline and the editor pane 

## Move 

### Directory 

#### Moving an empty directory inside a selected directory should not change the editors panes

#### Moving an non-empty directory inside a selected directory should reflect in the editors panes 

#### Moving a file in an empty group

#### Moving a file over another file in a group

#### Moving a file below another file in a group

#### Moving a file over another directory in a group

#### Moving a file below another directory in a group

#### Moving a file in an empty directory

#### Moving a file over another file in a directory

#### Moving a file below another file in a directory

#### Moving a file over another directory in a directory

#### Moving a file below another directory in a directory

### File 

### Moving a file in an empty selected directory, the editors pane should show the file  

### Moving a user selected file as a descendant of a user selected directory should keep it selected

### 

## Rename 

### Empty name

#### Rename a group with an empty name 

#### Rename a file with an empty name 

#### Rename a directory with an empty name 

### Name already exist

#### Rename a group with a name that already exist in the context 

#### Rename a file with a name that already exist in the context 

#### Rename a directory with a name that already exist in the context 



