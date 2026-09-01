title 1
------- 

# This is level one kkkkkkk




## titre 2

Titre 2
--------------

### title 3
#### title 4
##### title 5
###### title 6

##  Horizontal Bar  

---

*******

# emphasis  

*Emphasized text 1*
_Emphasized text 2_

**important text**  
__important text__

# Strikethrough  

~~strikethrough text~~  

# Blockquote  

> > > > > > > > citation bloc 
> citation  bloc
> d
;;;;;;

# Lists

### Unordered 

sssss

* list element
* list element
* list element
ssss
- list element
- list element
- list element
sssss

+ list element
+ list element
+ list element
sss
- isstem one
- itesm two
+ other list item one
+ other list item  two



### Ordered   

1. first item  
2. second item 
3. third item 

1) first item  
2) second item 
3) third item 


### Nested 
 
To nest a list inside another list simply indent all items of the nested list by a minimum of two spaces from the start of the line of the nesting list. 

Markdown:

- item one
- item two
  + nested list using two spaces after the start of nesting list  
  + nested sublist item 
    * another nested list started two spaces after the nesting list (four from the start)
    * another nested list

- item one
- item two
  + nested list using two spaces after the start of nesting list  
  + nested sublist item 
    * another nested list started two spaces after the nesting list (four from the start)
    * another nested list


# Code 

  markdown
# title
 


### Inline 

Markdown:

A line with `code`.


<pre><code>
func estEven(number: Int) -> Bool {
	return number%2 == 0 
}
</code></pre>

 
Markdown / HTML:

    // Comment
    line 1 of the code
    line 2 of the code

	ssssss

   	 line 3 of the code


| Column 1 | Column 2 |
| - | - |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
|sasasasasasasa|sassasasa|


| Column 1 | Column 2 |
| ------:| -----------:|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |

| Column 1 | Column 2 |
| :------| :-----------|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |


An example of a reference to [Textually](http://www.textually.net):

[textually]: www.textually.net


[textually]: www.textually.net

[textually]: www.textually.net "Textually website"


[Stylo](www.textually.net/stylo)


[link][idStylo]

[idStylo]: www.textually.net/stylo

![Logo](www.textually.net/stylo/images/logo.png)

![Logo](www.textually.net/stylo/images/logo.png)

![Logo](www.textually.net/stylo/images/logo.png "Logo")

![alternative text][idImage]

[idImage]: http://www.textually.net/stylo/images/logo.png "Logo"


 # Stylo User Guide 

## Contents ## 



---------------------------------------------------------------------------------------------------------
<!-- index.html-->


# Stylo Help 

1. [Essentials](stylo/essentials.html) 
    - [New document](stylo/new-document.html)
    - [Save a document](stylo/save-document.html)
    - [Save as](save-as.html)
    - [Rename a document](stylo/rename-document.html)
    - [Export a document](stylo/export-document.html)
    - [Print a document](stylo/print-document.html) 

2.  Using Stylo 
    - [User Interface](stylo/user-interface.html)
    - [Applying Style](stylo/select-a-style.html)
    - [Adding a Style](stylo/add-a-style.html)
    - [Editing a style](stylo/edit-a-style.html)
    - [Text Statistics and Session Popup](stylo/text-statistics.html)

3. Markdown Formatting
    - [Header level 1](stylo/header-level-1.html)
    - [Header level 2](stylo/header-level-2.html)
    - [Header level 3](stylo/header-level-3.html)
    - [Header level 4](stylo/header-level-4.html)
    - [Header level 5](stylo/header-level-5.html)
    - [Header level 6](stylo/header-level-6.html)
    - [Blockquote](stylo/blockquote.html)
    - [Unordered list](stylo/unordered-list.html)
    - [Ordered list](stylo/ordered-list.html)
    - [Bold](stylo/bold.html)
    - [Italic](stylo/italic.html)
    - [Strikethrough](stylo/strikethrough.html)
    - [Link](stylo/link.html)
    - [Horizontal Bar](markdown/md-horizontal-bar.html)
    - [Code](markdown/md-code.html)
    - [Table](markdown/md-table.html)
    - [Reference](markdown/md-reference.html)
    - [Image](markdown/md-image.html)

4. More 
    - [CSS Guide](css/contents.html)
    - [HTML Guide](html/contents.html)
    - [Markdown Reference](markdown/contents.html)
    - [Bundled Fonts](stylo/bundled-fonts.html)
    - [Color keywords](css/color-keywords.html)
    - [Keyboard shortcuts](stylo/keyboard-shortcuts.html)
    - [Acknowledgments](stylo/acknowledgments.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/stylo.html"-->


# Stylo

Stylo is a Markdown text editor. It implements the [CommonMark](https://commonmark.org/) version with some additions, like tables and striketrough. Markdown, and lightweight markup languages in general, were a big progress in the evolution of text editors. It clearly separated the content from the presentation. In Markdown, what we see is the content, without any formatting: bold, italics or the different fonts we could use in a Rich Text editor. These are applied later in the  publication process, and can be applied many times over time and/or for different plateforms. The old way of doing things using Rich Text, were publishing design was embeded in the source text and saved along with the content, was simply not adapted for the publishing environment of today.

But, for many writers,  Rich text was a way to personalize their own writing environment and the design that was applied to their source text was not for the end audience but for themselves, as a writer, to help them feel comfortable, inspired while writing. Every writer has it's own needs and preferences. The text editor has become a major part of the writing environment. In the paper era, a writer could use a particular kind of paper, he could write with different kind of pens, to get different lines thickness, or could use a different ink color, brand or tint. These things were all part of the writing experience: with Markdown we lost most of that. These habits were not part of a design process for the end published text, but part of a personal design experience to enhance the writing.   

In Stylo, we bring back this personnal experience at it's highest level without comprimising the advantages of Markdown. Markdown is a plain text format, and one consequence is we can not save design information. Stylo solves the problem of personnalisation using the Web technologies and mainly using CSS, which is also a plain text format: _Stylo is plain text editing with rich text formatting._ 

---------------------------------------------------------------------------------------------------------
<!-- stylo/file-format.html"-->

# File format 

Markdown files use the _.md_ extension. Stylo file format is based on the familiar directory. To access the content of a document, right-click on the _.stylo_ file and choose `Show Package Contents` option. The directory contains two subdirectories:

- sources
- styles

The _sources_ directory contains the text documents saved as a _.md_ file, and the styles directory contains all the styles directories. Each style directory contains all the stylesheets asociated with one style, saved as _.css_ files in CSS format.

---------------------------------------------------------------------------------------------------------
<!-- stylo/essentials.html"-->

# Essentials

Stylo is a Markdown text editor which allows to define the text appearance in CSS (Cascading Style Sheet). It supports edition of [Markdown](https://commonmark.org/) and plain text files in addition to the native _.stylo_ file format which is simply a directory presented as a single file to the user. 

Each appearance is refered as a _style_.  The _.stylo_ file format keeps style information along with the text document so that any change made to the styles are saved with the document. It is always possible to save a _.stylo_ file to Mardkown or plain text. Stylo also offers many export functions (HTML, PDF, Word) to favor interroperability with other applications. 

- [New document](new-document.html)
- [Save a document](save-document.html)
- [Save as](save-as.html)
- [Open a document](open-document.html")
- [Rename a document](rename-document.html)
- [Export a document](export-document.html)
- [Print a document](print-document.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/new-document.html"-->

# New document

To create a new document:

- From the menu, choose `File`→`New`    
- With the keyboard shortcut: `⌘N` 

---------------------------------------------------------------------------------------------------------
<!-- stylo/save-document.html"-->

# Save a document

Stylo will periodically save your documents as changes are made. But to save a document manually, do the following:

- From the menu, choose `File`→`Save`
- With the keyboard shortcut: `⌘S`

---------------------------------------------------------------------------------------------------------
<!-- stylo/open-document.html"-->

# Open a document

Stylo can be used to edit and save any plain text or Mardkown file in addition to the native Stylo format. To be able to modify the styles of plain text and Markdown document, it first needs to be saved as a Stylo document, see [Save as...](save-as.html) section, otherwise the styles will be in _read-only_ mode. 

To open a document:

- From the menu, choose `File`→`Open`    
- With the keyboard shortcut: `⌘O`

Once the open panel is visible, chose the file to open. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/save-as.html"-->

# Save as...

To save a Stylo document in Markdown or plain text format:

- While pressing the option (`⌥`) key, from the menu choose `File`→`Save as...`
- In the `Save as` panel chose the desired file format (`Stylo`, `Plain Text` or `Markdown`) and save the file at the desired location.

Note: When the edited document is in either plain text or Markdown format, to be able to edit the styles, it first needs to be saved in Stylo format. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/rename-document.html"-->

# Rename a document

To rename a document:

- From the menu, choose `File`→`Rename...`
- From the title bar, click the disclosure triangle and edit the _Name:_ field. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/export-document.html"-->

# Export a document

Stylo supports 3 export formats:

- HTML
- Word
- PDF

To export a Stylo document:

- From the menu, choose `File`→`Export` and choose the destination format.

Note: To save a Stylo document as `Plain text` or `Markdown` simply use the `Save as...` menu item, see [Save as...](save-as.html) section for more information.

---------------------------------------------------------------------------------------------------------
<!-- stylo/print-document.html"-->

# Print a document

To print a document:

- From the menu, choose `File`→`Print...`
- With the keyboard shortcut: `⌘P`

---------------------------------------------------------------------------------------------------------
<!-- stylo/user-interface.html -->

# User Interface

Stylo is a [distration free](distraction-free.html) text editor designed to leave maximum space to the text and to get out of the way when writing. 

The interface is divided into three main sections, the _Text_, the _Styles_ and the [_Sidebar_](sidebar.html) sections. The _Text_ section can be in [Mardown](markdown-editor.html) or [Preview](html-preview.html) mode. The  _Styles_ section contains the _Styles List_ and the _Style Editor_. The _Sidebar_ contains the _Tools_ and the _Style Picker_ tabs. 

- [Distraction free](distraction-free.html)
- [Markdown Editor/HTML Preview](markdown-editor.html) 
- [Sidebar](sidebar.html) 
- [Styles List](styles-list.html)
- [Style Editor](style-editor.html)
- [Text Statistics and Session Popup](text-statistics.html)


---------------------------------------------------------------------------------------------------------
<!-- stylo/distraction-free.html-->

# Distraction free writing

Stylo maximizes the space occupied by the text editor to create a distraction free writing environment. When possible, all accessory interface elements will disappear to leave the window to the text editor. To see a hidden accessory, simply move the mouse where it should be and it will reveal.

---------------------------------------------------------------------------------------------------------
<!-- stylo/markdown-editor.html -->

# Markdown Editor

The Markdown editor, along with the _HTML Preview_ is part of the _Text_ section. It allows to edit the Markdown text. It is located at the left of the Stylo document window. The resulting HTML can be previewed at any point using the _HTML Preview_. 

- [Reveal/hide the HTML Preview](reveal-hide-html-preview.html)
- [Mardkown Formatting](markdown-formatting.html)


---------------------------------------------------------------------------------------------------------
<!-- stylo/html-preview.html -->

# HTML Preview

The _HTML Preview_ allows to preview the document in HTML. 

- [Reveal/hide the HTML Preview](reveal-hide-html-preview.html)

Note: In preview mode, all the links are disabled.  

---------------------------------------------------------------------------------------------------------
<!-- stylo/reveal-hide-html-preview.html -->

# Reveal/hide the HTML Preview  

## Reveal the HTML preview 

To reveal the HTML preview:

- From the menu, choose: `View`→`Show Preview`
- From the _Tools_ tab of the sidebar, click on the `Preview` button (see note below).
- With keyboard shortcut: `⌘R`

## Hide the HTML preview 

To hide the HTML preview:

- From the menu, choose: `View`→`Hide Preview`
- From the _Tools_ tab of the sidebar, click on the `Preview` button (see note below).
- With keyboard shortcut: `⌘R`

Note: The `Preview` button is represented by an eye.

---------------------------------------------------------------------------------------------------------
<!-- stylo/text-statistics.html -->

# Text Statistics and Session Popup

The _Text statistics and Session Popup_ provides usefull metrics about the currently edited document, like total number of characters, words, etc... The session tools are meant to complement this information by providing the change in the text statistics from a point in time. A user may start a session and can later know the text statistics change since the moment the session was started. Note that this information is saved with the document, so the document can be closed and the session information wont be lost. 

The text statistics popup shows the total text statistics and the session statistics. The total text statistics are in gray, and the session statistics, along with the session related controls, are shown in the current system accent color.  The session tools can be completly disabled if desired (see [Enable/Disable Session Tools](enable-disable-session-tools.html) section for more information).

- [Enable/Disable Session Tools](enable-disable-session-tools.html) 
- [Total Text Statistics](total-text-statistics.html)
- [Session](session.html)

Note: By default the session tools are disabled. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/total-text-statistics.html -->

# Total Text Statistics 

Total text statistics contain the following indicators: 

- number of characters 
- number of words 
- number of sentences 
- number of paragraphs 
- number of pages 

and reading time estimations for a slow, average and fast reader.  

---------------------------------------------------------------------------------------------------------
<!-- stylo/session.html -->

# Session 

_Session Tools_ are used to record the changes in total text statistics over time. When started, a session records the staticstics changes from that moment (_Session start date_). _Session Tools_ are considered an advanced feature and are disabled by default. To enable the session tools see [Enable/Disable Session Tools](enable-disable-session-tools.html). 

Once the _Session Tools_ are enabled. It is possible to start a session, which will effectively start to record the statistics changes. To start a session see [Start/Restart a session](start-restart-a-session.html) section. When a session is started, it's possible to hide or show the session information using the `Hide` or `Show` buttons (see [Show/Hide a session](show-hide-a-session.html) section). It is also possible to restart the session counters (which effectively creates a new session), all the counters are then be reset to 0 and count from that new reference date. If text is added, the counters will increase, on the contrary, if text is removed, the counters will decrease, so, be aware, it is possible to get negative sessions values. To know when a session has been started, look at the _Session start date_ label at the bottom of the _Text statitics and session popup_.

- [Start/Restart a session](start-restart-a-session.html)
- [Show/Hide a session ](show-hide-a-session.html)
- [Enable/Disable Session Tools](enable-disable-session-tools.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/start-restart-a-session.html -->

# Start/Restart a session 
 
## Start a session 

To start a session: 

Press the `i` button on the sidebar _Tools_ tab (see [Show/Hide the _Tools_](show-hide-tools.html) section for more information), and press the `Start Session` button at the bottom of the _Text statistics and Session Popup_.   

## Restart a session 

To restart a session:

Press the `i` button on the sidebar _Tools_ tab (see [Show/Hide the _Tools_](show-hide-tools.html) section for more information), and press the `Restart` button at the bottom of the _Text statistics and Session Popup_.  

---------------------------------------------------------------------------------------------------------
<!-- stylo/show-hide-a-session.html -->

# Show/Hide a session 

## Show a session 

To show a session:

Press the `i` button on the sidebar _Tools_ tab (see [Show/Hide the _Tools_](show-hide-tools.html)  section for more information), and press the `Show Session` button at the bottom of the _Text statistics and Session Popup_.    

## Hide a session 

To hide a session:

Press the `i` button on the sidebar _Tools_ tab (see [Show/Hide the _Tools_](show-hide-tools.html)  section for more information), and press the `Hide` button at the bottom of the _Text statistics and Session Popup_.       

---------------------------------------------------------------------------------------------------------
<!-- stylo/enable-disable-session-tools.html -->

# Enable/Disable Session Tools

To start using the _Session Tools_, they first need to be enabled. Once enabled, they can be disabled again at any moment. Disabling the _Session Tools_ does not delete the existing session information, it only hides the related UI elements: if the session tools are re-enabled the session information will still be valid. 

## Enable Session Tools

To enable the _Session tools_:

- From the menu, choose `View`→`Text Statistics`→`Enable Session Tools`
- With the keyboard shortcuts: `⌘⇧T`


## Disable Session Tools

To disable the _Session tools_:

- From the menu, choose `View`→`Text Statistics`→`Disable Session Tools`
- With the keyboard shortcuts: `⌘⇧T`

---------------------------------------------------------------------------------------------------------
<!-- stylo/sidebar.html -->
# Sidebar

The _Sidebar_ provides access to Stylo's main features. It is located at the extreme right of the document window and it contains two tabs: [_Tools_](tools.html) and [_Style Picker_](style-picker.html). 

- [Reveal/Hide Sidebar](reveal-hide-sidebar.html)
- [Show/Hide the _Tools_](show-hide-tools.html) sidebar tab
- [Show/hide the _Style Picker_](show-hide-style-picker.html) sidebar tab

---------------------------------------------------------------------------------------------------------
<!-- stylo/reveal-hide-sidebar.html -->

# Reveal/Hide Sidebar

The sidebar is the vertical and narrow bar on the right of the document window and can be either invisible or visible. When the sidebar is visible it can show the [Tools](tools.html) tab or show the [Style Picker](show-hide-style-picker.html) tab. It's possible to switch between the two visible sidebar tabs using the _Sidebar Tab Switcher_ button at the top.
  
## Reveal the sidebar
 
To reveal the sidebar:

- Move the mouse cursor to the right side of a Stylo document window.
- Reveal the [_Style Picker_](show-hide-style-picker.html)
- Reveal the [_Tools_](show-hide-tools.html)

## Hide the sidebar

The sidebar will automatically hide when editing the main text if the style editing tools and/or style list are not open. To manually hide the sidebar, go the appropriate section depending on if the [_Tools_](show-hide-tools.html) or the [_Style Picker_](show-hide-style-picker.html) tab is visible. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/tools.html -->

# Tools 

The _Tools_ sidebar tab provides quick access to all Stylo tools. It contains, from top to bottom:

1. the _Sidebar Tab Switcher_ button to switch to the _Style Picker_

The button to switch to the _Style Picker_ tab represents a symbol containing two simplified symbols of style preview, which are a circle, on top of each other. Clicking on this button will switch the sidebar to the _Style Picker_ tab.

2. the preview button to show/hide HTML preview

The _Preview_ button is represented by the symbol of an eye. 

3. the _Styles List_ button to show/hide the _Styles List_

The button to show the _Styles List_ is represented by a symbol containing the tip of a brush, symbolizing the act of manipulating a style.
 
4. the _Text Statistics_ button to see the text statistics/writing session statistics

The button to show the _Text Statistics_ view is represented by the lowercase letter "i". See [Statistics and Session](text-statistics.html) section for a complete description.  

5. the Markdown formatting tools

The various buttons of this section provide access to quick Markdown formatting functions. See [Markdown Editor](markdown-editor.html) section for a complete description.


---------------------------------------------------------------------------------------------------------
<!-- stylo/show-hide-tools.html -->

# Show/Hide the _Tools_ sidebar tab (`⌘⌥⇧S`)

## Reveal the _Tools_ sidebar tab

To display the _Tools_ sidebar tab, do one of the following:

- From the menu, choose `View`→`Show Tools`
- Move the mouse cursor to the right side of the window, and if the _Style Picker_ tab is visible, click on the _Sidebar Tab Switcher_ button at the top of the _Style Picker_ tab
- With the keyboard shortcuts: `⌘⌥⇧S`

If the _Style Picker_ bar is visible, it's also possible to do the following:

- From _Style Picker_ bar, click on the _Sidebar Tab Switcher_ button at the top.

## Hide the _Tools_ sidebar tab 

To manually hide the sidebar, if the _Tools_ tab is visible

Do one of the following:

- From the menu, choose `View`→`Hide Tools`
- With the keyboard shortcuts: `⌘⌥⇧S`

---------------------------------------------------------------------------------------------------------
<!-- stylo/style-picker.html -->

# Style Picker sidebar tab

The _Style Picker_ sidebar tab provides quick access to all available styles for a document.

It contains, from top to bottom:

1. the _Sidebar Tab Switcher_ button to switch to the _Tools_ tab

The button shows a pen tip and a brush tip one above the other. When pressed it switches the sidebar to the _Tools_ tab.

2. a list of style previews buttons

A style preview is a smaller version of a style preview in the _Styles List_. It allows to select a style. 

3. a positioning indicator (if the window is too small to show all styles previews buttons)

The length of the indicator is proportional to the amount of styles that are visible over the total number of styles. If the positioning indicator is on the left, the styles list shows the style at the beginning of the styles. The indicator moves to the right to indicate that we are closer to the end of the list. This indicator can not be directly manipulated.

- [Show/hide the _Style Picker_](show-hide-style-picker.html)
- [Select a style](select-a-style.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/show-hide-style-picker.html -->

# Show/hide the _Style Picker_ sidebar tab (`⌘⌥S`)

## Show the _Style Picker_ sidebar tab

To show the _Style Picker_ sidebar tab,  do one of the following:
- From the menu, choose `View`→`Show Style Picker`
- With the keyboard shortcuts: `⌘⌥S`

If the sidebar is visible, it's also possible to do the following:
- From the _Tools_ sidebar tab,  click on the _Sidebar Tab Switcher_ button at the top.

## Hide the _Style Picker_ sidebar tab

To manually hide the sidebar, if the _Style Picker_ tab is visible, do one of the following:

- From the menu, choose `View`→`Hide Style Picker`
- With the keyboard shortcuts: `⌘⌥S`

---------------------------------------------------------------------------------------------------------
<!-- stylo/styles-list.html -->

# Styles List  

The _Styles List_ allows to add, delete and edit styles. It also allows to choose a style to apply to the current document.

- [Show/Hide __Styles List__](show-hide-styles-list.html)
- [Select a style](select-a-style.html)
- [Edit a style](edit-a-style.html)
- [Add a style](add-a-style.html)
- [Rename a style](rename-a-style.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/show-hide-styles-list.html -->

# Show/Hide _Styles List_ (`⇧⌘S`)

## Display the _Styles List_

Do one of the following:

- From the _Tools_ sidebar tab (see [Show/Hide the _Tools_ tab](show-hide-tools.html)), click on the _Styles_ button which is represented by the symbol of a brush tip.
- From the menu, choose `View`→`Styles`→`Show Styles`
- From the _Style editor_, click on the `Styles` button
- With the keyboard shortcut: `⇧⌘S`

## Hide the _Styles List_

Do one of the following:

- From the _Tools_ sidebar tab, click on the _Styles_ button
- From the menu, choose `View`→`Styles`→`Hide styles`
- With the keyboard shortcut: `⇧⌘S`

---------------------------------------------------------------------------------------------------------
<!-- stylo/select-a-style.html-->

# Select a style

When selecting a style, it becomes the new Markdown text style. 

To select a style, do one of the following:

- From the _Style Picker_ sidebar tab (see [Show/hide the _Style Picker_ sidebar tab](show-hide-style-picker.html) section), click one the corresponding style preview icon.
- From the _Styles List_ (see [Show/Hide _Styles List_](show-hide-styles-list.html)), click on the corresponding style in the styles list.


---------------------------------------------------------------------------------------------------------
<!-- stylo/edit-a-style.html -->


# Editing a style (`⇧⌘E`)

A style can only be edited if it is selected, this allows any change to the style to be [applied](apply-pending-style-changes.html) directly to the Mardkown text. 

To edit a style, do one of the following:

- Click on the `Edit` button of the selected style
- From the menu, choose: `View`→`Styles`→`Edit Style`
- With the keyboard shortcut: `⇧⌘E`

Once in editing mode the CSS editor is presented that allows to change the current Markdown style. To add a style to an element in the Markdown source, the HTML type of the element to style must be used. The [Markdown Reference](../markdown/contents.html) contains, for each Markdown element, the corresponding HTML element type that must be use when styling. Another way to know the corresponding HTML element type of a Markdown element, is to right click on it in the Markdown source editor, and choose _Copy selector_. See [_Copy selector_](copy-selector.html) section for more information.

To style the following Markdown: 

  markdown 

# A title level one 

Some paragraph that we want to style. 

 

we could use this simple CSS: 

  css
body {
	background-color: gray;
}

h1 {
	color: blue;
}

p {
	color: red;
}

 

In the preceding CSS extract, `body` represents the whole document, we use it to assign a background color to the Mardkown source editor. To style `# A title level one`, we use the corresponding HTML element type for a title level one: `h1` to style it with a blue color, and finally we use the `p` element to style the paragraph `Some paragraph that we want to style.` with a red color. 

The corresponding HTML element of a Markdown element is most of the time really straightforward i.e. a Markdown title level 1 is an `h1` HTML element; a Markdown paragraph is a `p` HTML element, etc... When in doubt, look in the [Markdown Reference](../markdown/contents.html) for the element specific section which will give the corresponding HTML element for it, or use the [_Copy selector_](copy-selector.html) selector option of the element contextual menu which can be obtained by right clicking on it in the Markdown source.

---------------------------------------------------------------------------------------------------------
<!-- stylo/copy-selector.html -->

# _Copy selector_ 

The _Copy selector_ functionality allows for fast access to the CSS selector that can be used to select a Markdown element in the Markdown source text. When used on element, it will _copy_ the selector to the pastboard which can then be  pasted in the CSS source using the menu or the keyboard shortcut.  

To copy the selector of a Markdown element: 

- From the contextual menu, right click the source text over the Markdown element and choose `Copy selector`
- From the menu, position the editor caret in the Markdown element or select it and choose: `Edit` -> `Copy selector` 

To use a copied Markdown element selector:

Put the cursor where the selector should be copied and: 

- From the menu, choose: `Edit` -> `Paste` 
- With the keyboard shorcut:  `⌘V`


---------------------------------------------------------------------------------------------------------
<!-- stylo/add-a-style.html -->

# Add a style (`⇧⌘A`)

New styles can created from the [_Styles List_](show-hide-styles-list.html). 

To add a style, do one of the following:

- Click on the `Add` button in the title panel of the _Styles List_
- From the menu, choose: `View`→`Styles`→`Add Style`
- With the keyboard shortcut: `⇧⌘A`

Note: A new style initial value is always the same as the selected style. So, the style addition can also be used to duplicate style.

---------------------------------------------------------------------------------------------------------
<!-- stylo/rename-a-style.html -->

# Rename a style

To change the name of a style, do one of the following:

- From the _Style editor_ view, click on the style name, and edit the name
- From the _Styles List_, click on the name of the selected style, and edit the name

---------------------------------------------------------------------------------------------------------
<!-- stylo/style-editor.html -->

# Style Editor

The _Style editor_ includes a title section, the CSS editor itself and the issues list.

The title section includes:
1. the style name
2. the _Issues indicator_ showing the number of issues in the source file
3. the back button to return to the _Styles List_
4. the _Apply_ button that apply the current style to the document (including unapplied changes)
5. the _Issues_ button which gives access to the issues section.

The issues section includes the list of issues (warnings, errors) in the current CSS source.

- [Show/hide the _Issues_ panel](show-hide-issues-panel.html)
- [Reveal single/all issues ](reveal-single-all-issues.html)
- [Apply pending style changes](apply-pending-style-changes.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/show-hide-issues-panel.html -->

# Show/hide the _Issues_ panel (`⇧⌘I`)

The _Issues_ panel shows the list of issues associated with the edited CSS source. It can not be shown if there are no issue in the CSS style source. When the _Issues_ panel is shown, all the CSS source issues are highlighted. When it is hidden, the CSS style source returns to the editing style again.

## Show the _Issues_ panel

To show the _Issues_ panel:

- Click on the `Issues` button at the bottom right of the title panel.


## Hide the _Issues_ panel

To hide the _Issues_ panel:

- Click on the `Issues` button at the bottom right of the title panel.


---------------------------------------------------------------------------------------------------------
<!-- stylo/reveal-single-all-issues.html -->

# Reveal single/all issues 

## Highlight a single issue

When the _Issues_ panel appears all the issues in the edited CSS source text are highlighted. When highligting an issue, the CSS source text may optionnally be scrolled to make it visible. 

To highlight a single issue:

- Click on the issue to highlight in the _Issues_ panel.

## Reveal all issues

If an issue is selected in the _Issues_ panel, it is highlighted in the CSS source text. When there is no issues selected in the _Issues_ panel, all issues are highlighted in the source file. So, to reveal all issues, we only need to unselect the currently selected issue. 

To highlight all issues:

- Scroll the issues list up or down to unselect all issues

---------------------------------------------------------------------------------------------------------
<!-- stylo/apply-pending-style-changes.html -->

# Apply pending style changes (`⇧⌘C`)

Changes made when editing a style are not applied automatically to the Markdown text for performance reasons. It must therefore be explicitly requested to apply style pending changes. The `Apply` button (located at the top right of the _Style editor_ title panel) makes it possible to apply style pending changes, if any. The `Apply` button will only be enabled if there are differences between the currently applied style and the edited style.

To apply pending changes::

- From the CSS editor title panel of a style, click on the `Apply` button


---------------------------------------------------------------------------------------------------------
<!-- stylo/markdown-formatting.html -->

# Markdown formatting 

- [Header level 1](header-level-1.html)
- [Header level 2](header-level-2.html)
- [Header level 3](header-level-3.html)
- [Header level 4](header-level-4.html)
- [Header level 5](header-level-5.html)
- [Header level 6](header-level-6.html)
- [Blockquote](blockquote.html)
- [Unordered list](unordered-list.html)
- [Ordered list](ordered-list.html)
- [Bold](bold.html)
- [Italic](italic.html)
- [Strikethrough](strikethrough.html)
- [Link](link.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-1.html -->

# Header level 1

To create a header level 1:

- Textually (option 1), enter `#`, one or more spaces, and the title itself
- Textually (option 2), enter the title itself then on the following line one or more `-`
- From the menu, choose: `Format`→`Heading 1`
- From the _Tools_ sidebar tab, click on the `h1` button
- With the keyboard shortcut, enter `⌘1`

See [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-2.html -->

# Header level 2

To create a header level 2:

- Textually (option 1), enter `##`, one or more spaces, and the title itself
- Textually (option 2), enter the title itself and then on the following line one or more `=`
- From the menu, choose: `Format`→`Heading 2`
- From the _Tools_ sidebar tab, click on the `h2` button
- With the keyboard shortcut, enter `⌘2`

See  [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-3.html -->

# Header level 3

To create a header  level 3:

- Textually, enter `###`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 3`
- From the _Tools_ sidebar tab, click on the `h3` button
- With the keyboard shortcut, enter `⌘3`

See  [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-4.html -->

# Header level 4

To create a header level 4:

- Textually, enter `####`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 4`
- From the _Tools_ sidebar tab, click on the `h4` button
- With the keyboard shortcut, enter `⌘4`

See  [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-5.html -->

# Header level 5

To create a header level 5:

- Textually, enter `#####`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 5`
- With the keyboard shortcut, enter `⌘5`

See  [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/header-level-6.html -->

# Header level 6

To create a header level 6:

- Textually, enter `######`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 6`
- With the keyboard shortcut, enter `⌘6`

See  [Markdown](../markdown/md-headers.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/blockquote.html -->

# Blockquote

To create a blockquote:

- Textually, enter `>` at the beginning of a line
- From the menu, choose: `Format`→`Blockquote`
- From the _Tools_ sidebar tab, select the text to be transformed into a citation block and click on the `>` button.
- With the keyboard shortcut, enter `⌘>`

See  [Markdown](../markdown/md-blockquote.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/unordered-list.html -->

# Unordered list

To create an unordered list:

- Textually, enter `-` at the beginning of each line of the list
- From the menu, choose: `Format`→`Unordered List`
- From the _Tools_ sidebar tab, select the text to be transformed into a unordered list and click on the `-` button.
- With the keyboard shortcut, enter `⌘L`

See  [Markdown](../markdown/md-lists.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/ordered-list.html -->

# Ordered list

To create an ordered list:

- Textually, enter the line numbers at the beginning of each line of the list, followed with a dot, for example: `1.`
- From the menu, select: `Format`→`Ordered List`
- From the _Tools_ sidebar tab, select the text to be transformed into an ordered list and click on the `1.` button
- With the keyboard shortcut, enter `⇧⌘L`

See  [Markdown](../markdown/md-lists.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/bold.html -->

# Bold 

To convert to bold:

- Textually, surround the text to bold characters `**`
- From the menu, choose: `Format`→`Bold`
- From the _Tools_ sidebar tab, select the text to convert to bold and click on the `B` button
- With the keyboard shortcut, enter `⌘B`

See  [Markdown](../markdown/md-emphasis.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/italic.html -->

# Italic

To convert to italic:

- Textually, surround the text to be converted to italic with star (`*`) characters
- From the menu, choose: `Format`→`Italic`
- From the _Tools_ sidebar tab, select the text to be converted to italic and click on the `I` button.
- With the keyboard shortcut, enter `⌘I`

See  [Markdown](../markdown/md-emphasis.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/strikethrough.html -->

# Strikethrough

To add a strikethrough:

- Textually, surround the text to strikethrough with "-"
- From the menu, choose: `Format`→`Strikethrough`
- From the _Tools_ sidebar tab, select the text to strikethrough and click on the ~~`S`~~ button
- With the keyboard shortcut, enter `⌘-`

See  [Markdown](../markdown/md-strikethrough.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- stylo/link.html -->

# Link 

A link takes the general form `[<link name>](<destination of the link>)`. For example: 

Markdown:

  markdown 
[Stylo](http://www.textually.net/stylo)
 

HTML:

  html 
<p><a href="http://www.textually.net/stylo">Stylo</a></p>
 

would create a link named "Stylo" pointing to the URL: "http://www.textually.net/stylo".

See  [Markdown](../markdown/md-link.html) reference for more information. 

---------------------------------------------------------------------------------------------------------
<!-- markdown/contents.html -->

# Markdown Reference 

Markdown is the lightweight markup language used in Stylo. It's a simple language that emphasizes readability and ease of use. Markdown exists in several versions but a version seems to make more and more consensus: CommonMark and this is the version implemented by Stylo. For any questions regarding the Markdown syntax, the official site of [CommonMark](https://commonmark.org/) offers a complete [documentation](https://spec.commonmark.org) and an [online test tool](https://spec.commonmark.org/dingus/). 

Since CommonMark is still in an early stage, it currently lacks some essential elements. Stylo adds two: strikethrough and table. The GitHub flavoured versions of these elements have been implemented. See the GitHub Markdown documentation for a complete reference: [GFM tables](https://github.github.com/gfm/#tables-extension-) and 
[GFM strikethrough](https://github.github.com/gfm/#strikethrough-extension-).

Markdown defines a non-intrusive syntax that allows to define HTML elements. As a last resort, since valid HTML code is interpreted as such by Markdown, it is always possible to resort to HTML when an element is not supported. It should be noted that there is no _invalid_ Markdown. A text document is a valid Markdown document. If a tag is not recognized it will simply be interpreted as text.

In Stylo, an element can also define one or more sub-regions that can be targeted by a pseudo-element (see [Pseudo-element selector](../css/pseudo-element-selector.html) section) selector section. For each element, the associated pseudo-elements will be listed in the section pertaining to the element in the subsection _Pseudo-elements_.

CSS is used to style and specify the appearance of the Markdown text. CSS needs a way to identify elements to style. Since some Markdown elements have no correspondent HTML elements, we defined [Markdown specific elements](markdown-specific-elements.html) for them, to allow targeting them in CSS. 

Here is a simplified inventory of the main syntax rules in CommonMark and Stylo. Please refer to the [CommonMark Specification](https://spec.commonmark.org) and [GitHub Flavoured Markdown](https://help.github.com/articles/github-flavored-markdown) for more information.


- [Headers](md-headers.html)
- [Horizontal Bar](md-horizontal-bar.html)
- [Emphasis](md-emphasis.html)
- [Strikethrough](md-strikethrough.html)
- [Blockquote](md-blockquote.html)
- [List](md-lists.html)
- [Code](md-code.html)
- [Table](md-table.html)
- [Reference](md-reference.html)
- [Link](md-link.html)
- [Image](md-image.html)

---------------------------------------------------------------------------------------------------------
<!-- markdown/markdown-specific-elements.html -->

# Mardkown specific elements 


In Stylo, CSS is used to stylize the Markdown text. Some Markdown elements have no correspondent HTML elements. In these cases, we defined new elements specific to Markdown. This allows to use these elements in the CSS style.

- `html-block`: An `html-block` defines any HTML block in a Markdown source. 
 
  markdown 

# title level 1 
 
<p>A simple paragraph.</p>

 

In the last Markdown extract, the region delimited by `<p>` and `</p>` is an `html-block`. We could give it a red color using the following CSS: 

  css
html-block {
    color: red;
}
 

- `reference`: A `reference` is used to create a label that represents an URI. This label can then be used in the links and images in a Markdown document to refer to this URI, see the [Reference](md-reference.html) section for a complete description. When converting a Markdown document to HTML, the links and images using reference are populated with the real URI defined in the references and the references are removed since they are no longer needed. For styling purpose, in Stylo, these references are kept. When exporting a document to HTML or previewing it, all `reference` elements are removed as they don't serve any purpose. 

We could, for example, style a reference with the blue color using the following CSS: 

  css
reference {
    color: blue; 
}
 

Technical note: the namespace for these elements is defined as: `https://commonmark.org`.

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-headers.html -->

# Headers   

## Syntax

### Header level 1 

A level 1 title can be written in two ways, with a number sign, as in the following example:

Markdown: 

  markdown 
# title 1
 

or, with one or more `=` characters under the header text, like the following: 

Markdown: 

  markdown 
title 1
=======
 

Both are equivalent to the following HTML: 

HTML:

  html
<h1>titre 1</h1>
 

### Header level 2 

Markdown: 

  markdown
## titre 2 
 

HTML:

  html
<h2>titre 2</h2>
 

As for the level 1 title, an _underlined_ syntax exists for the level 2 title. It uses the `-` character instead: 

Markdown: 

  markdown
Titre 2
-------
 

HTML:

  html
<h2>titre 2</h2>
 

### Other levels 

The other levels are written with the number of dashes corresponding to the header level wanted:   

Markdown: 

  markdown
### title 3
#### title 4
##### title 5
###### title 6
 

HTML:

  html
<h3>titre 3</h3>
<h4>titre 4</h4>
<h5>titre 5</h5>
<h6>titre 6</h6>
 

## Pseudo-elements  

All titles offer the following pseudo-element:

- `tag`: allows to stylize the region used to define the title, in the case of syntax with `#`, only sharps will be stylized, and in the case of the _underlined_ syntax, the underline bar will be stylized. For example, the following CSS will color the "tag" part of the "h1" elements with the red color:

  css
h1::tag {
    color: red;
}
 

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-horizontal-bar.html -->

# Horizontal Bar  

The horizontal bar is used to separate content or highlight content, such as a title. 

## Syntax

Markdown: 

  markdown 
---
 

or 

  markdown  
***
 

HTML:

  html 
<hr>
 

## Pseudo-elements  

The horizontal bar offers no pseudo-elements. 

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-emphasis.html -->

# Emphasis  

There are two types of emphasis that correspond to the two HTML elements _strong_ and _em_. The `strong` element delimits important text and is usually styled with bold text. The `em` element delimits emphased text and is usually styled with italicized text.

## Syntax

To emphasize a section of text, simply enclose it with an "*" (star) or an "_" (underscore):

Markdown:

  markdown
*Emphasized text 1*
_Emphasized text 2_
 

HTML:

  html 
<em>Emphasized text 1</em>
<em>Emphasized text 2</em>
 

To define an important section of text, simply enclose it with two "*" (star) or two "_" (underscore):

Markdown: 

  markdown 
**important text**  
__important text__
 

HTML:

  html
<strong>important text</strong>
<strong>important text</strong>
             

## Pseudo-elements  

The pseudo-elements offered by these two elements are:

- `tag`: covers the stars or underscores used to define the emphasis or important text on both sides of the text.

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-strikethrough.html -->

# Strikethrough  

The _strikethrough_ implementation in Stylo is based on the GitHub Flavored Markdown(GFM), see [strikethrough extension](https://github.github.com/gfm/#strikethrough-extension-) for more information. 

## Syntax

To create a strikethrough simply surround the text to be strikedthrough by two '~' on each side. 

Markdown: 

  markdown 
~~strikethrough text~~  
 

HTML:

  html
<p><s>strikethrough text</s></p>
      

## Pseudo-elements  

There is one pseudo-element offered by this element:

- `tag`: covers the `~~` signs used to define the strikedthrough text.


---------------------------------------------------------------------------------------------------------
<!-- markdown/md-blockquote.html -->

# Blockquote  

A quoted block, equivalent to the "blockquote" HTML element, is used to identify a quoted section of text from another source.

## Syntax

Markdown: 

  markdown 
> citation bloc    
citation  bloc
 

HTML:

  html
<blockquote>
    <p>
        citation bloc<br>
        citation bloc
    </p>
</blockquote>
 

The quoted blocks can nest into each other:

Markdown:

  markdown 
> citation bloc    
> > nested citation block
> > > second nested citation bloc
 

HTML:

  html
<blockquote>
    <p>
        citation bloc
    </p>
    <blockquote>
        <p>
            nested citation block
        </p>
        <blockquote>
            <p>
                second nested citation bloc
            </p>
        </blockquote>
    </blockquote>
</blockquote>
 

## Pseudo-elements  

There is one pseudo-element offered by this element:

- `tag`: covers the `>` (larger) signs used to define the quote blocks.


---------------------------------------------------------------------------------------------------------
<!-- markdown/md-lists.html -->

# Lists  

A list in Markdown, equivalent to the element _ul_ or _ol_, for _unordered list_ and _ordered list_, is a sequence of elements that belongs to the same logical set. As in its HTML version, a list can be ordered or unordered.

## Syntax

### Unordered 

The `*`, `-` or the `+` can be used to create unordered lists. At the start of each line of a list, simply use the same marker for all list items inside one list. 

Markdown: 

  markdown 
* list element
* list element
* list element
 
or 

  markdown 
- list element
- list element
- list element
 
or 

  markdown 
+ list element
+ list element
+ list element
 

HTML:

  html
<ul>
    <li>list element</li>
    <li>list element</li>
    <li>list element</li>
</ul>
 

Using a different marker force to start a new list. 

Markdown:

  markdown 
- item one
- item two
+ other list item one
+ other list item  two
 

HTML:

  html 
<ul>
    <li>item one</li>
    <li>item two</li>
</ul>
<ul>
    <li>other list item one</li>
    <li>other list item two</li>
</ul>
 


### Ordered   

The `<number>.` or the `<number>)` syntax can be used to create ordered lists.

Markdown:

  markdown 
1. first item  
2. second item 
3. third item 
 
or 

  markdown 
1) first item  
2) second item 
3) third item 
 

HTML:

  html 
<ol>
    <li>first item</li>
    <li>second item</li>
    <li>third item</li>
</ol>
 

We can also start the numbering at a specific value, as in the following example:

Markdown:

  markdown 
57. item 57
1. item 58
 

HTML:

  html 
<ol start="57">
    <li>item 57</li>
    <li>item 58</li>
</ol>
 


### Nested 

To nest a list inside another list simply indent all items of the nested list by a minimum of two spaces from the start of the line of the nesting list. 

Markdown:

  markdown 
- item one
- item two
  + nested list using two spaces after the start of nesting list  
  + nested sublist item 
    * another nested list started two spaces after the nesting list (four from the start)
    * another nested list
 

HTML:

  html
<ul>
    <li>item one</li>
    <li>item two
        <ul>
            <li>nested list using two spaces after the start of nesting list </li>
            <li>nested sublist item
                <ul>
                    <li>another nested list, started two spaces after the nesting list, four spaces after the list nesting the nesting list</li>
                    <li>another nested list</li>
                </ul>
            </li>
        </ul>
    </li>
</ul>
 

## Pseudo-elements  

In the case of lists, the list items are the elements that contain pseudo-element, and there is one:

- `tag`: covers the list item mark

In the previous example we could put "57." and "1." in red using the following CSS:

CSS: 

  css
li::tag {
    color: blue;
}
 

or more specifically the elements of any ordered lists:

CSS:

  css
ol li::tag {
    color: blue;
}
 


---------------------------------------------------------------------------------------------------------
<!-- markdown/md-code.html -->

# Code 

A code element is any element that contains source code, generally a programming language or a markup language. There are three types of Markdown code elements: _inline_, _fenced_ and _indented_.

Elements of this type are used in Markdown to indicate that a text section is not part of the same syntactic space as the current document.

In the following example:

Markdown: 

  markdown
# title
 

the Markdown title "# title" is not a title according to the current syntax space: it is in the block of code that contains it, but in the current document, it is source code inside a code block.

## Syntax

### Inline 

An inline code element is most often defined within a line and is delimited by two "`" grave accents, one at the beginning, and the other at the end of the text section that we want to define as a _code_ element.

Markdown:

  markdown
A line with `code`.
 

HTML:

  html
<p>
    A line with <code> code </ code>.
</p>
 

### Fenced 

The fenced code syntax is used to define a code element on several lines. It makes it possible to define the beginning of the code and the end on different lines. In this case, it will be necessary to use three grave accents side by side at the beginning of a line, optionally followed by a parameter, generally the name of the language used, and ended with three grave accents. All text between these two tags will be considered code. Here is an example:

Markdown: 

<pre><code>
  swift
func estEven(number: Int) -> Bool {
    return number%2 == 0 
}
 
</code></pre>

HTML:

  html
<pre><code>func estEven(number: Int) -> Bool {
    return number%2 == 0 
}
</code></pre>
 

### Indented 

A third alternative to defining a code section is the indented syntax. Just place 4 or more spaces at the beginning of each line of code, as below:

Markdown / HTML:

  html 
<pre><code>
    // Comment
    line 1 of the code
    line 2 of the code
    line 3 of the code
</pre></code>
 

HTML:

  html
<pre><code>
    // Comment
    line 1 of the code
    line 2 of the code
    line 3 of the code
</pre></code>
 

## Pseudo-elements  

The inline code and the fenced code supports the following pseudo-elements:

- `tag`: defines the opening and closing tags text of the two code versions syntax:  ` `  ` in the online code and <code> </code> in the case of the closed code.

And the fenced code also supports the pseudo-element:

- `params`: which contains the text portion of the parameters of the fenced code opening tag.

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-table.html -->

# Table  

A table is used to tabulate information. It corresponds to the _table_ HTML element.

## Syntax

Each row of a table starts at the beginning of a line and is optionnally indicated by a vertical bar: "| ". Each column is separated from the previous ones by a vertical bar, and the last column of a row optionnally ends with a vertical bar.

The first row is the title row. It allows to give a title to each of the columns of the table, the title of each column can be empty.

The second row is the separators row. It separates the titles row from the values rows. Each column of this row, like that of the titles, optionnally begins with a vertical bar, and the last column is optionnally terminated by a vertical bar. Each column must contain at least a hyphen "-". This dash may optionally be preceded or followed by a ":" colon to specify a left alignment of the corresponding column, or a right alignment, respectively. The absence of two-point signifies an alignment in the center.

Then come the values rows which follow the same pattern as the title row but contains the values ​​of each column.

Some examples:

A table with two centred columns and three rows of values:

Markdown: 

  markdown
| Column 1 | Column 2 |
| - | - |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
 

HTML

  html
<table>
    <thead>
        <tr>
            <th>Column 1</th>
            <th>Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Text column 1</td>
            <td>Text column 2</td>
        </tr>
        <tr>
            <td>Text column 1</td>
            <td>Text colonne 2</td>
        </tr>
        <tr>
            <td>Text column 1</td>
            <td>Text column 2</td>
        </tr>
    </tbody>
</table>
 

A table with right-aligned columns:

Markdown: 

  markdown
| Column 1 | Column 2 |
| ------:| -----------:|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
 

HTML:

  html
<table>
    <thead>
        <tr>
            <th style="text-align:right">Column 1</th>
            <th style="text-align:right">Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
    </tbody>
</table>
 

A table with left-aligned columns:

Markdown: 

  markdown 
| Column 1 | Column 2 |
| :------| :-----------|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
 

HTML:

  html 
<table>
    <thead>
        <tr>
            <th style="text-align:left">Column 1</th>
            <th style="text-align:left">Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
    </tbody>
</table>
 

## Pseudo-elements  

The `table` element supports the `tag` pseudo-element which contains all the vertical separators as well as the line separating the title row from the values rows. It can be used as follows:

  css
table::tag {
    color: orange;
}
 

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-reference.html -->

# Reference  

A reference takes the form: `[\<reference label\>]: \<destination uri\> "\<title\>"`, where the \<reference label\> is the name of the reference used in links and images and the \<destination uri\> is the target URI for this reference. It is possible to style a Markdown reference using the `reference` element. 

## Syntax

An example of a reference to [Textually](http://www.textually.net):

Markdown: 

  markdown
[textually]: www.textually.net
 

and how it can be used in a link: 

  markdown
This is a link to [textually][textually].
 

HTML: 

There is no corresponding HTML element for a reference. 

A reference can also have a title: 

Markdown: 

  markdown
[textually]: www.textually.net "Textually website"
 

Note: A link or an image using a non existing reference label, will be treated as text by Stylo. 


## Pseudo-elements  

The reference element supports four pseudo-elements: 

- `tag`: the region with the start and end square braquet( "[", "]") and the colon
- `label`: the part between the two square braquets
- `destination`: the destination URI 
- `title`: the reference title

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-link.html -->

# Link  

A link is an element that allows to insert a Unique Resource Identifier (URI) to a resource. This element corresponds to the `a` (anchor) element of HTML.

## Syntax

There are two main syntaxes for links, the difference being how to specify the URI: with or without reference. A reference (see the [Reference](md-reference.html) section for more information) is an identifier given to a URI and can be used instead of a URI in a link (or image). 

### Without reference 

Markdown: 

  markdown 
[Stylo](www.textually.net/stylo)
 

HTML: 

  html 
<p><a href="www.textually.net/stylo">Stylo</a></p>
 
or with a title: 

Markdown:

  markdown 
[link with title](http://www.textually.net/stylo "Stylo!")
 

HTML: 

  html 
<p><a href="http://www.textually.net/stylo" title="Stylo!">link with title</a></p>
 

### With reference 

Markdown:

  markdown
[link] [idStylo]

[idStylo]: http://www.textually.net/stylo
 

Note: If a reference is not found in the current document the links and images that use it will be considered text.

## Pseudo-elements  

- `tag`: the region that includes the start and end square braquet( "[", "]") and the two parenthesis ("(", ")")
- `text`: the part between the two square braquets
- `destination`: the destination URI if the link does not point to a reference 
- `label`: the destination reference if the link points to a reference 
- `title`: the title of the link 

---------------------------------------------------------------------------------------------------------
<!-- markdown/md-image.html -->

# Image 

An image element, corresponding to the `img` HTML element, is an inline link to an image. Unlike the link element, it is replaced by the destination image at loading time: it doesn't need to be clicked to be accessed. 

## Syntax

The syntax difference with the link is the presence of an exclamation mark `!` before the image link definition. 

Markdown:

  markdown 
![Logo](http://www.textually.net/images/stylo/logo.png)
 

HTML:

  html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="Logo" /></p>
 

With a title: 

Markdown:

  markdown 
![Logo](http://www.textually.net/images/stylo/logo.png "Logo")
 

HTML:

  html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="Logo" title="Logo" /></p>
 

Like the links, the images also have a syntax in reference format:

Markdown:

  markdown
![alternative text][idImage]

[idImage]: http://www.textually.net/images/stylo/logo.png "Logo"
 

HTML:

  html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="alternative text" title="Logo" /></p>
 

An image can reference a local file or a remote file on Internet. If the file is local to the computer used to edit the Mardown file, the URL pattern should begin with _file://_ followed by the file absolute path. A URL to an image located at `/Users/john/image.png` would look like this: 

Mardkown:

  markdown
![ImageName][file:///Users/john/image.png]
 

HTML:

  html
<p><img src="file:///Users/john/image.png" alt="ImageName" /></p>
 


## Pseudo-elements  

- `tag`: the region that includes the start and end square braquet( "[", "]") and the two parenthesis ("(", ")")
- `text`: the part between the two square braquets
- `destination`: the destination URI if the image link does not point to a reference 
- `label`: the destination reference if the image link points to a reference 
- `title`: the title of the image link 

---------------------------------------------------------------------------------------------------------
<!-- html/contents.html -->

# HTML  

HTML, for _Hypertext Markup Language_, is the main language of the Web. It is mainly used to define the content of web pages. 

- [Document](document.html)
- [Element](element.html)
- [Definitions](definitions.html)
- [Attributes](attributes.html)
- [`id`](id.html)
- [`class`](class.html)

---------------------------------------------------------------------------------------------------------
<!-- html/document.html -->

# Document

An HTML document uses the HTML markup language and is defined by a set of elements. Each element is defined by an opening tag in the form _<element_name>_ and closing tag that have the general form _</element_name>_.  An HTML document must begin with the document type tag: `doctype` with the `html` value, and must be followed by the opening tag `<html>` and end with the closing tag `</html>`, these two tags create an  _html_ element.
 
Here is an example of an HTML document:

HTML:

 html
<!doctype html>
<html>
    <body>
    </body>
</html>
 

The elements of an HTML document form a tree structure. In the HTML above, the `html` is the parent of the `body` element. See the [Definitions](definitions.html) section for more information.

---------------------------------------------------------------------------------------------------------
<!-- html/element.html -->

# Element 

Elements are the unit of content in an HTML document. They define the content structure of the HTML document. An element is defined by an opening tag and a closing tag.

## Opening tag

**The opening tag** is the name of the element between smaller and bigger than signs. Here is for example the opening tag of the element named _html_:

     <html>

## Closing tag

**The closing tag** consists of the name of the element preceded by the slash, all between a smaller and bigger than signs. For example, here is how we could define the `html` element:

HTML:

  html
<html>
</html>
 

## Content 

**The content** of an element is everything between the opening tag and the closing tag of that element. For example, here is how to define a title element level 1 (_h1_) with the content _A title_:

HTML:

  html
    <h1>A title</h1>
 

Here is an example of an HTML document with content:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
        <p>Content of the first paragraph </p>
    </body>
</html>
 

The previous document contains five elements: `html`, `body`, `h1`, `h2` and `p`.

1. `html`: the root element of the html document
2. `body`: the _body_ element contains all the contents of the document
3. `h1`: an element that defines a level 1 title
4. `h2`: an element that defines a level 2 title
5. `p`: an element that defines a paragraph

The doctype is not an HTML element in itself. It is simply used to specify that the content is of HTML type. 

---------------------------------------------------------------------------------------------------------
<!-- html/definitions.html -->

# Definitions 

The **parent element** of a current element is the element on top of that element, that is, the closest element that contains it. In the previous document, `html` is the parent of `body`, and `body` is the parent of `h1`, `h2`, and `p`. Each element can have a maximum of 1 parent element. The root element, which is the `html` element, has no parent .

An **ascendant element** of a current element is any element that contains the current element either directly (as the parent) or indirectly, which is the ascendant of the parent of an element. In the previous document, the `html` element is the ascendant of all the elements of the document except itself, the `body` element is the ascendant (and the parent) of the elements: `h1`, `h2` and `p`.

A **child element** of a current element is defined as any element that is directly below this current element. An element's child parent is the element for which this element is the child. The relationship "parent-child" is symmetrical. In the previous document, the `body` element is the child of the `html` element, and the `h1` element is the child of the `body` element.

A **descendant element** of a current element is either the child of that element, or a descendant of a child of that element. In the previous document, the element `p` is the descendant of the elements: `body` and `html`.

The **next sibling** of a current element is the element that shares the same parent as the current element and is directly after the current element. In the previous document, the element `p` is the next sibling of the element `h2` and the element `h2` is in turn the next sibling of the element `h1`.

A **following sibling** of a current element is any element that shares the same parent as the current element and is the next sibling the current element or the following sibling of this next sibling. In the previous document, the element `p` is the next sibling of the elements `h2` and `h1`.

Now that we have covered a few definitions, we can dwell on the element itself.

An element can have an `id`, classes (`class`) and/or attributes. CommonMark,  in itself, does not allow for the moment to define these properties on an element, but it is still possible to define them in HTML, so we will have a quick overview of the subject. 

---------------------------------------------------------------------------------------------------------
<!-- html/attributes.html -->

# Attributes

An element can have multiple attributes. An attribute has a name and a value. The name of an attribute must always be separated from the element name by at least one space. The value of an attribute is defined by  the name of the attribute followed by the `=` sign and then the value itself enclosed in quotation marks (`"`). The value contains a list of one or more value (word) separated by one or more space. In the following example we define the attribute `valid` with a value `true` for the `h1` element:

HTML:

  html
<h1 valid="true">title 1</h1>
 

Here is another example with a list of words: 

HTML:

  html
<h1 authors="john marc">title 1</h1>
 

Two attributes names are reserved and have special meaning in HTML, `id` and `class`.

---------------------------------------------------------------------------------------------------------
<!-- html/id.html -->

# `id`

An `id` is a unique identifier, in the context of a document, given to an element. To give an `id` to an element, it suffices to define the `id` attribute with a value on this element. For example, in the following document, the `h1` element has the id `my-first-title`:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 id="my-first-title">Title 1</h1>
        <h2>Title 2</h2>
    </body>
</html>
 

---------------------------------------------------------------------------------------------------------
<!-- html/class.html -->

# `class`

A `class` groups a set of elements under a name. It will later be possible to refer to these elements using the name of the class. To assign a class to an element, we just need to add a `class` attribute and add a class name to the attribute value. Here is an example that assigns the `title` class to the `h1` and the `h2` elements:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 class="title" id="my-first-title">Title 1</h1>
        <h2 class="title">Title 2</h2>
    </body>
</html>
 

Note that it is possible to assign multiple classes to an element using the same `class` attribute by adding the names of all classes as the `class` attribute value, separated by a space. For example, in the following document we assign the classes `title` and `other-class` to the `h2` element.

HTML:

  html
<!doctype html>
<html>
    <body>
        <h2 class="title other-class">Title 2</h2>
    </body>
</html>
 

---------------------------------------------------------------------------------------------------------
<!-- css/contents.html -->

# CSS 

CSS, for _Cascading Stylesheet_, is a language used to define style, generally of an HTML document. CSS is huge and supports an enormous number of functions and properties. Stylo CSS version is a "standard conforming" lightweight version of CSS that retains the original language elements that are useful in the context of text editing in Markdown format and adds some pseudo-elements necessary for styling Markdown source.  

Stylo CSS aims at being 100% standard compliant, so anyone interested in having more information on how to use it can find usefull information on the Web. In order to shorten the presentation, we will concentrate on information most relevant to its use inside Stylo.

Subjects:

- [Style](style.html)
- [Selectors](selectors.html)
- [Combinator](combinators.html)
- [Stylesheet](stylesheet.hmlt)
- [Cascading](cascading.html)
- [Priority Rules](priority-rules.html)
- [Properties](properties.html)
- [CSS Property types](css-property-types.html)

---------------------------------------------------------------------------------------------------------
<!-- css/style.html -->

# Style 

A style is a set of properties with values. A style is always associated with a selector that allows to specify how to select the elements to which the style will apply. For example, in: 

CSS:

 
body {
    color: red;
}
 

`body` is the selector. It specifies how to select the elements to which the properties defined in the style can be applied to. This style can be applied  to elements of type `body`. The style defines a single property: `color`, and sets its value to `red`. The selector and the style are together referred as _style declaration_ in CSS. 

Note: In Stylo, only a few properties are supported. For a complete list of supported properties and their use, see the [Properties](properties.html) section.

---------------------------------------------------------------------------------------------------------
<!-- css/selectors.html -->

# Selectors

A selector makes it possible to specify how to select the elements for which the style definition, which follows, applies to. When an element is selected by a selector, we say that the element _matches_ the selector. 

There are several different selectors:

- [type selector](type-selector.html)
- [id selector](id-selector.html)
- [class selector](class-selector.html)
- [Universal selector](universal-selector.html)
- [attribute selector](attribute-selector.html)
- [pseudo-element selector](pseudo-element-selector.html) 
- [pseudo-class selector](pseudo-class-selector.html) 

---------------------------------------------------------------------------------------------------------
<!-- css/type-selector.html -->

# Type selector

The type selector is the most basic kind of selector. It selects elements according to their name (`localname`). For example, in the following HTML file:
 
HTML:

  html
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
    </body>
</html>
 

it is possible to assign the red color to the element `h2` using the following style declaration:

CSS:

  css
h2 {
    color: red; 
}
 

The `h2` selector effectively selects all elements of type `h2`.

---------------------------------------------------------------------------------------------------------
<!-- css/id-selector.html -->

# Id selector 

The id selector allows to select elements using the `id` attribute. It takes the general form of the hash sign followed by the `id` attribute's value: _#\<element id\>_. In the following HTML document:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 id="my-first-title">Title 1</h1>
        <h2>Title 2</h2>
    </body>
</html>
 

it is possible to assign the red color to the element `h1` using the following style declaration:

CSS:

  css
#my-first-title {
    color: red;
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/class-selector.html -->

# Class selector 

The class selector allows to select elements using the `class` attribute. It takes the general form of the dot ('.') followed by the element class name: ". \<element class\>". In the following HTML document:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 id="my-first-title" class="title">Title 1</h1>
        <h2 class="other-class title">Title 2</h2>
    </body>
</html>
 

it is possible to assign the red color to the elements `h1` and `h2` using the following style declaration (since they share the `class`'s value `title`):

CSS:

  css
.title {
    color: red;
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/universal-selector.html -->

# Universal selector 

The universal selector matches all elements. It takes the form of a star: `*`. 

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
        <p>
            A paragraph with <strong>bold text</strong>.
        </p>
    </body>
</html>
 

We could apply the red color to all elements in this document with the following style declaration:

CSS:

  css
* {
    color: red;
}
 

We could have achieved the same effect by using the body element type selector since all the visible elements are its descendants.

CSS:

  css
body {
    color: red;
}
 

The difference between the two will not be important in most cases, but for performance reasons it is better to avoid the use of the universal selector.


---------------------------------------------------------------------------------------------------------
<!-- css/attribute-selector.html -->

# Attribute selector 

The attribute selector allows to select elements based on the presence/absence or value of any attribute. It takes the general form of the name of the attribute optionally followed by a [_text selection expression_](attribute-value.html) and the partial or complete value of the attribute, all placed between a left square braquet '[' and a right square braquet ']'.

- [Attributes existence](attribute-existence.html)
- [Attribute value](attribute-value.html)

Note: Since attributes are not used in Stylo, it is safe to skip all the section related to attributes based selectors. 

---------------------------------------------------------------------------------------------------------
<!-- css/attribute-existence.html -->

# Attribute existence 

The attribute selector allows to select elements based on the existence of an attribute. To do that, we need to use the name of the attribute in square brackets. In the case of the following HTML document:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 author="john">Title 1</h1>
        <h2 class="other-class title">Title 2</h2>
    </body>
</html>
 

it is possible to assign the red color to the `h1` element using the style declaration:

CSS:

 css
[author] {
    color: red;
}
 

Here, we use the attribute selector to select all the elements that have the "author" attribute set, regardless of the it's value.

---------------------------------------------------------------------------------------------------------
<!-- css/attribute-value.html -->

# Attribute value 

The attribute value selector selects elements based on the value of an attribute. To use it, we need to place the name of the attribute in square brackets, followed by the _text selection expression_, followed by the match text.  

There are six differents _text selection expressions_:

- [Exact match](exact-match.html)
- [Contains word match](contains-word-match.html)
- [Starts with word match](starts-with-word-match.html)
- [First word begins with substring](first-word-match.html)
- [Last word ends with substring](last-word-match.html)
- [A word contains substring](word-contains-match.html)

---------------------------------------------------------------------------------------------------------
<!-- css/exact-match.html -->

# Exact match

_[attribute_name="match_text"]_ matches the elements whose value of attribute "attribute_name" *is equal* to "match_text". Here we match the *complete* value, meaning the complete list of "words" part of the attribute value. In the following HTML document:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1 authors="john" class="title">Title 1</h1>
        <h2 class="title other-classe" authors="john marc">Title 2</h2>
    </body>
</html>
 

we can select the `h1` element using the following selector:

CSS:

  css
[authors="john"] {
    ...
}
 

Note that the `h2` element is not selected because it also contains the substring `marc` in the `authors` attribute's value. To match the `h2` using the exact match text selection expression we would need to use the following CSS:

CSS:

  css
[authors="john marc"] {
    ...
}
 

Note that we used the same order of words. For the exact match the order of the elements is important e.g. `marc john` would not select the `h2` element. 

---------------------------------------------------------------------------------------------------------
<!-- css/contains-word-match.html -->

# Contains word match

_[attribute_name~="match_text"]_ matches the elements whose attribute "attribute_name"'s value *contains* the word "match_text". An attribute contains a list of words; with this text selection expression we are looking for a specific word inside this list. This value needs to be the exact match of one these words for example:

HTML:

  html
<h1 authors="john marc">Title 1</h1>
 

With the attribute selector below, we could select the `h1` element:

CSS:

  css
[authors~="marc"] {
    ...
}
 

The following CSS would *not* work since it does not contains a complete value's substring: 

CSS:

  css
[authors~="ma"] {
    ...
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/starts-with-word-match.html -->

# Starts with word match

_[attribute_name|="value"]_ matches the elements whose attribute "attribute_name" *starts with* "match_text". The value must be an entire word, alone or followed by a hyphen "-". Here again we are matching a value's complete substring. For example, in the following HTML source:

HTML:

  html
<h1 authors="john marc">Title 1</h1>
<h2 authors="anne-marie marc">Title 2</h1>
 

With the attribute selector below, we could select the `h1` element:

CSS:

  css
[authors|="john"] {
    ...
}
 

With the attribute selector below, we could select the `h2` element:

CSS:

  css
[authors|="anne"] {
    ...
}
 

or

CSS:

  css
[authors|="anne-marie"] {
    ...
}
 

Note that the following CSS would *not* work: 

  css
[authors|="ann"] {
    ...
}
 

because the _starts with word_  text selection expression addresses a complete word inside the attribute's value. 

---------------------------------------------------------------------------------------------------------
<!-- css/first-word-match.html -->

# First word begins with substring

_[attribute_name^="value"]_ matches the elements whose value first word of the attribute "attribute_name" *begins with* "match_text" substring. Unlike the previous selector, the value does not have to be a whole word. In the following HTML source:

HTML:

 html
<h1 authors="john marc">Title 1</h1>
 

with the attribute selector below, we could select the `h1` element with the following CSS:

CSS:

  css
[authors^="jo"] {
    ...
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/last-word-match.html -->

# Last word ends with substring

_[attribute_name $="match_text"]_ matches the elements whose value last word of the attribute "attribute_name" *ends with* "match_text". Here, the value does not have to be an entire word. In the following HTML source:

HTML:

  html
<h1 authors="john marc">Title 1</h1>
 

we could select the `h1` element, with the following attribute selector:

CSS:

  css
[authors$="arc"] {
    ...
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/word-contains-match.html -->
# A word contains substring

_[attribute_name*="match_text"]_ matches the elements whose attribute "attribute_name"'s value *contains* "match_text". Here again, the value does not have to be an entire word. In the following HTML source:

HTML:

  html
<h1 authors="john marc">Title 1</h1>
 

we could select the `h1` element with the attribute selector below:

CSS:

  css
[authors$="ma"] {
    ...
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/pseudo-element-selector.html -->

# Pseudo-element selector

A pseudo-element is an element that is not part of the document's elements tree but represents some logical part of an element. Stylo adds a number of these pseudo-elements so that it becomes possible to style the Markdown source more accurately. For example, in Markdown we define a header level 2 as follows:

Markdown: 

  markdown
## header level 2
 

The text "##" is the tag, or the label of the element. The pseudo-element selector `::tag`  allows to select only the tag of the element `h2` in the previous Markdown source. In Stylo, several pseudo-elements exist, for a complete list see the [Pseudo-elements](pseudo-elements.html) section.

The pseudo-element selector is introduced by two "colon" ("::") after the selector of an element and is followed by the name of the pseudo-element, for example:

CSS:

  css
h1::tag {
    ...
}
 

matches the `tag` pseudo-element of a level 1 title element.

Note: Stylo does not support the historical single colon syntax for pseudo-elements. 

## Several pseudo-elements of the same type

If a pseudo-element is defined several times for the same element, the one with the highest specificity will be the one that will be applied, and in case of equality, the last one encountered in the stylesheet will have higher priority.

In the case where several pseudo-elements of different types apply to the same text region, the one with the highest specificity, or in case of equality, the one that comes after, will apply.

---------------------------------------------------------------------------------------------------------
<!-- css/pseudo-class-selector.html -->

# Pseudo-class selector 

For the moment, no pseudo class selector is supported in Stylo.


---------------------------------------------------------------------------------------------------------
<!-- css/combinators.html -->

# Combinators 

Selector combinator allows to combine multiple selectors into one by defining the relationship between each of them. For example, we may want to select all `h1`'s descendant elements that are of type `strong`. To do this we would need to use the descendant combinator as in the following example: 

  css
h1 strong {
	...
}
 

In the previous example, we used the descendant combinator, represented by a space between the two type selectors. The complete selector is evaluated from left to right as follows: first it selects all elements in the document, and then selects the elements of type `h1`,  and then apply the descendant selector by retaining all descandants of all `h1` elements previously selected. The selector then continues by evaluating the `strong` type selector to keep only the elements of this type.  

At the end of the selection process we effectively end up with all `strong` elements that are descendants of `h1` elements. 

There exists four kinds of selector combinators:

- [Descandant combinator](descendant-combinator.html)
- [Child combinator](child-combinator.html)
- [Following sibling combinator](following-sibling-combinator.html)
- [Next sibling combinator](next-sibling-combinator.html)

Note: It may be helpful to re-read the [Definitions](../html/definitions.html) section of "Element" section for a reminder of the main concepts used here.


---------------------------------------------------------------------------------------------------------
<!-- css/descendant-combinator.html -->

# Descendant combinator

__descendant selector__ is used to select the descendants of an element. A descendant selector combinator is represented by a space (' ') between the selectors. For example, to select all headers level 2 descendant of the body element, the following CSS could be used:

CSS:

  css
body h2 {
    ...
}
 

In this example, the two `h2` elements of the HTML document are selected.

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
        <h2>title 2</h2>
        <p> 
            <h2>title 2 in p</h2>
        </p>
    </body>
</html>
 


---------------------------------------------------------------------------------------------------------
<!-- css/child-combinator.html -->

# Child combinator 

__child combinator__ is used to select the children of an element. A child selector combinator is represented by a larger than (`>`) sign between the selectors. For example, to select all `h2` that are children of the `body` element, the following CSS could be used:
   
CSS:

  css
body > h2 {
    ...
}
 

In this example, only the `h2` element under the `body` element is selected, the one with the text: `title 2`. The one under the `p` element is not selected.

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
        <h2>title 2</h2>
        <p> 
            <h2>title 2 in p</h2>
        </p>
    </body>
</html>
 

---------------------------------------------------------------------------------------------------------
<!-- css/following-sibling-combinator.html -->

# Following sibling combinator

__following sibling selector__ matches the elements that are following sibling of an element. It is represented by the sign "~" between the selectors. In the HTML of the previous document, we can use a _following sibling_ selector to select the `h2` and `p` elements as follows:

CSS:

  css
h1 ~ * {
    ...
}
 

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
        <h2>title 2</h2>
        <p> 
            <h2>title 2 in p</h2>
        </p>
    </body>
</html>
 

---------------------------------------------------------------------------------------------------------
<!-- css/next-sibling-combinator.html -->

# Next sibling combinator 

__next sibling selector__ selects the next sibling element (the one right after an element). A _next sibling_ selectors combinator is represented by the `+` sign between the selectors. In the HTML of the previous document, we could use a next sibling selector to select the `h2` element  under the first `h1` as follows:

CSS:

  css
h1 + h2 {
    ...
}
 

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
        <h2>title 2</h2>
        <p> 
            <h2>title 2 in p</h2>
        </p>
    </body>
</html>
 

---------------------------------------------------------------------------------------------------------
<!-- css/stylesheet.html -->

# Stylesheet

A stylesheet is a set of styles declarations. It can be of three different origins:

1. User Agent: This will be the browser in most cases, but in Stylo case, it is Stylo itself.
2. Author: stylesheets edited by the author of web site.
3. User: The style sheet that a user, usually a browser user, can edit.

Of these three stylesheets types, only the second, _Author_, is editable in Stylo. The _User_ stylesheet does not exist in Stylo since access is given to all the power of CSS directly through the _Author_ stylesheet.

---------------------------------------------------------------------------------------------------------
<!-- css/cascading.html -->

# Cascading 

The purpose of the cascade process is to assign a value to all the properties supported by each element, and this, for all document's elements.

An element can get a particular value for a property in three ways:

1. One or more styles declarations, whose selector matches this element, define a value for this property.
2. An element _ancestor_ defines a value for this property.
3. None of the above, the property then gets its default value.

If all properties of element have their value defined after the first step (1), the process stops here. Otherwise, for the values ​​that support the inheritance, we will get the values ​​to assign to the properties without values ​​in the ancestors of this element(2). If an ancestor sets a value for the property, the value will be assigned. For the remaining properties, the default values (3) ​​defined by the properties themselves will be used.

This is the cascade process!

---------------------------------------------------------------------------------------------------------
<!-- css/priority-rules.html -->

# Priority rules 

When more than one style applies to an element and these styles define values ​​for the same property, a selection process must be applied to determine which style's property to choose. Here is, in ascending order, the priority assigned to each property:

1. user agent style
2. user styles
3. author's styles
4. important author's styles (marked with "!important")
5. important user's styles

At the end of this prioritization process, it is possible for two properties to have the same priority. In this case, a pointing system is used which will depend on the selector. 

Note: for a full/alternative explanation of CSS priority rules and cascading process: [OpenWeb Cascade CSS](https://openweb.eu.org/articles/cascade_css).

---------------------------------------------------------------------------------------------------------
<!-- css/properties.html -->

# Properties 

Currently, Stylo supports the following properties:

- [color](css-color-property.html)
- [background-color](css-background-color-property.html)
- [font-size](css-font-size-property.html)
- [font-family](css-font-family-property.html)
- [font-weight](css-font-weight-property.html)
- [font-style](css-font-style-property.html)
- [text-decoration-style](css-text-decoration-style-property.html)
- [text-decoration-line](css-text-decoration-line-property.html)
- [text-decoration-color](css-text-decoration-color-property.html)

A property declaration takes the following general form:

CSS:

  css
<property name>: <property value>;
 

To define a property, we must enter the property name, followed by a colon (':'), followed by the property value and, finally, end the declaration with a semicolon. 

It is possible to add the qualifier "!important" after the value of a property in order to increase its priority compared to the other values ​​assigned to this property (see [_Priority rules_](priority-rules.html)). Here is an example that uses "!important":

CSS:

  css
body {
    color: red! important;
}
 

---------------------------------------------------------------------------------------------------------
<!-- css/css-color-property.html -->

# color 

The `color` property makes it possible to assign a color to an element, in Stylo it is the color of the text.

Formal definition: <code>color: [color](css-property-values-color) | [initial](css-property-values-initial.html) | [inherit](css-property-values-inherit.html);</code>

---------------------------------------------------------------------------------------------------------
<!-- css/css-background-color-property.html -->

# background-color 

The `background-color` property allows to assign a color to the background of an element. 

Formal definition: <code>background-color: [color](css-property-values-color.html) | [initial](css-property-values-initial.html) | [inherit](css-property-values-inherit.html);</code>

_Note_: The values ​​that this property can take are the same as for the _color_ property.

_Note_: For performance reasons, Stylo, does not support an alpha value other than 1 for the background-color property of the `body` element of a Markdown document.

---------------------------------------------------------------------------------------------------------
<!-- css/css-font-size-property.html -->

# font-size

The `font-size` property allows to assign a size to a font. 

Formal definition: <code>font-size: <a href="#css-properties-font-size-absolute">medium</a> 
| <a href="#css-properties-font-size-absolute">xx-small</a> 
| <a href="#css-properties-font-size-absolute">x-small</a> 
| <a href="#css-properties-font-size-absolute">small</a> 
| <a href="#css-properties-font-size-absolute">large</a> 
| <a href="#css-properties-font-size-absolute">x-large</a> 
| <a href="#css-properties-font-size-absolute">xx-large</a> 
| <a href="#css-properties-font-size-relative">smaller</a> 
| <a href="#css-properties-font-size-relative">larger</a> 
| <a href="css-property-values-length.html">length</a> 
| <a href="#css-properties-font-size-percentage">%</a> 
| <a href="css-property-values-initial.html">initial</a> 
| <a href="css-property-values-inherit.html">inherit</a>;</code>

## Keywords

<h3 id="css-properties-font-size-absolute">Absolute</h3>

All these sizes are based on the `medium` size which is set to 16px in Stylo.

| Keyword | Value |
| ----- | ------ |
| xx-small | 9.6px |
| x-small | 12px |
| medium | 16 px |
| wide | 19.2px |
| x-large | 24px |
| xx-large | 32px |

<h3 id="css-properties-font-size-relative">Relative</h3>

The size is based on the size of the parent element.

| Keyword | Value |
| ----- | ------ |
| smaller | 2/3 of the inherited value |
| larger | 3/2 of the inherited value |


<h2 id="css-properties-font-size-percentage">Percentage</h2>


A percentage value, calculated from the value for `font-size` property from the parent element, for example:

CSS:

  css
body {
    font-size: 16px;
}
h1 {
    font-size: 80%;
}
 


In the following document:

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>Title 1</h1>
    </body>
</html>
 

The font size of the `h1` element  would be 12.8px (0.8 x 16px = 12.8px).

_Note_: It is suggested to use the relative sizes in that they adapt to all devices and the design will be more "portable". 

---------------------------------------------------------------------------------------------------------
<!-- css/css-font-family-property.html -->

# font-family

The `font-family` property is used to specify the font of an element.

Formal definition: <code>font-family: family-name | <a href="#font-family-generic">generic-family</a> | [initial](css-property-values-initial.html) | [inherit](css-property-values-inherit.html);</code>

To set the value of this property, we should use a comma-separated, prioritized list of specific or generic font family names, or one of the "initial" or "inherit" values, used alone.

For example, to define a _Arial_ or _sans-serif_ font for the element `h1` we could use the following CSS:

CSS:

  css
h1 {
    font-family: Arial, sans-serif;
}
 

<h2 id="font-family-generic">Generic font names</h2>

Here is the list of generic fonts:

| Generic font name |
| ------ |
|serif|
|sans-serif|
|cursive|
|fantasy|   
|monospace|


---------------------------------------------------------------------------------------------------------
<!-- css/css-font-weight-property.html -->

# font-weight 

The `font-weight` property  allows to assign a thickness to a font. All values ​​are converted into one of the following numbers: 100, 200, 300, 400, 500, 600, 700, 800, 900, ranging from the thinnest (100) to the thickest (900). The value 400 is equivalent to normal and the value 700 is equivalent to bold.

Formal definition: <code>
font-weight: normal | bold | bolder | lighter | number
| [initial](css-property-values-initial.html) 
| [inherit](css-property-values-inherit.html);</code>

The two keywords `lighter` and `bolder` define the value of the thickness of the current font relative to the inherited thickness. The final value is computed using this table: 

|Inherited value| bolder | lighter |
|--|---|---|
| 100 | 400| 100 |
| 200 | 400 | 100 |
| 300 | 400 | 100 |
| 400 | 700 | 100 |
| 500 | 700 | 100 |
| 600 | 900 | 400 |
| 700 | 900 | 400 |
| 800 | 900 | 700 |
| 900 | 900 | 700 |

In the following example, we give `h1` elements `font-weight` property the `bold` value:

CSS:

  css 
h1 {
    font-weight: bold; 
}
   

---------------------------------------------------------------------------------------------------------
<!-- css/css-font-style-property.html -->

# font-style 

The `font-style` property allows to define the style of the font, it admits three different values ​​(besides `initial` and `inherit`): `normal`, `italic` or `oblique`. It should be noted that in Stylo, the value ​​`italic` is ealuated the same way as `oblique`.

Formal definition: <code>
font-style: normal | italic | oblique
| [initial](css-property-values-initial.html) 
| [inherit](css-property-values-inherit.html);</code>

In the following example, give the value `italic` to `h1` elements:

CSS:

  css 
h1 {
    font-style: italic; 
}
   

---------------------------------------------------------------------------------------------------------
<!-- css/css-text-decoration-line-property.html -->

# text-decoration-line 

This property allows to specify the decoration type to use. There are four types of decorations: `none` the default, that is to say there is no decoration; `underline`, we underline the elements; `overline`, a line is placed above the elements; `line-through`, a line runs through the elements, this is equivalent to a strikethrough.

Formal definition: <code>text-decoration-line: none | underline | overline | line-through | [initial](css-property-values-initial.html) 
| [inherit](css-property-values-inherit.html);</code>

It is possible to use several decorations at a time, for example, the following CSS decorates `h1` elements with a line above and a line below.:

CSS:

  css
h1 {
    text-decoration-line: overline, underline; 
}   
 

---------------------------------------------------------------------------------------------------------
<!-- css/css-text-decoration-style-property.html -->

# text-decoration-style

This property is used in conjunction with `text-decoration-line` property  and allows to assign a style to the text decoration lines.

Formal definition: <code>text-decoration-style: solid | double | dotted | dashed | wavy | [initial](css-property-values-initial.html) 
| [inherit](css-property-values-inherit.html);</code>

The default value is `solid` which gives a "full" style to the line; the `double` style doubles the line; the `dotted` style gives a dotted line; the `dashed` style gives a dashed line; finally, the `wavy` style gives a wave shape to the line.

---------------------------------------------------------------------------------------------------------
<!-- css/css-text-decoration-color-property.html -->

# text-decoration-color

This property is also used in conjunction with the property `text-decoration-line` and allows to assign a color to the line decorations.

Formal definition: <code>text-decoration-color: [color](css-property-values-color.html) | [initial](css-property-values-initial.html) 
| [inherit](css-property-values-inherit.html);</code>

For example, to decorate the `h1` elements with a red double line, we could use the following CSS:

CSS:

  css 
h1 {
    text-decoration-line: underline; 
    text-decoration-style: double;
    text-decoration-color: red; 
}
  

---------------------------------------------------------------------------------------------------------
<!-- css/css-property-types.html -->

# CSS values types

List of value types: 

- [initial](css-property-values-initial.html)
- [inherit](css-property-values-inherit.html)
- [length](css-property-values-length.html)
- [color](css-property-values-color.html)

---------------------------------------------------------------------------------------------------------
<!-- css/css-property-values-initial.html -->

# initial

The initial value of a CSS property is its default value. Here are all the default values for the Stylo supported CSS properties:


|Property| Default value|
|---|---|
|color|black|
|background-color|white|
|font-size|16px|
|font-family|"Avenir Next"|
|font-weight|normal|
|font-style|normal|
|text-decoration-style|solid|
|text-decoration-line|none|
|text-decoration-color|black|

---------------------------------------------------------------------------------------------------------
<!-- css/css-property-values-inherit.html -->

# inherit

The `inherit` keyword cause a property to use the value of its parent for the same property. It is mainly used to override other CSS rules in case we would want the default behaviour.     

---------------------------------------------------------------------------------------------------------
<!-- css/css-property-values-length.html -->

# length 

The type _length_ in CSS defines a length.

The syntax of _length_ is a decimal number followed by a unit.

## Units relative to the font size 

### em 

This unit applies the decimal number as a multiplier to the value we would normally have after cascading for this property.

For example:

CSS:

  css 
body {
    font-size: 10px;
}
h1 {
    font-size: 1.2em; 
}
 

In the following document, for `h1` element font-size value: 

HTML:

  html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
    </body>
</html>
 


We get: 1.2 x 10 = 12px

### ex 

The value is calculated from the current font "[x-height](https://en.wikipedia.org/wiki/X-height)" value. As in the case of "em" we prefix the unit with the multiplier to apply to it.

### ch 

Value relative to the width of the "0" in the current font.

### rem 

Value relative to the font size of the root element.

## Units relative to viewport size 

The "viewport" in Stylo is the screen. And all the values ​​related to the viewport are calculated according to the size of the screen.

### vw

Value equivalent to 1% of the viewport's width.

### vh

Value equivalent to 1% of the viewport's height.

### vmin

Value equivalent to 1% of the viewport 's smallest dimension.

### vmax

Value equivalent to 1% of the viewport's largest dimension.


## Absolute units 
 
Absolute units are based on units of known length.

| Unit | Description |
| ----- | -------- |
| Cm | centimeters |
| Mm | millimeters |
| In | inches (1in = 96px = 2.54cm) |
|px | pixels (1px = 1 / 96th of 1in)|
| Pt | points (1pt = 1/72 of 1in) |
| Pc | picas (1pc = 12 pt) | 


---------------------------------------------------------------------------------------------------------
<!-- css/css-property-values-color.html -->

# color

In Stylo, the value of a color is ultimately represented by four components between 0 and 1: red, green, blue, and alpha. A color component with value 0 is absent; with value 1, the component is present at 100%. The intermediate values ​​determine the different variants in the presence of the component. In the case of the alpha component, the value 0 means that the color is completely transparent and the value 1, that it is completely opaque.

Pure red, is represented by: red: 1, green: 0, blue: 0, alpha: 0; white 1,1,1,1 and black: 0,0,0,1. All shades of gray use the three components in equal amounts, for example, a dark gray could be obtained with the components: 0.2,0,2,0,2,1.

## rgb

The `rgb(<red>,<green>,<blue>)` function allows to define a color by passing the value of the three color components with a number between 0 and 255 for each component. This number is ultimately divided by 255 to get a value between 0 and 1 as mentioned previously. The alpha value is set to 1 by default.

For example, to assign the red color to the `color` property of `h1` elements, we could use:

CSS:

  css
h1 {
    color: rgb(255, 0,0);
}
 

Here, the `rgb` function was used with the red component at its maximum value of 255 (255/255 = 1) and the green and blue components are not present.

## rgba

The `rgba (<red>, <green>, <blue>, <alpha>)` function allows, like the `rgb` function, to define a color according to the three fundamental components with a value between 0 and 255, but also allows to specify the alpha component value.

For example, to assign the red color with an alpha of 0.5 to the `h1` elements `color` property, we could use:

CSS:

  css
h1 {
    color: rgba(255, 0.0, 0.5);
}
 

Note: The `background-color` property of the body element does not support alpha component value different than 1 for perfomance reasons.  

## hexadecimal

An hexadecimal value is another way to represent the red, green, and blue color components. An hexadecimal value is introduced by the character "#" and followed by the hexadecimal characters of the value. Valid hexadecimal characters are: 0,1,2,3,4,5,6,7,8,9, a, b, c, d, e, f, case insensitive. For example, "#F00" represents the red color with an alpha to 255. 

| hexadecimal character | decimal value |
| ------ | ------ |
| 0 | 0 |
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 4 |
| 5 | 5 |
| 6 | 6 |
| 7 | 7 |
| 8 | 8 |
| 9 | 9 |
| A | 10 |
| B | 11 |
| C | 12 |
| D | 13 |
| E | 14 |
| F | 15 |


As a decimal value, for which each position represents a power of 10, in hexadecimal, each position represents a power of 16.

For example, the number 28 in decimal is:

2x10<sup>1</sup> + 8 x10<sup>0</sup> = 20 + 8 = 28

Reminder: \<any number\><sup>0</sup> = 1

The same number in hexadecimal is written as "1c" ("c" is 12):

1x16<sup>1</sup> + 12x16<sup>0</sup> = 16 + 12 = 28


For a full explanation of the hexadecimal characters, see the [Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) article on Wikipedia.
 
It is possible to express a color in hexadecimal with values ​​of several lengths, each length having its own interpretation.

1. three hexadecimal characters 

With a value of length 3, from left to right, the first character represents the red component; the second component, the green component; the third, the blue component. To get the value of each component, Stylo doubles the character. Thus, for the value `#abc`, the value used will be: `#aabbcc`, the `aa` characters  for the red component, the `bb` characters for the green component and finally, the `cc` characters for the blue component. The range of values ​​thus goes from 0 (0x16<sup>1</sup> + 0x16<sup>0</sup> = 0 + 0 = 0) to 255 (15x16<sup>1</sup> + 15x16<sup>0</sup> = 240 + 15 = 255). The value of the alpha (as in the rgb function mentioned above) will always default to 255.


For example, we could set the color red, for a level 1 title:

CSS:

  css
h1 {
    color: #F00;
}
 


Which gives with the values doubled: `#FF0000`, and therefore, a value of 255 for the red component, 0 for the green component, 0 for the blue component, and 255 for the alpha, by default.

2. four hexadecimal characters 


The interpretation remains the same with four characters, all the values ​​are doubled and the components remain the same as for the first six characters except the added last two characters that are used to specify the color's alpha component. 

To define the red color with an alpha of 0.53, we will have:

CSS:

  css
h1 {
    color: #F008;
}
 

3. six hexadecimal characters 


We find ourselves in the same case with three characters, except that the values ​​will not be doubled.

To obtain the pure blue color, we will use:

CSS:

  css
h1 {
    color: #0000FF;
}
 

4. height hexadecimal characters

This time, we find ourselves in the same case as with four characters, except that the values ​​are not doubled: we can completely define a color with an 8 characters hexadecimal code, including its alpha component. For a green with an alpha component at 0.47:

CSS:

  css
h1 {
    color: #00FF0078;
}
 

Calculation for the alpha value gives: 7x16<sup>1</sup> + 8x16<sup>0</sup> = 112 + 8 = 120 -> 120/255 = 0.47.


## keyword

Stylo supports all keywords supported by CSS. 

To assign the red color to the `color` property of elements of type `h1` we could use the following CSS:

CSS:

  css
h1 {
    color: red;
}
 

Keywords allow quick access to the main colors in CSS. See the full list of Stylo [color keywords](color-keywords.html). 


---------------------------------------------------------------------------------------------------------
<!-- css/pseudo-elements.html -->

# Pseudo-elements

## Markdown Pseudo-elements

|Markdown Pseudo-elements|
|-----|
| tag |
| params |
| label |
| text |
| title |
| destination |
| label |

## Other Pseudo-elements

|HTML Pseudo-elements|
|-----|
|first-letter|

---------------------------------------------------------------------------------------------------------
<!-- stylo/bundled-fonts.html -->

# Bundled Fonts 

|Bundled Fonts|
|-----|
|Arvo|
|Asap|
|Bitstream Vera Sans Mono|
|Cabin|
|Cabin Condensed|
|Cairo|
|Cormorant|
|Cormorant Garamond|
|Cousine|
|Crimson Text|
|Dosis|
| EB Garamond|
|Fira Mono|
|Hack|
|IBM Plex Mono|
|IBM Plex Sans|
|IBM Plex Sans Condensed|
|IBM Plex Serif|
|Inconsolata|
|Josefin Sans|
|Jura|
|Kanit|
|Lato|
|Liberation Mono|
|Libre Franklin|
|Lora|
|Martel|
|Merriweather|
|Merriweather Sans|
|Montserrat|
|Muli|
|Noto Mono|
|Noto Sans|
|Noto Serif|
|Nunito|
|Office Code Pro|
|Open Sans|
|Open Sans Condensed|
|Overpass|
|Overpass Mono|
|Playfair Display|
|Prompt|
|PT Mono|
|PT Sans|
|PT Sans Caption|
|PT Sans Narrow|
|PT Serif|
|PT Serif Caption|
|Quicksand|
|Raleway|
|Roboto|
|Roboto Condensed|
|Roboto Mono|
|Roboto Slab|
|Rokkitt|
|Source Code Pro
|Space Mono|
|Titillium Web|
|Zilla Slab|

---------------------------------------------------------------------------------------------------------
<!-- css/color-keywords.html -->

# Color keywords
  
| keyword | rgb value |
|:--------|:-----------|
|black| rgb(0,0,0)|
|blanchedalmond | rgb(255,235,205)|
|transparent| rgb(0,0,0,0)|
|aliceblue| rgb(240,248,255)|
|antiquewhite| rgb(250,235,215)|
|aqua| rgb(0,255,255)|
|aquamarine| rgb(127,255,212)|
|azure| rgb(240,255,255)|
|beige| rgb(245,245,220)|
|bisque| rgb(255,228,196)|
|blue| rgb(0,0,255)|
|blueviolet| rgb(138,43,226)|
|brown| rgb(165,42,42)|
|burlywood| rgb(222,184,135)|
|cadetblue| rgb(95,158,160)|
|chartreuse| rgb(127,255,0)|
|chocolate| rgb(210,105,30)|
|coral| rgb(255,127,80)|
|cornflowerblue| rgb(100,149,237)|
|cornsilk| rgb(255,248,220)|
|crimson| rgb(220,20,60)|
|cyan| rgb(0,255,255)|
|darkblue| rgb(0,0,139)|
|darkcyan| rgb(0,139,139)|
|darkgoldenrod| rgb(184,134,11)|
|darkgray| rgb(169,169,169)|
|darkgreen| rgb(0,100,0)|
|darkgrey| rgb(169,169,169)|
|darkkhaki| rgb(189,183,107)|
|darkmagenta| rgb(139,0,139)| 
|darkolivegreen| rgb(85,107,47)|
|darkorange| rgb(255,140,0)|
|darkorchid| rgb(153,50,204)|
|darkred| rgb(139,0,0)|
|darksalmon| rgb(233,150,122)|
|darkseagreen| rgb(143,188,143)|
|darkslateblue| rgb(72,61,139)|
|darkslategray| rgb(47,79,79)|
|darkslategrey| rgb(47,79,79)|
|darkturquoise| rgb(0,206,209)|
|darkviolet| rgb(148,0,211)|
|deeppink| rgb(255,20,147)|
|deepskyblue| rgb(0,191,255)|
|dimgray| rgb(105,105,105)|
|dimgrey| rgb(105,105,105)|
|dodgerblue| rgb(30,144,255)|
|firebrick| rgb(178,34,34)|
|floralwhite| rgb(255,250,240)|
|forestgreen| rgb(34,139,34)|
|fuchsia| rgb(255,0,255)|
|gainsboro| rgb(220,220,220)|
|ghostwhite| rgb(248,248,255)|
|gold| rgb(255,215,0)|
|goldenrod| rgb(218,165,32)|
|gray| rgb(128,128,128)|
|green| rgb(0,128,0)|
|greenyellow| rgb(173,255,47)|
|grey| rgb(128,128,128)|
|honeydew| rgb(240,255,240)|
|hotpink| rgb(255,105,180)|
|indianred| rgb(205,92,92)|
|indigo| rgb(75,0,130)|
|ivory| rgb(255,255,240)|  
|khaki| rgb(240,230,140)|
|lavender| rgb(230,230,250)|
|lavenderblush| rgb(255,240,245)|
|lawngreen| rgb(124,252,0)|
|lemonchiffon| rgb(255,250,205)|
|lightblue| rgb(173,216,230)|
|lightcoral| rgb(240,128,128)|
|lightcyan| rgb(224,255,255)|
|lightgoldenrodyellow| rgb(250,250,210)|
|lightgray| rgb(211,211,211)|
|lightgreen| rgb(144,238,144)|
|lightgrey| rgb(211,211,211)|
|lightpink| rgb(255,182,193)|
|lightsalmon| rgb(255,160,122)|
|lightseagreen| rgb(32,178,170)|
|lightskyblue| rgb(135,206,250)|
|lightslategray| rgb(119,136,153)|
|lightslategrey| rgb(119,136,153)|
|lightsteelblue| rgb(176,196,222)|
|lightyellow| rgb(255,255,224)|
|lime| rgb(0,255,0)|
|limegreen| rgb(50,205,50)|
|linen| rgb(250,240,230)|
|magenta| rgb(255,0,255)|
|maroon| rgb(128,0,0)|
|mediumaquamarine| rgb(102,205,170)|
|mediumblue| rgb(0,0,205)|
|mediumorchid| rgb(186,85,211)|
|mediumpurple| rgb(147,112,219)|
|mediumseagreen| rgb(60,179,113)|
|mediumslateblue| rgb(123,104,238)|
|mediumspringgreen| rgb(0,250,154)|
|mediumturquoise| rgb(72,209,204)|
|mediumvioletred| rgb(199,21,133)|
|midnightblue| rgb(25,25,112)|
|mintcream| rgb(245,255,250)|
|mistyrose| rgb(255,228,225)|
|moccasin| rgb(255,228,181)|
|navajowhite| rgb(255,222,173)|
|navy| rgb(0,0,128)|
|oldlace| rgb(253,245,230)|
|olive| rgb(128,128,0)|
|olivedrab| rgb(107,142,35)|
|orange| rgb(255,165,0)|
|orangered| rgb(255,69,0)|
|orchid| rgb(218,112,214)|
|palegoldenrod| rgb(238,232,170)|
|palegreen| rgb(152,251,152)|
|paleturquoise| rgb(175,238,238)|
|palevioletred| rgb(219,112,147)|
|papayawhip| rgb(255,239,213)|
|peachpuff| rgb(255,218,185)|
|peru| rgb(205,133,63)|
|pink| rgb(255,192,203)|
|plum| rgb(221,160,221)|
|powderblue| rgb(176,224,230)|
|purple| rgb(128,0,128)|
|red| rgb(255,0,0)|
|rosybrown| rgb(188,143,143)|
|royalblue| rgb(65,105,225)|
|saddlebrown| rgb(139,69,19)|
|salmon| rgb(250,128,114)|
|sandybrown| rgb(244,164,96)|
|seagreen| rgb(46,139,87)|
|seashell| rgb(255,245,238)|
|sienna| rgb(160,82,45)|
|silver| rgb(192,192,192)|
|skyblue| rgb(135,206,235)|
|slateblue| rgb(106,90,205)|
|slategray| rgb(112,128,144)|
|slategrey| rgb(112,128,144)|
|snow| rgb(255,250,250)|
|springgreen| rgb(0,255,127)|
|steelblue| rgb(70,130,180)|
|tan| rgb(210,180,140)|
|teal| rgb(0,128,128)|
|thistle| rgb(216,191,216)|
|tomato| rgb(255,99,71)|
|turquoise| rgb(64,224,208)|
|violet| rgb(238,130,238)|
|wheat| rgb(245,222,179)|
|white| rgb(255,255,255)|
|whitesmoke| rgb(245,245,245)|
|yellow| rgb(255,255,0)|
|yellowgreen| rgb(154,205,50)|

---------------------------------------------------------------------------------------------------------
<!-- stylo/keyboard-shortcuts.html -->

# Keyboard shortcuts

## Actions 

### Sidebar

- Reveal the _Tools_ tab of the sidebar: `⌘⌥S`
- Reveal the _Style Picker_ tab of the sidebar: `⌘⌥⇧S`

### Styles 

- Reveal/hide the _Styles List_ : `⌘⇧S`
- Add a style: `⌘⇧A`
- Edit a style: `⌘⇧E`

### Style 

- Reveal / Hide Issue List: `⇧⌘I`
- Apply pending changes: `⇧⌘C`

### Preview 

- Reveal/hide preview: `⌘R`

### Text Statistics

- Enable/Disable Session Tool: `⇧⌘T`

## Mardown Editing  

- Heading 1: `⌘1`
- Heading 2: `⌘2`
- Heading 3: `⌘3`
- Heading 4: `⌘4`
- Heading 5: `⌘5`
- Heading 6: `⌘6`

- Create/Indent Block: `⌘>`

- Unordered list: `⌘L`
- Ordered list: `⇧⌘L`

- Bold: `⌘B`
- Italic: `⌘I`
- Strikethrough: `⌘-`
- Add Link: `⌘K`

---------------------------------------------------------------------------------------------------------
<!-- stylo/markdown-ua-stylesheet.html -->

# Markdown user-agent stylesheet

CSS:
 
  css
html {
    font-size: 1.2vw;
}

body {
    
    font-family: monospace;
    color: black;
}

h1 {
    
    font-size: 1.6rem;
}

h2 {
    font-size: 1.5rem;
}

h3 {
    font-size: 1.4rem;
}

h4 {
    font-size: 1.3rem;
}

h5 {
    font-size: 1.2rem;
}

h6 {
    font-size: 1.1rem;
}

em {
    font-style: italic;
}

strong {
    font-weight: bold;
}

s {
    text-decoration-style: solid;
    text-decoration-line: line-through;
    text-decoration-color: black;
}

s::tag {
    text-decoration-line: none;
}
 

---------------------------------------------------------------------------------------------------------
<!-- stylo/acknowledgments.html -->

# Acknowledgments  

Stylo has been made possible with the work of many indirect contributors. Thanks to them! Also thanks to everyone who's used Stylo and or given feedback. 

- [Included fonts](fonts.html)
- [Libraries](libraries.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/fonts.html -->

# Fonts

In addition to the system fonts, Stylo provides a number of additionnal fonts. We include here the licence for each font when necessary. 

## Arvo 

Copyright (c) 2010-2013, Anton Koovit (anton@korkork.com), with Reserved Font Name 'Arvo'

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Asap 

Copyright 2016 The Asap Project Authors (omnibus.type@gmail.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Bitstream Vera Sans mono 

Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved. Bitstream
Vera is a trademark of Bitstream, Inc.

This Font Software is licensed under the <a href="bitstream-licence.html">Bitstream licence</a>

## Cabin 

Copyright 2016 The Cabin Project Authors (impallari@gmail.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Cabin Condensed 

Copyright 2016 The Cabin Project Authors (impallari@gmail.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Cairo 

Copyright 2009 The Cairo Project Authors (gaber@gaberism.net)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Cormorant

Copyright (c) 2015, Christian Thalmann and the Cormorant Project Authors (github.com/CatharsisFonts/Cormorant)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Cormorant Garamond 

Copyright (c) 2015, Christian Thalmann and the Cormorant Project Authors (github.com/CatharsisFonts/Cormorant)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Cousine 

Cousine was designed by Steve Matteson as an innovative, refreshing sans serif design that is metrically compatible with Courier New™. Cousine offers improved on-screen readability characteristics and the pan-European WGL character set and solves the needs of developers looking for width-compatible fonts to address document portability across platforms.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Dosis 

Copyright (c) 2011, Edgar Tolentino and Pablo Impallari (www.impallari.com|impallari@gmail.com),
Copyright (c) 2011, Igino Marini. (www.ikern.com|mail@iginomarini.com),
with Reserved Font Names "Dosis".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## EB Garamond

Copyright 2017 The EB Garamond Project Authors (https://github.com/octaviopardo/EBGaramond12)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Fira Mono

Copyright (c) 2014, Mozilla Foundation https://mozilla.org/ with Reserved Font Name Fira Mono.

Copyright (c) 2014, Telefonica S.A.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Hack

The work in the Hack project is Copyright 2018 Source Foundry Authors and licensed under the MIT License

The work in the DejaVu project was committed to the public domain.

Bitstream Vera Sans Mono Copyright 2003 Bitstream Inc. and licensed under the Bitstream Vera License with Reserved Font Names "Bitstream" and "Vera"

MIT License
Copyright (c) 2018 Source Foundry Authors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

BITSTREAM VERA LICENSE
Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved. Bitstream Vera is a trademark of Bitstream, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of the fonts accompanying this license ("Fonts") and associated documentation files (the "Font Software"), to reproduce and distribute the Font Software, including without limitation the rights to use, copy, merge, publish, distribute, and/or sell copies of the Font Software, and to permit persons to whom the Font Software is furnished to do so, subject to the following conditions:

The above copyright and trademark notices and this permission notice shall be included in all copies of one or more of the Font Software typefaces.

The Font Software may be modified, altered, or added to, and in particular the designs of glyphs or characters in the Fonts may be modified and additional glyphs or characters may be added to the Fonts, only if the fonts are renamed to names not containing either the words "Bitstream" or the word "Vera".

This License becomes null and void to the extent applicable to Fonts or Font Software that has been modified and is distributed under the "Bitstream Vera" names.

The Font Software may be sold as part of a larger software package but no copy of one or more of the Font Software typefaces may be sold by itself.

THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL BITSTREAM OR THE GNOME FOUNDATION BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM OTHER DEALINGS IN THE FONT SOFTWARE.

Except as contained in this notice, the names of Gnome, the Gnome Foundation, and Bitstream Inc., shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Font Software without prior written authorization from the Gnome Foundation or Bitstream Inc., respectively. For further information, contact: fonts at gnome dot org.

## IBM Plex Mono

Copyright © 2017 IBM Corp. with Reserved Font Name "Plex"

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## IBM Plex Sans 

Copyright © 2017 IBM Corp. with Reserved Font Name "Plex"

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## IBM Plex Sans Condensed 

Copyright © 2017 IBM Corp. with Reserved Font Name "Plex"

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## IBM Plex Serif

Copyright © 2017 IBM Corp. with Reserved Font Name "Plex"

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Inconsolata

Copyright 2006 The Inconsolata Project Authors

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Josefin Sans 

Copyright (c) 2010, Santiago Orozco (hi@typemade.mx)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Jura 

Copyright 2016 The Jura Font Project Authors (daniel@danieljohnson.name)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Kanit 

Copyright (c) 2015, Cadson Demak (info@cadsondemak.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Lato 

Copyright (c) 2010-2014 by tyPoland Lukasz Dziedzic (team@latofonts.com) with Reserved Font Name "Lato"

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Liberation Mono

Digitized data copyright (c) 2010 Google Corporation
with Reserved Font Arimo, Tinos and Cousine.
Copyright (c) 2012 Red Hat, Inc.
with Reserved Font Name Liberation.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Libre Franklin

Copyright (c) 2015, Impallari Type (www.impallari.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Lora 

Copyright 2011 The Lora Project Authors (https://github.com/cyrealtype/Lora-Cyrillic), with Reserved Font Name "Lora".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Martel 

Copyright (c) 2015 Dan Reynolds. Copyright (c) 2010-2015, Sorkin Type Co (www.sorkintype.com) with Reserved Font Name 'Merriweather'

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Merriweather 

Copyright 2016 The Merriweather Project Authors (https://github.com/EbenSorkin/Merriweather), with Reserved Font Name "Merriweather".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Merriweather Sans

Copyright (c) 2013-2016, Sorkin Type Co (www.sorkintype.com) with Reserved Font Name 'Merriweather'. Merriweather is a trademark of Sorkin Type Co.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Montserrat

Copyright 2011 The Montserrat Project Authors (https://github.com/JulietaUla/Montserrat)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Muli 

Copyright (c) 2016 The Muli Project Authors (contact@sansoxygen.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Noto Mono 

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Noto Sans 

Copyright 2012 Google Inc. All Rights Reserved.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Noto Serif 

Copyright 2012 Google Inc. All Rights Reserved.


This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Nunito 

Copyright 2014 The Nunito Project Authors (contact@sansoxygen.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Office Pro Sans 

Reserved font name: “Office Code Pro”

Copyright © 2015 Nathan Rutzky ( www.nath.co )
Copyright © 2015 Adobe Systems ( www.adobe.com ) 
All Rights Reserved.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Open Sans 

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>


## Open Sans Condensed 

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>


## Overpass

Copyright (c) 2016 by Red Hat, Inc. All rights reserved.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Overpass Mono


Copyright (c) 2016 by Red Hat, Inc. All rights reserved.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Playfair Display 

Copyright 2017 The Playfair Display Project Authors (https://github.com/clauseggers/Playfair-Display), with Reserved Font Name "Playfair Display".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Prompt

Copyright (c) 2015, Cadson Demak (info@cadsondemak.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## PT Mono

Copyright (c) 2011, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans", "PT Serif", "PT Mono" and "ParaType".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## PT Sans

Copyright (c) 2010, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans" and "ParaType".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## PT Sans Caption 

Copyright (c) 2010, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans" and "ParaType".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## PT Sans Narrow 

Copyright (c) 2010, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans" and "ParaType".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## PT Serif  

Copyright (c) 2010, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans", "PT Serif" and "ParaType".

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## PT Serif  Caption

Copyright (c) 2010, ParaType Ltd. (http://www.paratype.com/public),
with Reserved Font Names "PT Sans", "PT Serif" and "ParaType".


This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>


## Quicksand

Copyright (c) 2011, Andrew Paglinawan (www.andrewpaglinawan.com andrew.paglinawan@gmail.com), with Reserved Font Name “Quicksand”.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Raleway 

Copyright (c) 2010, Matt McInerney (matt@pixelspread.com),
Copyright (c) 2011, Pablo Impallari (www.impallari.com|impallari@gmail.com),
Copyright (c) 2011, Rodrigo Fuenzalida (www.rfuenzalida.com|hello@rfuenzalida.com), with Reserved Font Name Raleway

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Roboto 

Copyright 2011 Google Inc. All Rights Reserved.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Roboto Condensed 

Copyright 2011 Google Inc. All Rights Reserved.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Roboto Mono

Copyright 2011 Google Inc. All Rights Reserved.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Roboto Slab 

Copyright 2011 Google Inc. All Rights Reserved.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Rokkit

Copyright 2016 The Rokkit Project Authors (contact@sansoxygen.com)

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Source Code Pro 

Copyright 2010, 2012 Adobe Systems Incorporated (http://www.adobe.com/), with Reserved Font Name 'Source'. All Rights Reserved. Source is a trademark of Adobe Systems Incorporated in the United States and/or other countries.

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

## Space Mono 

Copyright 2016 Google Inc. All Rights Reserved.

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>



## Titilium Web 

Copyright (c) 2009-2011 by Accademia di Belle Arti di Urbino and students of MA course of Visual design. Some rights reserved.

Copyright 2016 Apple, Inc. Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>

## Zilla Slab

Copyright 2017, The Mozilla Foundation

This Font Software is licensed under the <a href="sil1.1.html">SIL Open Font License, Version 1.1.</a>

---------------------------------------------------------------------------------------------------------
<!-- stylo/libraries.html -->

# Libraries 

## MailCore

MailCore 2

Copyright (C) 2001 - 2013 - MailCore team
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of the MailCore project nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

## PathKit

Copyright (c) 2014, Kyle Fuller
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## PromiseKit 

Copyright 2016-present, Max Howell; mxcl@me.com

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



## Protobuf

Copyright 2008 Google Inc.  All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.
    * Neither the name of Google Inc. nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Code generated by the Protocol Buffer compiler is owned by the owner
of the input file used when generating it.  This code is not
standalone and requires a support library to be linked with it.  This
support library is itself covered by the above license.


## Spectre

Copyright (c) 2015, Kyle Fuller
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Stencil 

Copyright (c) 2018, Kyle Fuller
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



## Swift Protobuf 

Copyright 2016 Apple, Inc. 

Licensed under the <a href="apache-version-2.0.html">Apache License, Version 2.0.</a>


---------------------------------------------------------------------------------------------------------
<!-- stylo/linked-licences.html -->

# Linked Licences


- [Apache Version 2.0](apache-version-2.0.html)
- [SIL 1.0](sil1.1.html)
- [Bitream Licence](bitstream-licence.html)

---------------------------------------------------------------------------------------------------------
<!-- stylo/apache-version-2.0.html -->

# Apache License

                           Version 2.0, January 2004
                        http://www.apache.org/licenses/



TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.

  "License" shall mean the terms and conditions for use, reproduction,
  and distribution as defined by Sections 1 through 9 of this document.

  "Licensor" shall mean the copyright owner or entity authorized by
  the copyright owner that is granting the License.

  "Legal Entity" shall mean the union of the acting entity and all
  other entities that control, are controlled by, or are under common
  control with that entity. For the purposes of this definition,
  "control" means (i) the power, direct or indirect, to cause the
  direction or management of such entity, whether by contract or
  otherwise, or (ii) ownership of fifty percent (50%) or more of the
  outstanding shares, or (iii) beneficial ownership of such entity.

  "You" (or "Your") shall mean an individual or Legal Entity
  exercising permissions granted by this License.

  "Source" form shall mean the preferred form for making modifications,
  including but not limited to software source code, documentation
  source, and configuration files.

  "Object" form shall mean any form resulting from mechanical
  transformation or translation of a Source form, including but
  not limited to compiled object code, generated documentation,
  and conversions to other media types.

  "Work" shall mean the work of authorship, whether in Source or
  Object form, made available under the License, as indicated by a
  copyright notice that is included in or attached to the work
  (an example is provided in the Appendix below).

  "Derivative Works" shall mean any work, whether in Source or Object
  form, that is based on (or derived from) the Work and for which the
  editorial revisions, annotations, elaborations, or other modifications
  represent, as a whole, an original work of authorship. For the purposes
  of this License, Derivative Works shall not include works that remain
  separable from, or merely link (or bind by name) to the interfaces of,
  the Work and Derivative Works thereof.

  "Contribution" shall mean any work of authorship, including
  the original version of the Work and any modifications or additions
  to that Work or Derivative Works thereof, that is intentionally
  submitted to Licensor for inclusion in the Work by the copyright owner
  or by an individual or Legal Entity authorized to submit on behalf of
  the copyright owner. For the purposes of this definition, "submitted"
  means any form of electronic, verbal, or written communication sent
  to the Licensor or its representatives, including but not limited to
  communication on electronic mailing lists, source code control systems,
  and issue tracking systems that are managed by, or on behalf of, the
  Licensor for the purpose of discussing and improving the Work, but
  excluding communication that is conspicuously marked or otherwise
  designated in writing by the copyright owner as "Not a Contribution."

  "Contributor" shall mean Licensor and any individual or Legal Entity
  on behalf of whom a Contribution has been received by Licensor and
  subsequently incorporated within the Work.

2. Grant of Copyright License. Subject to the terms and conditions of
  this License, each Contributor hereby grants to You a perpetual,
  worldwide, non-exclusive, no-charge, royalty-free, irrevocable
  copyright license to reproduce, prepare Derivative Works of,
  publicly display, publicly perform, sublicense, and distribute the
  Work and such Derivative Works in Source or Object form.

3. Grant of Patent License. Subject to the terms and conditions of
  this License, each Contributor hereby grants to You a perpetual,
  worldwide, non-exclusive, no-charge, royalty-free, irrevocable
  (except as stated in this section) patent license to make, have made,
  use, offer to sell, sell, import, and otherwise transfer the Work,
  where such license applies only to those patent claims licensable
  by such Contributor that are necessarily infringed by their
  Contribution(s) alone or by combination of their Contribution(s)
  with the Work to which such Contribution(s) was submitted. If You
  institute patent litigation against any entity (including a
  cross-claim or counterclaim in a lawsuit) alleging that the Work
  or a Contribution incorporated within the Work constitutes direct
  or contributory patent infringement, then any patent licenses
  granted to You under this License for that Work shall terminate
  as of the date such litigation is filed.

4. Redistribution. You may reproduce and distribute copies of the
  Work or Derivative Works thereof in any medium, with or without
  modifications, and in Source or Object form, provided that You
  meet the following conditions:

  (a) You must give any other recipients of the Work or
      Derivative Works a copy of this License; and

  (b) You must cause any modified files to carry prominent notices
      stating that You changed the files; and

  (c) You must retain, in the Source form of any Derivative Works
      that You distribute, all copyright, patent, trademark, and
      attribution notices from the Source form of the Work,
      excluding those notices that do not pertain to any part of
      the Derivative Works; and

  (d) If the Work includes a "NOTICE" text file as part of its
      distribution, then any Derivative Works that You distribute must
      include a readable copy of the attribution notices contained
      within such NOTICE file, excluding those notices that do not
      pertain to any part of the Derivative Works, in at least one
      of the following places: within a NOTICE text file distributed
      as part of the Derivative Works; within the Source form or
      documentation, if provided along with the Derivative Works; or,
      within a display generated by the Derivative Works, if and
      wherever such third-party notices normally appear. The contents
      of the NOTICE file are for informational purposes only and
      do not modify the License. You may add Your own attribution
      notices within Derivative Works that You distribute, alongside
      or as an addendum to the NOTICE text from the Work, provided
      that such additional attribution notices cannot be construed
      as modifying the License.

  You may add Your own copyright statement to Your modifications and
  may provide additional or different license terms and conditions
  for use, reproduction, or distribution of Your modifications, or
  for any such Derivative Works as a whole, provided Your use,
  reproduction, and distribution of the Work otherwise complies with
  the conditions stated in this License.

5. Submission of Contributions. Unless You explicitly state otherwise,
  any Contribution intentionally submitted for inclusion in the Work
  by You to the Licensor shall be under the terms and conditions of
  this License, without any additional terms or conditions.
  Notwithstanding the above, nothing herein shall supersede or modify
  the terms of any separate license agreement you may have executed
  with Licensor regarding such Contributions.

6. Trademarks. This License does not grant permission to use the trade
  names, trademarks, service marks, or product names of the Licensor,
  except as required for reasonable and customary use in describing the
  origin of the Work and reproducing the content of the NOTICE file.

7. Disclaimer of Warranty. Unless required by applicable law or
  agreed to in writing, Licensor provides the Work (and each
  Contributor provides its Contributions) on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
  implied, including, without limitation, any warranties or conditions
  of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
  PARTICULAR PURPOSE. You are solely responsible for determining the
  appropriateness of using or redistributing the Work and assume any
  risks associated with Your exercise of permissions under this License.

8. Limitation of Liability. In no event and under no legal theory,
  whether in tort (including negligence), contract, or otherwise,
  unless required by applicable law (such as deliberate and grossly
  negligent acts) or agreed to in writing, shall any Contributor be
  liable to You for damages, including any direct, indirect, special,
  incidental, or consequential damages of any character arising as a
  result of this License or out of the use or inability to use the
  Work (including but not limited to damages for loss of goodwill,
  work stoppage, computer failure or malfunction, or any and all
  other commercial damages or losses), even if such Contributor
  has been advised of the possibility of such damages.

9. Accepting Warranty or Additional Liability. While redistributing
  the Work or Derivative Works thereof, You may choose to offer,
  and charge a fee for, acceptance of support, warranty, indemnity,
  or other liability obligations and/or rights consistent with this
  License. However, in accepting such obligations, You may act only
  on Your own behalf and on Your sole responsibility, not on behalf
  of any other Contributor, and only if You agree to indemnify,
  defend, and hold each Contributor harmless for any liability
  incurred by, or claims asserted against, such Contributor by reason
  of your accepting any such warranty or additional liability.

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.

  To apply the Apache License to your work, attach the following
  boilerplate notice, with the fields enclosed by brackets "[]"
  replaced with your own identifying information. (Don't include
  the brackets!)  The text should be enclosed in the appropriate
  comment syntax for the file format. We also recommend that a
  file or class name and description of purpose be included on the
  same "printed page" as the copyright notice for easier
  identification within third-party archives.

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

   
   
#### Runtime Library Exception to the Apache 2.0 License


As an exception, if you use this Software to compile your source code and
portions of this Software are embedded into the binary product as a result,
you may redistribute such product without providing attribution as would
otherwise be required by Sections 4(a), 4(b) and 4(d) of the License.

---------------------------------------------------------------------------------------------------------
<!--stylo/sil1.1.html -->

SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
-----------------------------------------------------------

PREAMBLE
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded, 
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

DEFINITIONS
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

PERMISSION & CONDITIONS
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

TERMINATION
This license becomes null and void if any of the above conditions are
not met.

DISCLAIMER
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.


---------------------------------------------------------------------------------------------------------
<!-- stylo/bitstream-licence.html -->

# Bitstream licence 

Permission is hereby granted, free of charge, to any person obtaining
a copy of the fonts accompanying this license ("Fonts") and associated
documentation files (the "Font Software"), to reproduce and distribute
the Font Software, including without limitation the rights to use,
copy, merge, publish, distribute, and/or sell copies of the Font
Software, and to permit persons to whom the Font Software is furnished
to do so, subject to the following conditions:

The above copyright and trademark notices and this permission notice
shall be included in all copies of one or more of the Font Software
typefaces.

The Font Software may be modified, altered, or added to, and in
particular the designs of glyphs or characters in the Fonts may be
modified and additional glyphs or characters may be added to the
Fonts, only if the fonts are renamed to names not containing either
the words "Bitstream" or the word "Vera".

This License becomes null and void to the extent applicable to Fonts
or Font Software that has been modified and is distributed under the
"Bitstream Vera" names.

The Font Software may be sold as part of a larger software package but
no copy of one or more of the Font Software typefaces may be sold by
itself.

THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL
BITSTREAM OR THE GNOME FOUNDATION BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF THE USE OR INABILITY TO USE THE FONT
SOFTWARE OR FROM OTHER DEALINGS IN THE FONT SOFTWARE.

Except as contained in this notice, the names of Gnome, the Gnome
Foundation, and Bitstream Inc., shall not be used in advertising or
otherwise to promote the sale, use or other dealings in this Font
Software without prior written authorization from the Gnome Foundation
or Bitstream Inc., respectively. For further information, contact:
fonts at gnome dot org.

Copyright FAQ

   1. I don't understand the resale restriction... What gives?

      Bitstream is giving away these fonts, but wishes to ensure its
      competitors can't just drop the fonts as is into a font sale system
      and sell them as is. It seems fair that if Bitstream can't make money
      from the Bitstream Vera fonts, their competitors should not be able to
      do so either. You can sell the fonts as part of any software package,
      however.

   2. I want to package these fonts separately for distribution and
      sale as part of a larger software package or system.  Can I do so?

      Yes. A RPM or Debian package is a "larger software package" to begin 
      with, and you aren't selling them independently by themselves. 
      See 1. above.

   3. Are derivative works allowed?
      Yes!

   4. Can I change or add to the font(s)?
      Yes, but you must change the name(s) of the font(s).

   5. Under what terms are derivative works allowed?

      You must change the name(s) of the fonts. This is to ensure the
      quality of the fonts, both to protect Bitstream and Gnome. We want to
      ensure that if an application has opened a font specifically of these
      names, it gets what it expects (though of course, using fontconfig,
      substitutions could still could have occurred during font
      opening). You must include the Bitstream copyright. Additional
      copyrights can be added, as per copyright law. Happy Font Hacking!

   6. If I have improvements for Bitstream Vera, is it possible they might get 
       adopted in future versions?

      Yes. The contract between the Gnome Foundation and Bitstream has
      provisions for working with Bitstream to ensure quality additions to
      the Bitstream Vera font family. Please contact us if you have such
      additions. Note, that in general, we will want such additions for the
      entire family, not just a single font, and that you'll have to keep
      both Gnome and Jim Lyles, Vera's designer, happy! To make sense to add
      glyphs to the font, they must be stylistically in keeping with Vera's
      design. Vera cannot become a "ransom note" font. Jim Lyles will be
      providing a document describing the design elements used in Vera, as a
      guide and aid for people interested in contributing to Vera.

   7. I want to sell a software package that uses these fonts: Can I do so?

      Sure. Bundle the fonts with your software and sell your software
      with the fonts. That is the intent of the copyright.

   8. If applications have built the names "Bitstream Vera" into them, 
      can I override this somehow to use fonts of my choosing?

      This depends on exact details of the software. Most open source
      systems and software (e.g., Gnome, KDE, etc.) are now converting to
      use fontconfig (see www.fontconfig.org) to handle font configuration,
      selection and substitution; it has provisions for overriding font
      names and subsituting alternatives. An example is provided by the
      supplied local.conf file, which chooses the family Bitstream Vera for
      "sans", "serif" and "monospace".  Other software (e.g., the XFree86
      core server) has other mechanisms for font substitution.

