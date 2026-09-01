# Stylo 

## Logs 

The format version will be available using the WriterCommon project version tag. 

### Release 0.4.2

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.4.2|
|WriterCommon|0.4.X|
|Markdown|0.4.X|
|Web|0.4.X|
|Igloo|0.3.0|
|Common|0.4.X|

#### Included stories 

NW-1564: Removing a header deletes more characters


### Release 0.4.1

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.4.1|
|WriterCommon|0.4.1|
|Markdown|0.4.0|
|Web|0.4.0|
|Igloo|0.3.0|
|Common|0.4.0|

#### Included stories 

- Fixed trim() function. 
- NW-1561: HTML block not appearing in preview

### Release 0.4.0

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.4.0|
|WriterCommon|0.4.0|
|Markdown|0.4.0|
|Web|0.4.0|
|Igloo|0.3.0|
|Common|0.4.0|

#### Included stories 

NW-1518: Implement asynchronous/synchronous compilation switching to improve performance
NW-1523: Crash while showing the styles list
NW-1528: weak reference to MarkdownDocumentStore can be nil in TextManager

### Release 0.3.52

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.52|
|WriterCommon|0.3.4|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.3|

#### Included stories 

NW-1509: style-icon-smaller-inner-circle

### Release 0.3.51

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.51|
|WriterCommon|0.3.3|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.2|

### Release 0.3.5

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.5|
|WriterCommon|0.3.3|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.2|

### Release 0.3.4

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.4|
|WriterCommon|0.3.3|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.2|

### Release 0.3.3

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.3|
|WriterCommon|0.3.2|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.2|

#### List of stories 

### Release 0.3.2

#### Versions 

|Project|Version|
|---|----|
|Stylo|0.3.2|
|WriterCommon|0.3.2|
|Markdown|0.3.1|
|Web|0.3.1|
|Igloo|0.3.0|
|Common|0.3.2|

#### List of stories 

## Custom Fonts  

When we add a new font directory to the fonts directory we need to run the `font-to-plist.sh` script. lll


## Style 

A CSS style can have one user style sheet. When we define a CSS style in a directory, if we want a user style sheet in the style 
we must name the stylesheet "user.css" and only one stylesheet must have this name. 

Stylesheet names are used to know their origin. 

If they ends with "ua" it means it is user-agent stylesheet
If they ends with "user" it means it is user stylesheet


## Themes

### Theme management

Themes are used to style all the application. Each style inside a theme is divided in two, one for light styling and one for dark styling.


Themes are kept in the Resouce dirctory of the application, they are not copied to the application container. Each document loads them. If the application is in debug mode, a copy of them will be saved along with the document.

## TODO 

- Remove the ResourceModelManager protocol conformane to StyleManager
- REmove Editable confoirmance of StringResoureModelRenderingCoordinator

put back in Editable     
//  Get the typping attributes
//func typingAttributes(for selectedRange: NSRange) -> [String: Any]?


## Configuration variables 

SAFE_DOM: test for DOM being handled properly, all validations are done. Should be disabled in release mode. 

MUTATION_RECORDS: define if mutation records are enabled or not. 

ALPHA_COLOR_ENABLED: define if we want the alpha colors or not.

## Messages 

### Popover

Message popover appearance/disappearances rules: 

A message popover should disappear after 2 seconds if the user doesn't move the mouse. 
A message popover can not appear when the user is writing.  
A message popover disappear if the user writes.


## Text decorations 



## Update the help index 

Sebastiens-MBP:Resources sebastienhamel$ pwd
/Users/sebastienhamel/Documents/nebula.media/development/Stylo/Stylo/Stylo/stylo.help/Contents/Resources
Sebastiens-MBP:Resources sebastienhamel$ rm English.lproj/search.helpindex 
Sebastiens-MBP:Resources sebastienhamel$ hiutil --create English.lproj/ --file English.lproj/search.helpindex



