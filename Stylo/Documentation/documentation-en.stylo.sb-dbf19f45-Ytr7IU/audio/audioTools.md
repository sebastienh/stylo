
# Audio Tools

The _Audio Tools_ panel shows all the controls to control audio recording and playback in Nodio. 

To show the _Audio Tools_ panel: 

- From the _Project Tools Sidebar_: Mouse over the left side of the window, the _Project Tools Sidebar_ should appear. Click on the audio symbol. 

To hide the _Audio Tools_ panel: 

- From the _Project Tools Sidebar_: Click on the audio symbol. The audio panel should collapse. 

- From the menu: go to `View` -> `Hide Project Tools`

- From the keyboard: use `⌥⌘1`


## Audio Tools panel title view  

The audio title, along with its own title, shows the general _Stop Record_ button which allows to stop any active recording. 

## Audio outline 

The audio outline allows to see all audio recordings associated with each text file. Each text file has its own entry in the audio outline along with all the associated audio files.  

### Text audio files title 

All audio recordings under a same text file are grouped under its associated text audio files title. The _text audio file title_ is named after the associated text file. When the mouse is over it (or an audio recording under it is selected), two buttons will be visible on the right.
 
1. the _Record_ button 
2. the _Show/Hide_ button 

#### _Record_ button 

The _Record_ button allows to start and add a recording to an associated text file. This button can be in two states: `Ready To Record` or `Recording` state. 

When the button is in `Ready to record` state, it is completely red. It means that there is no recording going on for the associated text file. When pressed, a new recording will be added to the associated text document. 

When the button is in `Recording` state, it is red with a plus sign inside. It means that there is a recording going on and if pressed, the current recording will stop and a new one will be added to the associated text document.   

#### _Show/Hide_ button

On the right of the associated text audio files title, there is the _Show/Hide_ button which allows, as its title suggests, to show or hide the audio recordings associated with this text. 

### Audio recording 

Each time a _Record_ button is pressed, a new audio recording is added in the associated audio recordings and starts to record, stopping any current recording if any.  

#### Recording 

When recording, the new _Audio recording_ will show a flashing red microphone icon on its left. A default title will be shown at the top of the audio recording view, under this title, the recording start date and on the right, a timer indicating the recording total time. Note that, when a new recording is started, it is automatically selected, but it is totally possible to select other audio recording while recording in one. It's important to know though that playing another existing audio recording will stop the current recording. 

- [Start/Stop a recording](#startStopRecording)
- [Delete a recording](#deleteRecording)
- [Rename a recording](#renameRecording)


#### Playback

When a complete audio recording is selected it will display the playback view. This happens automatically when a recording stops and the selected audio has not been changed to another one. 

The playback controls extend the recording view. A slider allows to move in the recording and represent the complete recording. The timer at the start indicates the time played in the audio file and the right timer, under the right end of the slider, indicates how much time is left to play in the recording. Under the slider, three buttons allows to go back three seconds in the recording, play it, or go forward three seconds. 
 
- [Start/Pause playing](#startPausePlaying)

## Selection filter button 

At the complete bottom of the _Audio Tools_ panel, there is the selection filter button. When selected, only the document audio files from the selected items from the files outline will be shown in the audio outline. 

This button has been designed to work in conjunction with the editor's _Add Editor_ button.  When the audio panel is shown and the filter is active, it's possible to know exactly where we are recording. Adding new files using the _Add Editor_ button automatically adds them to the selection and  show them up on the _Audio Tools_ panel automatically.  
