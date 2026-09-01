# Audio plugin 

## Audio Files Outline

#### Document Audio Files  

##### Validate "all files" filter

Steps: 
 - Make sure the "selected files" filter is not selected
 - Count the number of shown files vs the number of document audio files 
Result:
- Both should be equal

##### Validate "selected files" filter

Steps: 
 - Make sure the "selected files" filter is selected
 - Count the number of shown files selected in the active outline vs the number of document audio files 
Result:
- Both should be equal

##### Validate selecting document audio file trigger editors panel scroll if file is shown

Steps: 
 - Make sure the "selected files" filter is selected
 - Click on a shown document audio file title  
Result:
- The selected editors panel should scroll to the file 


##### Validate selecting document audio file does not trigger editors panel scroll if file is not shown

Steps: 
 - Make sure the "selected files" filter is not selected
 - Click on a shown document audio file title that is not shown in the selected editors panel    
Result:
- The selected editors panel should does not scroll 

##### Validate document audio file "collapsed" state restored

Steps: 
 - Make sure the "selected files" filter is selected
 - Make sure a document audio file is collapsed 
 - Unselect this file from the files outline 
 - Validate that the previous document audio file is not shown anymore 
 - Select the same file gain from the files outline
Result:
- Validate that the previous document audio file is shown and in collapsed state 

##### Validate document audio file "uncollapsed" state restored

Steps: 
 - Make sure the "selected files" filter is selected
 - Make sure a document audio file is uncollapsed 
 - Unselect this file from the files outline 
 - Validate that the previous document audio file is not shown anymore 
 - Select the same file gain from the files outline
Result:
- Validate that the previous document audio file is shown and in uncollapsed state


##### Validate document audio file record

Steps: 
 - Click record in a document audio file  
Result:
- A new audio file appeared in recording state under the document audio file

##### Validate moving slider during audio playing should continue playing the file from the new location
