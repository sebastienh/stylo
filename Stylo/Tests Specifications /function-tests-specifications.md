
#  Tests specifications 

## Creating Stylo document  

### New Stylo document
Steps: 
- Go to `File` -> `New`
Result: 
- A new Stylo document should be created
- Validate that the styles correspond to their name 

## Opening document

### Markdown document   
Steps:
- Open a .md document 
Results:
- The Markdown document should open properly 

### Plain-text document 
Steps:
- Open a .txt document 
Results:
- The plain-text document should open properly 

### Stylo document 
Steps:
- Open a .stylo document 
Results:
- The Stylo document should open properly 

## Saving document  

Note: for each of these scenarios we should make sure when we "save as..." that the original document keeps it's original window size and that when reopened it opens with it.


### Markdown document as Markdown document  
Steps:
- Open a .md document 
- Go to `File`->`Save`
- Chose the `Mardkown` format 
- Click the `Save` button
Results:
- The Markdown document should save properly and it's format and extension should be .md

### Markdown document as plain-text document  
Steps:
- Open a .md document 
- Go to `File`->`Save` 
- Chose the `Plain Text` format 
- Click the `Save` button
Results:
- The Markdown document should save properly and it's format and extension should be .txt

### Markdown document as Stylo document  
Steps:
- Open a .md document 
- Go to `File`->`Save`
- Chose the `Stylo` format 
- Click the `Save` button
Results:
- The Markdown document should save properly and it's format and extension should be .stylo

### Plain-text document as Markdown document  
Steps:
- Open a .txt document 
- Go to `File`->`Save`
- Chose the `Mardkown` format 
- Click the `Save` button
Results:
- The Pain text document should save properly and it's format and extension should be .md

### Pain-text document as plain-text document  
Steps:
- Open a .txt document 
- Go to `File`->`Save`
- Chose the `Plain Text` format 
- Click the `Save` button
Results:
- The plain-text document should save properly and it's format and extension should be .txt

### Plain-text document as Stylo document  
Steps:
- Open a .txt document 
- Go to `File`->`Save`
- Chose the `Stylo` format 
- Click the `Save` button
Results:
- The plain-text document should save properly and it's format and extension should be .stylo

### Save a .stylo document 

Steps:
- Open a .stylo document 
- Modify it
- Go to `File`->`Save`
- Close the document
- Open the same document
Results:
- The .stylo document should save properly and it's format and extension should be .stylo

### Save a .txt document 

Steps:
- Open a . txt document 
- Modify it
- Go to `File`->`Save`
- Close the document
- Open the same document
Results:
- The . txt document should save properly and it's format and extension should be . txt

### Save a .md document 

Steps:
- Open a .md document 
- Modify it
- Go to `File`->`Save`
- Close the document
- Open the same document
Results:
- The .md document should save properly and it's format and extension should be .md

## Restore an old version 

### Restore an old plain-text document version 

Steps:
- Open a . txt document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Chose an old version of the document 
- Click `Restore`
Results:
- The document should be restored properly and be displayed as it should be 

### Restore an old markdown document version 
 
Steps:
- Open a .md document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Chose an old version of the document 
- Click `Restore`
Results:
- The document should be restored properly and be displayed as it should be 

### Restore an old Stylo document version 

Steps:
- Open a .stylo document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Chose an old version of the document 
- Click `Restore`
Results:
- The document should be restored properly and be displayed as it should be 

### Restore an old Stylo document version in HTML preview mode  without sidebar displayed

Steps:
- Open a .stylo document 
- Go in HTML preview mode 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Chose an old version of the document 
- Click `Restore`
Results:
- The document should be restored properly and be displayed as it should be 

### Restore an old Stylo document version in HTML preview mode with sidebar displayed

Steps:
- Open a .stylo document 
- Go in HTML preview mode 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Chose an old version of the document 
- Click `Restore`
Results:
- The document should be restored properly and be displayed as it should be 

### Restore an old Stylo document version in HTML preview mode with sidebar displayed and title displayed 

### Restore an old Stylo document version from "Revert To"->"Last Opened" in HTML preview mode with sidebar displayed and title displayed 


### Restore an old Stylo document version from "Revert To"->"Last Opened" in text mode with sidebar displayed and styles list displayed

### Restore an old Stylo document version from "Revert To"->"Last Opened" in text mode with sidebar displayed and style editor opened 
 

### Make sure we can not move the windows in versions mode

### Make sure when restoring a document that the same window size and position is used 


## Cancel restore an old version 

### Cancel restore an old plain-text document version 

Steps:
- Open a .txt document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Click `Done`
Results:
- The old document should be back properly and be displayed as it should be. 
- It should be possible to preview the document 
- It should be possible to style the document 

### Cancel restore an old markdown document version 
 
Steps:
- Open a .md document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Click `Done`
Results:
- The old document should be back properly and be displayed as it should be. 
- It should be possible to preview the document 
- It should be possible to style the document 

### Cancel restore an old Stylo document version 

Steps:
- Open a .stylo document 
- Go to `File` -> `Revert To` -> `Browse All Versions...`
- Click `Done`
Results:
- The old document should be back properly and be displayed as it should be. 
- It should be possible to preview the document 
- It should be possible to style the document 

## Edit an opened .md document outside Stylo

Steps:
- Open a .md document 
- Open the same file in another editor
- In the other editor, modify the file 
- Go back to the open document in Stylo
- Try to save the document
- A popup should appear
Results:
- The document in Stylo should display the changes made in the other editor  

## Edit an open .txt document outside Stylo

Steps:
- Open a .md document 
- Open the same file in another editor
- In the other editor, modify the file 
- Go back to the open document in Stylo
- Try to save the document
- A popup should appear
Results:
- The document in Stylo should display the changes made in the other editor  

## Duplicate a document 

### Duplicate a .stylo document 

Steps:
- Open a .stylo document 
- Go to `File` -> `Duplicate`
Results:
- A new document identical to the duplicated document without document icon since the document is not saved yet 

### Duplicate a .txt document 

Steps:
- Open a .txt document 
- Go to `File` -> `Duplicate`
Results:
- A new document identical to the duplicated document without document icon since the document is not saved yet 

### Duplicate a .md document 

Steps:
- Open a .md document 
- Go to `File` -> `Duplicate`
Results:
- A new document identical to the duplicated document without document icon since the document is not saved yet 

## Rename a document

### Rename a .md using the title bar 

Steps:
- Open a .md document 
- Go to `File` -> `Rename`

Result:
- The title bar should allow to change the name of the document 

### Rename a .txt using the title bar 

Steps:
- Open a .txt document 
- Go to `File` -> `Rename`

Result:
- The title bar should allow to change the name of the document 

### Rename a .stylo using the title bar 

Steps:
- Open a .stylo document 
- Go to `File` -> `Rename`

Result:
- The title bar should allow to change the name of the document 


## Views resize 

### Preview: tests all resize with all possible views opened
Steps: 
- Open a document 
- Open the preview 
- Resize the document  

### Preview: tests all resize with all possible views opened
Steps: 
- Open a document 
- Open the preview 
- Resize the document 


## Fullscreen 

### Edit Markdown in full screen 
### Edit CSS in fullscreen 
### View issues in fullscreen 
### HTML preview in fullscreen
### Style picker in fullscreen
### Rename document in fullscreen
### Move document in fullscreen

## HTML elements types 

### Validations: 


### see HTMLSequenceType for the list 






### script

Steps: 
- Make sure this is properly handled: 
<script> 
foo
</script>1. *bar*
Result: 
- the script should be invisble in the preview 
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### comment

Steps: 
- Make sure this is properly handled: 
<!-- script>
foo
</script-->1. *bar*
Result: 
- the comment should be invisble in the preview 
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### processingInstruction

Steps: 
- Make sure this is properly handled: 
<?php

echo '>';

?>
okay

Result: 
- In the preview, we should see: 

"'; ?>
okay"
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### doctype

Steps: 
- Make sure this is properly handled: 
<!DOCTYPE html>
Result: 
- In the preview, we should see: 
nothing
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### cdata

Steps: 
- Make sure this is properly handled: 
<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
okay

Result: 
- In the preview, we should see: 
"okay"
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### htmlBlock
Steps: 
- Make sure this is properly handled: 
<h1>titre 1</h1>
Result: 
- In the preview, we should see: 
"titre 1"
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

### generic 
Steps: 
- Make sure this is properly handled: 
  <div>

    <div>
Result: 
- In the preview, we should see: 
nothing
- HTML Preview synchronisation  
- HTML export 
- PDF generation 

## Styles drag operation 

### Drag selected style 
Result: The style should be at the new position, and the style should still be applied 

### Drag unselected style 
Result: The style should be at the new position, and the style should still not be applied


## Image tests 

### Test preview image remote 
Result: should see the image in the preview document. 

### Test preview image local
Result: This feature is not supported yet but the user should see a square with the name of the image.


## Styles table 

### Delete an existing style 




## Styles chooser sidebar

### Empty styles (not possible anymore) 
Result: Nothing shown 

### Styles number small 
Result: No progress bar shown
Result: the styles are centered in the center of the bar 

### Styles number big
Result: Progress bar shown


### Styles number big: resize window
Result: the progress indicator disappear if the the window contains all sytles 
Result: the progress bar appears if the the window does not contain all sytles 
While resizing the window, the progress reflects the styles length vs window height


## Copy Selector tests 

### Make sure the copy selector works with all element types everywhere they can be  


## Fonts testing 

### Test loading a already present font family

Steps: 
- Add a font family X to the system
- Add the same font family to the Stylo fonts directory
- Run the ./font-to-plist.sh script in the Stylo directory
- Start Stylo
- Go to a CSS Style and try to define this font-family for an element using auto-completion

Expected result: 

- There should be only one font-family in the auto-completion list 
- Font should apply according to the CSS rules 


## Browse all versions tests 

### Ensure sidebar stays in background mode when going in "Browse All Versions..." mode 

Steps: 
- go to "Browse All Versions..." mode
- over the mouse on top of the sidebar visual region 

Expected result: 

The sidebar should stay in background mode 

### Ensure HTML preview disappear when going in "Browse All Versions..." mode 

Steps: 
- put the document in preview mode 
- go to "Browse All Versions..." mode 

Expected result: 

All documents are shown in text mode 

### Ensure tools sidebar tab disappear when going in "Browse All Versions..." mode 

Steps: 
- display the sidebar in "tools mode"
- go to "Browse All Versions..." mode 

Result: 

The sidebar change to text background mode: it  disappears. 

### Ensure style selector sidebar tab disappear when going in "Browse All Versions..." mode 

Steps: 
- display the sidebar in "style selector mode"
- go to "Browse All Versions..." mode 

Expected result: 

The sidebar change to text background mode: it  disappears. 


## Markdown format menu 

### Create heading 1 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 1`

Result: 
The line has a "#" at the start.

### Convert to heading 1 

Steps: 
- Using the text below: 

Text to make h1

- Go to `Format`->`Heading 1`

Result: 
The text become h1. 

### Deleting heading 1: #  

Steps: 
- Using the text below: 

# Text to remove h1

- Go to `Format`->`Heading 1`

Result: 
The text become lose h1 

### Create heading 2 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 2`

Result: 
The line has a "##" at the start.

### Convert to heading 2 

Steps: 
- Using the text below: 

Text to make h2

- Go to `Format`->`Heading 2`

Result: 
The text become h2. 

### Deleting heading 2: #  

Steps: 
- Using the text below: 

## Text to remove h2

- Go to `Format`->`Heading 2`

Result: 
The text become lose h2 

### Create heading 3 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 3`

Result: 
The line has a "###" at the start.

### Convert to heading 3 

Steps: 
- Using the text below: 

Text to make h3

- Go to `Format`->`Heading 3`

Result: 
The text become h2. 

### Deleting heading 3: #  

Steps: 
- Using the text below: 

### Text to remove h3

- Go to `Format`->`Heading 3`

Result: 
The text become lose h3 

### Create heading 4 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 4`

Result: 
The line has a "####" at the start.

### Convert to heading 4 

Steps: 
- Using the text below: 

Text to make h4

- Go to `Format`->`Heading 4`

Result: 
The text become h4. 

### Deleting heading 4: #  

Steps: 
- Using the text below: 

#### Text to remove h4

- Go to `Format`->`Heading 4`

Result: 
The text become lose h4

### Create heading 5 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 5`

Result: 
The line has a "#####" at the start.

### Convert to heading 5 

Steps: 
- Using the text below: 

Text to make h5

- Go to `Format`->`Heading 5`

Result: 
The text become h5. 

### Deleting heading 5: #  

Steps: 
- Using the text below: 

##### Text to remove h5

- Go to `Format`->`Heading 5`

Result: 
The text become lose h5

### Create heading 6 

Steps: 
- On an empty line 

- Go to `Format`->`Heading 6`

Result: 
The line has a "######" at the start.

### Convert to heading 6 

Steps: 
- Using the text below: 

Text to make h6

- Go to `Format`->`Heading 6`

Result: 
The text become h6. 

### Deleting heading 6: #  

Steps: 
- Using the text below: 

###### Text to remove h6

- Go to `Format`->`Heading 6`

Result: 
The text become lose h6

### Create blockquote 

Steps: 
- On an empty line 

- Go to `Format`->`Blockquote`

Result: 
The line has a ">" at the start.

### Convert to blockquote 

Steps: 
- Using the text below: 

> Text to make blockquote

- Go to `Format`->`Blockquote`

Result: 
The text become blockquote 

### Increasing blockquote 

Steps: 
- Using the text below: 

> Text to increase blockquote

- Go to `Format`->`Blockquote`

Result: 
The text increase blockquote


### Create unordered list   

Steps: 
- On an empty line 

- Go to `Format`->`Unordered List`

Result: 
The line has a "-" at the start.

### Convert to unordered list  

Steps: 
- Using the text below: 

Text to make unordered list 
Text to make unordered list 
Text to make unordered list 
Text to make unordered list 

- Go to `Format`->`Unordered List`

Result: 
The text become unordered list  

### Create ordered list   

Steps: 
- On an empty line 

- Go to `Format`->`Ordered List`

Result: 
The line has a "1." at the start.

### Convert to ordered list  

Steps: 
- Using the text below: 

Text to make ordered list 
Text to make ordered list 
Text to make ordered list 
Text to make ordered list 

- Go to `Format`->`Ordered List`

Result: 
The text become ordered list  

### Create bold

Steps: 
- On an empty line 

- Go to `Format`->`Bold`

Result: 
The selection has become "****" wth the cursor in the center.

### Convert to bold  

Steps: 
- Select the text below: 

Text to make bold

- Go to `Format`->`Bold`

Result: 
The text become bold

### Create italic

Steps: 
- On an empty line 

- Go to `Format`->`Italic`

Result: 
The selection has become "__" wth the cursor in the center.

### Convert to italic  

Steps: 
- Select the text below: 

Text to make italic

- Go to `Format`->`Italic`

Result: 
The text become italic


### Convert to strikethrourgh  

Steps: 
- Select the text below: 

Text to make strikethrourgh

- Go to `Format`->`Strikethrourgh `

Result: 
The text become strikethrourgh

## Markdown Parsing tests 

### Reference change label to a potentially referencing token 








