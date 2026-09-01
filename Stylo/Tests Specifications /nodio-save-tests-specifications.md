# Nodio tests 

## Generic saves tests 
### Close empty new document 
Steps:
- Create a new document 
- Leaves it empty 
- Close it 
Result:
- The document should close without any dialog popup
- There shouldn't be any file in the TemporaryItems 

/var/folders/2k/wd7v2d394q93_cgt_19nk9740000gn/T/net.textually.nodio/TemporaryItems

### Close a new edited document 
Steps:
- Create a new document 
- Edit it 
- Close it 
Result:
- The document should close without any dialog popup
- There shouldn't be any file in the TemporaryItems 

/var/folders/2k/wd7v2d394q93_cgt_19nk9740000gn/T/net.textually.nodio/TemporaryItems

### Close empty old document 
Steps:
- Create an empty document and save it 
- Open it again 
- Close it 
Result:
- The document should close without any dialog popup

### Close and old edited document 
Steps:
- Create an empty document edit it and save it 
- Open it again 
- Close it 
Result:
- The document should close without any dialog popup


## Save tests for audio 

### New Nodio document before autosave 
Steps: 
- Go to `File` -> `New`
- Record audio 1s  
- Save 
- Reopen 
Result: 
- Validate the audio is there  

### New Nodio document after autosave 
Steps: 
- Go to `File` -> `New`
- Record audio 1s
- Start writing
- Wait for 60 seconds 
- Save 
- Reopen 
Result: 
- Validate the audio is there  

### New Nodio document save during recording  
Steps: 
- Go to `File` -> `New`
- Record audio
- Start writing 
- Save 
- Reopen 
Result: 
- Validate the audio is there  


