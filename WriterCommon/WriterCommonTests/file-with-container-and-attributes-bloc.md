 # Stylo User Guide 

## Contents ## 

{.test .class #id key=value}
<div id="toc_container">
<ul class="toc_list">
	<li>
		<a href="#about">About</a>
		<ul>
			<li><a href="#about-stylo">Stylo</a></li> 
			<li><a href="#about-file-format">File format</a></li>
		</ul>
	</li>
	<li>
		<a href="#essentials">Essentials</a>
	</li>
	<li>
		<a href="#user-interface">User Interface</a>
		<ul>
			<li><a href="#ui-distraction-free">Distraction free</a></li>
			<li><a href="#ui-description">Description</a></li>
			<li><a href="#ui-html-preview">HTML Preview</a></li>  
			<li><a href="#ui-markdown-editor">Markdown Editor</a></li> 
			<li><a href="#ui-statistics-session">Text Statistics and Session Popup</a></li> 
			<li><a href="#ui-sidebar">Sidebar</a></li> 
			<li><a href="#ui-styles-list">Styles List</a></li> 
			<li><a href="#ui-style-editor">Style Editor</a></li> 
		</ul>
	</li>
	<li><a href="#markdown">Markdown</a>
		<ul>
			<li><a href="#md-description">Description</a></li> 
			<li><a href="#md-html">HTML</a></li>  
			<li><a href="#md-headers">Headers</a></li>  
			<li><a href="#md-horizontal-bar">Horizontal Bar</a></li> 
			<li><a href="#md-emphasis">Emphasis</a></li> 
			<li><a href="#md-blockquote">Blockquote</a></li> 
			<li><a href="#md-lists">Lists</a></li> 
			<li><a href="#md-code">Code</a></li>
			<li><a href="#md-table">Table</a></li> 
			<li><a href="#md-reference">Reference</a></li> 
			<li><a href="#md-link">Link</a></li> 
			<li><a href="#md-image">Image</a></li> 
		</ul>
	</li>
	<li><a href="#html">HTML</a>
		<ul>
			<li><a href="#html-document">Document</a></li> 
			<li><a href="#html-element">Element</a></li>
			<li><a href="#html-definitions">Definitions</a></li>
			<li><a href="#html-attributes">Attributes</a></li>
			<li><a href="#html-id">Id</a></li>
			<li><a href="#html-class">Class</a></li>
		</ul>
	</li>
	<li><a href="#css">CSS</a>
		<ul>
			<li><a href="#css-style">Style</a></li> 
			<li><a href="#css-selector">Selector</a></li>
			<li><a href="#css-stylesheet">Stylesheet</a></li>
			<li><a href="#css-cascading">Cascading</a></li> 
			<li><a href="#css-priority-rules">Priority rules</a></li> 
			<li><a href="#css-properties">Properties</a></li> 
			<li><a href="#css-property-values">Property values</a></li>
		</ul>
	</li>
	<li><a href="#appendix">Appendix</a>
		<ul>
			<li><a href="#appendix-font-keywords">Fonts keywords</a></li>
			<li><a href="#appendix-color-keywords">Color keywords</a></li>
  			<li><a href="#appendix-markdown-elements">Markdown elements</a></li>
			<li><a href="#appendix-keyboard-shortcuts">Keyboard shortcuts</a></li>
			<li><a href="#appendix-markdown-ua-stylesheet">Markdown user-agent stylesheet</a></li>
		</ul>
	</li>
</ul>
</div>

<h2 id="about">About</h2>

<h3 id="about-stylo">Stylo</h3> 

Stylo is a Markdown text editing application in the [CommonMark](https://commonmark.org/) version with some essentials additions, like tables. Markdown format and lightweight markup languages in general were a big progress in the evolution of text editors. It clearly separated the content from the presentation. In Markdown, what we see is the content, without any formatting: bold, italics or the different fonts we could use in a Rich Text editor. These are applied later in the publication process, and can be applied many times over time and/or for different plateforms. The old way of doing things using Rich Text, were design was embeded in the source text and was saved along with the content, was simply not adapted for the publishing environment of today.
{.test .class #id key=value}

But, for many writers,  Rich text was a way to personnalize their own writing environment and the design that was applied to their source text was not for the end audience but for themselves, as a writer, to help them feel comfortable, inspired while writing. Every writer has it's own needs and preferences. The text editor has become a major part of the writing environment. In the paper era, a writer could use a particular kind of paper, maybe a textured one. He could write with different kind of pens, to get different lines tickness, or could use a different ink color, brand or tint. These things were all part of the writing experience: with Markdown we lost most of that. These habits were not part of a design process for the end published text, but part of a personnal design experience to enhance the writing.   

{.test .class #id key=value}

In Stylo, we bring back this personnal experience at it's highest level without comprimising the advantages of Markdown and plain text editing in general. Markdown is a plain text format, and one concequence is we can not save design information. We solved the problem of personnalisation using the Web technologies and mainly using CSS, which is also a plain text format: _Stylo is plain text editing with rich text formatting._ In Stylo, we want to offer all the tools available to personnalize the writing experience without compromising the plain text format usefulness and philosophy. 

<h3 id="about-file-format">File format</h3> 

Markdown files use the _.md_ extension. Stylo saves all the files in a document to a directory where you can review the content by right-clicking on the _.stylo_ file and choosing the `Show Package Contents` option. This directory contains two subdirectories:

- sources
- styles

The _sources_ directory contains the text documents saved as a _.md_ file, and the styles directory contains all the styles. Each style contains all the stylesheets asociated with one style, saved as _.css_ files in CSS format.

<h2 id="essentials">Essentials</h2> 

### New document 

To create a new document:

- From the menu, choose `File`→`New`
- Use keyboard shortcut: `⌘N`

### Save a document

Stylo will automatically save your documents as you make changes. But if you want to save a document manually:

- From the menu, choose `File`→`Save`
- Use keyboard shortcut: `⌘S`

### Rename a document

To rename a document:

- From the menu, choose `File`→`Rename ...`

### Export a document

Stylo supports 4 export formats:

- HTML
- Word
- Markdown (the document source text without changes)
- PDF

To export a document:

- From the menu, choose `File`→`Export` and choose the destination format.

### Print a document

To print a document:

- From the menu, choose `File`→`Print ...`

<h2 id="user-interface">User Interface</h2> 

<h3 id="ui-distraction-free">Distraction free writing</h3>  

Stylo maximizes the space occupied by the text itself to create a writing environment without distractions, after all, the purpose of a text editor is editing text! So, at any point, when possible and expected, all accessory interface elements will disappear to leave the window only for the text. To see a hidden accessory, simply move the mouse where it should be and it will reveal itself.

Note: The title of a document at the top of the window will not show up if the "Styles" tab is visible to prevent the title from overlapping the "Styles" tab. Just hide the "Styles" tab (`⌘⇧S`, see <a href="#ui-styles-list-hide">Hide the list of styles</a>) and once the "Styles List" is hidden, the title will reveal when passing the mouse over it.


::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

#### Sidebar 

The "Sidebar" provides access to all the features of Stylo. It is located at the extreme right of the Stylo document window and it contains two tabs: "Tools" and "Style Picker". 

##### Tools tab 

The "Tools" tab in the sidebar provides quick access to all Stylo tools.

It contains, from top to bottom:

1. the "Sidebar Tab Switcher" button to switch to the "Style Picker"

The button to switch to the "Style Picker" represents a symbol containing two simplified images of style preview on top of each other. Clicking on the button will switch to the "Style Picker" tab of the sidebar.

2. button to show/hide HTML preview

The "Preview" button is represented by the symbol of an eye. 

3. button to show/hide the list of styles

The button to show the "Styles" list is represented by a symbol containing the tip of a brush, symbolizing the act of manipulating a style.
 
4. button to see the text statistics/writing session statistics

The button to show the "Text Statistics" view is represented by the lowercase letter "i". See the section [Statistics and Session](#ui-statistics-session) for a complete description.  

5. Markdown formatting tools.

The various buttons provide access to the Markdown formatting functions. See the section [Markdown Editor](#ui-markdown-editor) for a complete description.

##### Style Picker tab

The style selection tab contains, from top to bottom:

1. the "Sidebar Tab Switcher" button to switch to the "Tools" tab

The button shows a pencil tip and a brush tip one above the other. When pressed it switches the sidebar to the "Tools" tab.

2. list of style previews

A style preview is a smaller version of a style preview in the style list on the left. It allows to select a style. 

3. a positioning indicator (if the window is too small to show all styles previews buttons)

The length of the indicator is proportional to the amount of styles that are visible over the total number of styles. If the positioning indicator is on the left, the styles shown are at the beginning of the list of styles, and the indicator moves to the right to indicate that we are closer to the end of the list.

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

{.test .class #id key=value}
#### Styles Section 

The styles section contains the "Styles list" and allows to access the style editor to edit the CSS source of each style of the list.

##### Styles List {.test .class #id key=value}

The "Styles List" allows, like the "Style Picker" sidebar tab, to choose a style to apply to the current document, moreover, it allows to access the different possible actions on a style: edit, add or delete.

##### Style editor  {.test .class #id key=value}

The style editor includes a title section, the CSS editor itself, and the issues list.

The title section includes:
1. the name of the style
2. an indicator showing the number of problems in the source file
3. the back button to return to the "Styles List"
4. the "Apply" button that apply the current style to the document (including unapplied changes)
5. the "Issues" button which gives access to the list of issues.

The issues section includes the list of issues (warnings, errors) applied to the current CSS source.

<h3 id="ui-html-preview">HTML Preview</h3>  

#### Reveal/hide the HTML Preview  

##### Reveal the HTML preview 

To reveal the HTML preview:

{.test .class #id key=value}
- From the menu, choose: `View`→`Show Preview` {.test .class key=value}
- From the "Tools" tab of the sidebar, click on the `Preview` button (an eye). {.test .class key=value}


##### Hide the HTML preview 

To hide the HTML preview:

- From the menu, choose: `View`→`Hide Preview`
- From the "Tools" tab of the sidebar, click on the `Preview` button (an eye).

<h3 id="ui-markdown-editor">Markdown editor</h3>  
{.test .class key=value}

#### Create a Header level 1

To create a header level 1:

- Textually(option 1), enter `#`, one or more spaces, and the title itself
- Textually(option 2), enter the title itself then on the following line one or more `-`
- From the menu, choose: `Format`→`Heading 1`
- From the "Tools" tab of the sidebar, click on the `h1` button
- Using the keyboard shortcut, enter `⌘1`

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

#### Create a Header level 2

To create a header level 2:

- Textually(option 1), enter `##`, one or more spaces, and the title itself
- Textually(option 2), enter the title itself and then on the following line one or more `=`
- From the menu, choose: `Format`→`Heading 2`
- From the "Tools" tab of the sidebar, click on the `h2` button
- Using the keyboard shortcut, enter `⌘2`

#### Create a Header level 3

To create a header  level 3:

- Textually, enter `###`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 3`
- From the "Tools" tab of the sidebar, click on the `h3` button
- Using the keyboard shortcut, enter `⌘3`


#### Create a Header level 4

To create a header level 4:

- Textually, enter `####`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 4`
- From the "Tools" tab of the sidebar, click on the `h4` button
- Using the keyboard shortcut, enter `⌘4`

#### Create a Header level 5

To create a header level 5:

- Textually, enter `#####`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 5`
- Using the keyboard shortcut, enter `⌘5`

#### Create a Header level 6

To create a header level 6:

- Textually, enter `######`, one or more spaces, and the title itself
- From the menu, choose: `Format`→`Heading 6`
- Using the keyboard shortcut, enter `⌘6`

#### Create blocquote

To create a blockquote:

- Textually, enter `>` at the beginning of a line
- From the menu, choose: `Format`→`Blockquote`
- From the "Tools" tab of the sidebar, select the text to be transformed into a block ciation and click on the `>` button.
- Using the keyboard shortcut, enter `⌘>`

#### Create an unordered list

To create an unordered list:

- Textually, enter `-` at the beginning of each line of the list
- From the menu, choose: `Format`→`Unordered List`
- From the "Tools" tab of the sidebar, select the text to be transformed into a block citation and click on the `-` button.
- Using the keyboard shortcut, enter `⌘L`

#### Create an ordered list

To create an ordered list:

- Textually, enter the numbers at the beginning of each line of the list, for example: `1.`
- From the menu, select: `Format`→`Ordered List`
- From the "Tools" tab of the sidebar, select the text to be transformed into an ordered list and click on the `1.` button
- Using the keyboard shortcut, enter `⇧⌘L`

#### Convert to bold 

To convert to bold:

- Textually, surround the text to bold characters "**"
- From the menu, choose: `Format`→`Bold`
- From the "Tools" tab of the sidebar, select the text to convert to bold and click on the `B` button
- Using the keyboard shortcut, enter `⌘B`

#### Convert to italic

To convert to italic:

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

- Textually, surround the text to be converted to italic with star ("*") characters
- From the menu, choose: `Format`→`Italic`
- From the "Tools" tab of the sidebar, select the text to be converted to italic and click on the `I` button.
- Using the keyboard shortcut, enter `⌘I`

#### Make Strikethrough

To add a strikethrough:

- Textually, surround the text to strikethrough with "-"
- From the menu, choose: `Format`→`Strikethrough`
- From the "Tools" tab of the sidebar, select the text to strikethrough and click on the `S` button
- Using the keyboard shortcut, enter `⌘-`

#### Make a link 

A link take the general form [<link name>](<destination of the link>). For example: 

Markdown:

``` markdown 
[Stylo](http://www.textually.net/stylo)
```

HTML:

``` html 
<p><a href="http://www.textually.net/stylo">Stylo</a></p>
```

would create a link named "Stylo" pointing to the URL: "http://www.textually.net/stylo".


<h3 id="ui-statistics-session">Text Statistics and Session Popup</h3>  

The text statistics provide usefull metrics about the text currently edited like total number of  characters, words, etc... The session tools are meant to complement this information by providing the change in text statistics from a point in time. A user may start a session and can know at any point later the text statistics since the moment the session was started. Note that this information is saved with the document, so the document can be closed and the session information wont be lost. 

The text statistics popup shows the text statistics and the session statistics. The total text statistics are in gray, and the session statistics, along with the session related controls, are shown in the current system highlight color.  The session tools can be completly disabled if desired (see <a href="#ui-statistics-session-enable-disable">Enable/Disable Session Tools</a> section for more information).

#### Total Text Statistics 

The total statistics contains many indicators regarding the text: 

- number of characters 
- number of words 
- number of sentences 
- number of paragraphs 
- number of pages 

and reading time estimations for a slow, average and fast reader.  

#### Session 

By default, the session tools are enabled. When creating a new document there is no session started so if a user wants to record the progress since a point in time, a session should be started, see "Start a session" section below. When a session is started, it's possible to hide or show the session information using the `Hide` or `Show` buttons (see "Show a session " and "Hide a session" sections below). It is also possible to restart the session counters (which effectively creates a new session), all the counters are then reset to 0 and the session counters will count from that new reference. It is always possible to know when a session has been started using "Session start date" label at the bottom of the "Text statitics and session popup".

##### Start a session 

To start a session: 

Press the `i` button ("Text Statistics and Session") on the sidebar "Tools" tab (see "Reveal the sidebar "Tools" tab" section for more information), and press the `Start Session` button.   

##### Restart a session 

To restart a session:

Press the `i` button ("Text Statistics and Session") on the sidebar "Tools" tab (see "Reveal the sidebar "Tools" tab" section for more information), and press the `Restart` button.  

##### Show a session 

To show a session:

Press the `i` button ("Text Statistics and Session") on the sidebar "Tools" tab (see "Reveal the sidebar "Tools" tab" section for more information), and press the `Show Session` button.  

##### Hide a session 

To hide a session:

Press the `i` button ("Text Statistics and Session") on the sidebar "Tools" tab (see "Reveal the sidebar "Tools" tab" section for more information), and press the `Hide` button.  

<h5 id="ui-statistics-session-enable-disable">Enable/Disable Session Tools</h5>

It is possible to disable at any point the "Session Tools" using the menu if it not used to decluter the interface. Disabling the session tools does not delete existing session information, it only remove the UI elements that are linked to it, so if the session tools are re-enabled the session information will still be valid. 

###### Disable Session Tools

To disable the "Session tools":

- From the menu, choose `View`→`Text Statistics`→`Disable Session Tools`
- Use keyboard shortcuts: `⌘⇧T`

###### Enable Session Tools

To enable the "Session tools":

- From the menu, choose `View`→`Text Statistics`→`Enable Session Tools`
- Use keyboard shortcuts: `⌘⇧T`



<h3 id="ui-sidebar">Sidebar</h3>  


#### Reveal/Hide Sidebar

The sidebar is the vertical and narrow bar on the right of a Stylo document window and can be either inactive, show the "Tools" tab, or show the "Style Picker" tab. When the sidebar is visible you can switch between the two sidebar tabs using the "Sidebar Tab Switcher" button at the top.


##### Reveal the sidebar

To reveal the sidebar (if it's not visible):

1. Move the mouse cursor to the right side of a Stylo document window.

##### Hide the sidebar

The sidebar will automatically hide when editing the main text, if the style editing tools and/or style list are not open. To manually hide the sidebar, go the appropriate section below depending on if the "Tools" or the "Style Picker" tab is visible. 

#### Show/Hide the "Tools" tab (`⌘⌥⇧S`)

##### Reveal the "Tools" tab

To display the toolbar, do one of the following:

- From the menu, choose `View`→`Show Tools`
- Move the mouse cursor to the right side of the window, and if the "Style Picker" tab is visible, click on the "Sidebar Tab Switcher" button at the top of the "Style Picker" tab.
- Use keyboard shortcuts: `⌘⌥⇧S`

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

If the "Style Picker" bar is visible, you can also do the following:

- Click on the "Sidebar Tab Switcher" button at the top of the "Style Picker" bar.

##### Hide the "Tools" tab 

To manually hide the sidebar, if the "Tools" tab is visible

Do one of the following:

- From the menu, choose `View`→`Hide Tools`
- Use keyboard shortcuts: `⌘⌥⇧S`

#### Show/hide the "Style Picker" tab (`⌘⌥S`)

The "Style Picker" sidebar tab provides quick access to all available styles for a document and to select the style to apply to it.

##### Show the "Style Picker" tab

Do one of the following:
- From the menu, choose `View`→`Show Style Picker`
- Use keyboard shortcuts: `⌘⌥S`

If the sidebar is visible, you can also do the following:
- Click on the "Sidebar Tab Switcher" button at the top of the toolbar.

##### Hide the "Style Picker" tab

To manually hide the sidebar, if the "Style Picker" tab is visible

Do one of the following:

- From the menu, choose `View`→`Hide Style Picker`
- Use keyboard shortcuts: `⌘⌥S`

<h3 id="ui-styles-list">Styles List<h3>  

#### Show/Hide "Styles List" (`⇧⌘S`)

##### Display the "Styles List"

Do one of the following:

- From the sidebar "Tools" tab (see "Reveal the "Tools" tab section"), click on the "Styles" button which is represented by the symbol of the end of a brush.
- From the menu, choose `View`→`Styles`→`Show Styles`
- From the style editor panel, click on the `Styles` button
- Use keyboard shortcut: `⇧⌘S`


<h5 id="ui-styles-list-hide">Hide the "Styles List"</h5>

Do one of the following:

- On the  sidebar "Tools" tab, click on the "Styles" button
- From the menu, choose `View`→`Styles`→`Hide styles`
- Use keyboard shortcut: `⇧⌘S`


#### Select a style

When selecting a style, it becomes the new markdown text style. 

To select a style, do one of the following:

- From the "Style Picker" tab (see "Show "Style Picker" tab" section), just click on one the corresponding style preview icon.
- From the "Styles List" (see "Show "Styles List""), click on the corresponding style in the styles list.


#### Edit a style (`⇧⌘E`)

You can only edit a style if it is selected and the "Styles List" is visible (see "Show "Styles List"")

To edit a style, do one of the following:

- Click on the `Edit` button of the selected style
- From the menu, choose: `View`→`Styles`→`Edit Style`
- Use keyboard shortcut: `⇧⌘E`


#### Add a style (`⇧⌘A`)

To add a style, the "Styles List" must be visible (see "Display the list of styles")

To add a style, do one of the following:

- Click on the `Add` button in the title panel of the list of styles.
- From the menu, choose: `View`→`Styles`→`Add Style`
- Use keyboard shortcut: `⇧⌘A`


#### Delete a style (`⇧⌘D`)

To remove a style, the "Styles List" must be visible (see "Display the list of styles")

To remove a style, do one of the following:

- Click on the `Delete` button of the selected style
- From the menu, choose: `View`→`Styles`→`Delete a style`
- Use keyboard shortcut: `⇧⌘D`

#### Rename a style

To change the name of a style, do one of the following:

- From the style editing window, click on the style name, and edit the name.
- From the list of styles, click on the name of the selected style, and edit the name.

<h3 id="ui-style-editor">Style Editor<h3>  

#### Show/hide the "Issues" panel (`⇧⌘I`)

The problem panel shows the issues list associated with the edited CSS source. It can not be shown if there are no issue in the CSS source of the style. When the "Issues" panel becomes visible, all the CSS source issues are highlighted. When it becomes invisible, the style of the CSS source becomes normal again.

##### Show the "Issues" panel

To show the "Issues" panel, do one of the following:

- Click on the `Issues` button at the bottom right of the title panel.


##### Hide the "Issues" panel

When the "Issues" panel is hidden the edited style is

To hide the "Issues" panel, perform the following action:

- Click on the `Issues` button at the bottom right of the title panel.


#### Highlight an issue

When the "Issues" panel appears all the issues of the edited CSS source text are highlighted.

To highlight a single issue, perform the following action:

- Click on the isssue to highlight in the "Issues" panel.


#### Reveal all issues

If an issue is selected in the "Issues" panel, it is highlighted in the CSS source text.

To highlight all issues, perform the following action:

- Scroll the issues list up or down

#### Apply style pending changes (`⇧⌘C`)

Changes made when editing a style are not applied automatically for performance reasons but also because of the intermediate states between the desired style and the non-relevant editing steps leading to the desired output. For these reasons, the user must explicitely request the application of style pending changes. The `Apply` button (located at the top right of the CSS editor title panel of a style) makes it possible to apply any style pending changes. The `Apply` button will only be enabled if there are differences between the currently applied style and the edited style.

Note: The `Apply` button encompass the actions of updating the style and applying it to the markdown edited text. This means that the style previews of a style with pending changes, in the "Styles List" and in the sidebar "Style Picker" tab wont reflect the style pending changes.   

To apply pending changes, perform one of the following actions:

- From the CSS editor title panel of a style, click on the `Apply` button

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

<h2 id="markdown">Markdown</h2> 
<h3 id="md-description">Description</h3> 
{.test .class key=value}
Markdown is the lightweight markup language used in Stylo. It's a simple language that emphasizes readability and ease of use. Markdown exists in several versions but a version seems to make more and more consensus: CommonMark, and this is the version implemented by Stylo. For any questions regarding the Markdown syntax, the official site of [CommonMark](https://commonmark.org/) offers a complete [documentation](https://spec.commonmark.org) and a [test tool online](https://spec.commonmark.org/dingus/). 

{.test .class key=value}
Since CommonMark currently lacks some essential elements, some have been added to Stylo: striketrough and table. The GitHub flavored versions of these elements have been implemented. See the GitHub Markdown documentation for a complete reference: [GFM tables](https://help.github.com/articles/github-flavored-markdown/#tables) and 
[GFM strikethrough](https://help.github.com/articles/github-flavored-markdown/#strikethrough).

Markdown defines a non-intrusive syntax that allows to define HTML elements. As a last resort, since valid HTML code is interpreted as such by Markdown, it is still possible to use HTML in a Markdown document. It should be noted that there is no "invalid" Markdown. A text document is a valid Markdown document. If a tag is not recognized it will simply be interpreted as text.

{.test .class key=value}
Here is a simplified inventory of the main syntax rules in CommonMark and Stylo. Please refer to the [CommonMark Specification](https://spec.commonmark.org) and [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown) for more information.{.test .class key=value}

{.test .class key=value}
In Stylo, an element can also define one or more sub-regions that can be targeted by a pseudo-element (see <a href="#css-selector-pseudo-element">Pseudo-element</a>) selector section. For each element, the associated pseudo-elements will be listed in the section pertaining to the element in the subsection "Pseudo-elements".


<h3 id="md-html">HTML</h3>


In Stylo, CSS is used to stylize the Markdown text. Some Markdown elements have no correspondent HTML elements. In these cases, we defined new elements specific to Markdown: 

- `html-block`: An `html-block` defines any HTML block in a Markdown source. 
 
``` markdown 

# title level 1 
 
<p>A simple pragraph.</p>

```

In the last Markdown extract, the region delimited by `<p>` and `</p>` is an `html-block`. An it is possible to target this region directly in CSS. For example, to apply a red color to it: 

``` css
html-block {
	color: red;
}
```

- `reference`: A `reference` is used to create a label that represents an URI and that can be used in the links and images in a Markdown document to refer to these URI, see the <a href="#md-reference">Reference</a> section for a complete description. When converting a Markdown document to HTML, the links and images using reference are populated witht the real URI defined in the references and the references are removed since they are no longer needed. For example, we may style a reference with the blue color using the following CSS: 

``` css
reference {
	color: blue; 
}
```

Technical note: the namespace for these elements is defined as: `http: //net.daringfireball.markdown`.

<h3 id="md-headers">Headers</h3>   

#### Syntax

##### Header level 1 

A level 1 title can be written in two ways, with a number sign, as in the following example:

Markdown: 

``` markdown 
# title 1
```

or, with one or more `-` characters under a line of text, like the following: 

Markdown: 

``` markdown 
title 1
-------
```

{.test .class key=value}
Both are equivalent to the following HTML: 

HTML:

``` html
<h1>titre 1</h1>
```

##### Header level 2 

Markdown: 

``` markdown
## titre 2 

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

```
::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

HTML:

``` html
<h2>titre 2</h2>
```

As for the level 1 title, an "underlined" syntax exists for the level 2 title:

Markdown: 

``` markdown
Titre 2
--------------
```

HTML:

``` html
<h2>titre 2</h2>
```

##### Other levels 

The other levels are written with a number of dashs corresponding to the hearder level wanted:   

Markdown: 

``` markdown
### title 3
#### title 4
##### title 5
###### title 6
```

HTML:

``` html
<h3>titre 3</h3>
<h4>titre 4</h4>
<h5>titre 5</h5>
<h6>titre 6</h6>
```

#### Pseudo-elements  

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

All titles offer the following pseudo-element:

- `tag`: allows to stylize the region used to define the title, in the case of syntax with sharps, only sharps will be stylized, and in the case of the syntax "underlined", the underline bar will be stylized. For example, the following CSS will color the "tag" part of the "h1" elements with the red color:

``` css
h1::tag {
	color: red;
}
```

<h3 id="md-horizontal-bar">Horizontal Bar</h3>  

The horizontal bar is used to separate content or highlight content, such as a title. It is represented by a horizontal bar of the width of the document.

#### Syntax

Markdown: 

``` markdown 
---
```

or 

``` markdown  
***
```

HTML:

``` html 
<hr>
```

#### Pseudo-elements  

The horizontal bar offers the following pseudo-element:

- `tag`: allows to stylize the region used to define horizontal bar. 

<h4 id="md-emphasis">Emphasis</h4>  

There are two types of emphasis that correspond to the two HTML elements "strong" and "em". The `strong` element delimits important text and is usually stylized with bold text. The `em` element delimits emphased text and is usually stylized with italicized text.

#### Syntax

To emphasize a section of text, simply enclose it with an "*" (star) or an "_" (underscore):

Markdown:

``` markdown
*Emphasized text 1*
_Emphasized text 2_
```

HTML:

``` html 
<em>Emphasized text 1</em>
<em>Emphasized text 2</em>
```

{.test .class key=value}
To define an important section of text, simply enclose it with two "*" (star) or two "_" (underscore):

Markdown: 

``` markdown 
**important text**  
__important text__
```

HTML:

``` html
<strong>important text</strong>
<strong>important text</strong>
```            

#### Pseudo-elements  

The pseudo-elements offered by these two elements are:

- `tag`: covers the stars or underscores used to define the emphasis or important text on both sides of the text.

- `opening-tag`: covers the stars or underscores used to define the emphasis or important text at the beginning of the text.

- `closing-tag`: covers the stars or underscores used to define the emphasis or important text at the end of the text.

<h4 id="md-blockquote">Blockquote</h4>  

A quoted block, equivalent to the "blockquote" HTML element, is used to identify a quoted section of text from another source.

#### Syntax

Markdown: 

``` markdown 
> citation bloc    
citation  bloc
```

HTML:

``` html
<blockquote>
	<p>
		citation bloc<br>
		citation bloc
	</p>
</blockquote>
```

The quoted blocks can nest into each other:

Markdown:

``` markdown 
> citation bloc    
> > nested citation block
> > > second nested citation bloc
```

HTML:

``` html
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
```

#### Pseudo-elements  

There is one pseudo-element offered by this element:

- `tag`: covers the `>` (larger) signs used to define the quote blocks.

<h3 id="md-lists">Lists</h3>  

A list in Markdown, equivalent to the element "ul" or "ol", for "unordered list" and "ordered list", is a sequence of elements apartment to the same logical set. As in its HTML version, a list can be ordered or unordered.

#### Syntax

##### Unordered 

The `*`, `-` or the `+` can be used to create unordered lists. At the start of each line of a list, simply use the same marker for all list items inside one list. 

Markdown: 

``` markdown 
* list element
* list element
* list element
```
or 

``` markdown 
- list element
- list element
- list element
```
or 

``` markdown 
+ list element
+ list element
+ list element
```

HTML:

``` html
<ul>
	<li>list element</li>
	<li>list element</li>
	<li>list element</li>
</ul>
```

Using a different marker force to start a new list. 

Markdown:

``` markdown 
- item one
- item two
+ other list item one
+ other list item  two
```

HTML:

``` html 
<ul>
	<li>item one</li>
	<li>item two</li>
</ul>
<ul>
	<li>other list item one</li>
	<li>other list item two</li>
</ul>
```


##### Ordered   

The `<number>.` or the `<number>)` can be used to create ordered lists.

Markdown:

``` markdown 
1. first item  
2. second item 
3. third item 
```
or 

{.test .class key=value}
``` markdown {.test .class key=value}
1) first item  
2) second item 
3) third item 
```

HTML:

``` html 
<ol>
	<li>first item</li>
	<li>second item</li>
	<li>third item</li>
</ol>
```

We can also start the numbering at a specific value, as in the following example:

Markdown:

``` markdown 
57. item 57
1. item 58
```

HTML:

``` html 
<ol start="57">
	<li>item 57</li>
	<li>item 58</li>
</ol>
```


##### Nested 

To nest a list inside another list simply indent all items of the nested list by a minimum of two spaces from the start of the line of the nesting list. 

Markdown:

``` markdown 
- item one
- item two
  + nested list using two spaces after the start of nesting list  
  + nested sublist item 
    * another nested list started two spaces after the nesting list (four from the start)
    * antoher nested list
```

HTML:

``` html
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
	</li>{.
</ul>
```

#### Pseudo-elements  

In the case of lists, the list items are the elements that contain pseudo-element, and there is one:

- `tag`: covers the sign of the type of element (ordered or not).

In the previous example we could put "57." and "1." in red using the following CSS:

CSS: 

``` css
li::tag {
	color: blue;
}
```

or more specifically the elements of ordered lists:

CSS:

``` css
ol li::tag {
	color: blue;
}
```

<h3 id="md-code">Code</h3> 

An code element is any element that contains source code, generally for a programming language or a markup language. There are three types of Markdown code elements: "inline", "fenced" and "indented".

Elements of this type are used in Markdown to indicate that a text section is not part of the same syntactic space as the current document.

In the following example:

Markdown: 

``` markdown
# title
```

the title Markdown "# title" is not a title according to the current syntax space: it is in the block of code that contains it, but in the current document, it is a source code inside a block of code.

#### Syntax

##### Inline 

An inline code element is defined within a line and is delimited by two "`" grave accents, one at the beginning, and the other at the end of the text section that we want to define as a "code" element.

Markdown:

``` markdown
A line with `code`.
```

HTML:

``` html
<P>
	A line with <code> code </ code>.
</ P>
```

##### Fenced 

The fenced syntax is used to define a code element on several lines. It makes it possible to define the beginning of the code and the end on different lines. In this case, it will be necessary to use three grave accents side-by-side at the beginning of a line, optionally followed by a parameter, generally the name of the language used, and ended with three grave accents. All text between these two tags will be considered code. Here is an example:

Markdown: 

<pre><code>
func estEven(number: Int) -> Bool {
	return number%2 == 0 
}
</code></pre>

HTML:

``` html
<pre><code>func estEven(number: Int) -> Bool {
	return number%2 == 0 
}
</code></pre>
```

##### Indented 

A third alternative to defining a code section is the indented syntax. Just place 4 or more spaces at the beginning of each line of code, as below:

Markdown / HTML:

``` html 
<pre><code>
    // Comment
    line 1 of the code
    line 2 of the code
    line 3 of the code
</pre></code>
```

HTML:

``` html
<pre><code> // Comment
line 1 of the code
line 2 of the code
line 3 of the code </code> </pre>
```

{.test .class key=value}
#### Pseudo-elements  

It exits pseudo-elements for the inline code and the fenced code.

The inline code and the fenced code contains the following pseudo-elements:

- `tag`: defines the text of the opening and closing tags of the two code versions syntax: ```` ` ```` in the online code and <code>```</code> in the case of the closed code.

- `opening-tag`: the grave accents opening the code block.

- `closing-tag`: the grave accents closing the block of code.

And the fenced code also supports the pseudo-element:

- `params`: which contains the text portion of the parameters of the fenced code opening tag.

<h3 id="md-table">Table</h3>  

A table is used to tabulate information. It corresponds to the HTML element "table".

#### Syntax

Each row of a table starts at the beginning of a line and is indicated by a vertical bar: "| ". Each column is separated from the previous ones by a vertical bar, and the last column of a row ends with a vertical bar.

The first row is the title row. It allows to give a title to each of the columns of the table, the title of each column can be empty.

The second row is the separators row. It separates the titles row from the values rows. Each column of this row, like that of the titles, begins with a vertical bar, and the last column is terminated by a vertical bar. Each column must contain at least a hyphen "-". This dash may optionally be preceded or followed by a ":" colon to specify a left alignment of the corresponding column, or a right alignment, respectively. The absence of two-point signifies an alignment in the center.

Then come the values rows which follow the same pattern as the title row but contains the values ​​of each column.

Some examples:

A table with two centered columns and three rows of values:

Markdown: 

``` markdown
| Column 1 | Column 2 |
| - | - |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
```

HTML

``` html
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
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

A table with right-aligned columns:

Markdown: 

``` markdown
| Column 1 | Column 2 |
| ------:| -----------:|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
```

HTML:

``` html
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
```
{.test .class key=value}
A table with left-aligned columns:

Markdown: 

``` markdown 
| Column 1 | Column 2 |
| :------| :-----------|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
```

HTML:

``` html 
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
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

{.test .class key=value}
#### Pseudo-elements  

The `table` element supports the `tag` pseudo-element which contains all the vertical separators as well as the line separating the title row from the values rows. It can be used as follows:

``` css
table::tag {
	color: orange;
}
```

<h3 id="md-reference">Reference</h3>  

A reference takes the form: [\<reference label\>]: \<destination uri\> "\<title\>", where the \<reference label\> is the name of the reference used in links and images and the \<destination uri\>    is the target URI for this reference. It is possible to stylize a Markdown reference using the `reference` element. 


#### Syntax

An example of a reference to [textually](www.textually.net):

Markdown: 

``` markdown
[textually]: www.textually.net
```

and how it can be used in a link: 

``` markdown
This is a link to [textually][textually].
```

HTML: 

There is no corresponding HTML element for a reference.  

A reference can also have a title: 

Markdown: 

``` markdown
[textually]: www.textually.net "Textually website"
```

Note: A link or an image using an unexisting reference label, will be treated as text by Stylo. 


#### Pseudo-elements  


A reference has three pseudo-elements: 

- tag: The region with the start and end square braquet( "[", "]") and the colon.
- label: the part between the two square braquets.
- destination: the destination URI. 
- title: the reference title. 

<h3 id="md-link">Link</h3>  

A link is an element that allows you to insert a Unique Resource Identifier (URI), or more simply a unique resource locator (URL) to a resource on Internet. This element corresponds to the `a` (anchor) element of HTML.

#### Syntax

There are two main syntaxes for links, the difference being how to specify the URI: with or without reference. A reference (see the <a href="#md-reference">"Reference"</a> section for more information) is an identifier given to a URI and can be used instead of a URI in a link (or image). 

##### Without reference 

Markdown: 

``` markdown 
[Stylo](www.textually.net/stylo)
```
::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

HTML: 

``` html 
<p><a href="www.textually.net/stylo">Stylo</a></p>
```
or with a title: 

Markdown:

``` markdown 
[lien avec titre](www.textually.net/stylo "Stylo!")
```

HTML: 

``` html 
<p><a href="www.textually.net/stylo" title="Stylo!">lien avec titre</a></p>
```

##### With reference 

Markdown:

``` markdown
[link] [idStylo]

[idStylo]: www.textually.net/stylo
```

Note: If a non-existent reference is used in a link, it will be considered as text.

#### Pseudo-elements  

- tag: The region with the start and end square braquet( "[", "]") and the two parenthesis ("(", ")").
- text: the part between the two square braquets.
- destination: the destination URI if the link does not point to a reference. 
- label: the destination reference if the link points to a reference 
- title: the title of the link. 

<h3 id="md-image">Image</h3>  

An image element, corresponding to the `img` HTML element, is a reference to an image. 

#### Syntax

The only syntax difference with the link one, is the presence of an exclation mark `!` before the image link definition. 

Markdown:

``` markdown 
![Logo](www.textually.net/stylo/images/logo.png)
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

HTML:

``` html 
<p><img src="www.textually.net/stylo/images/logo.png" alt="Logo" /></p>
```
{.test .class key=value}
With a title: {.test .class key=value}

{.test .class key=value}
Markdown:

``` markdown 
![Logo](www.textually.net/stylo/images/logo.png "Logo")
```

HTML:

``` html 
<p><img src="www.textually.net/stylo/images/logo.png" alt="Logo" title="Logo" /></p>
```

Like the links, the images also have a syntax in reference format:

Markdown:

``` markdown
![alternative text][idImage]

[idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
```

HTML:

``` html 
<p><img src="http://www.textually.net/stylo/images/logo.png" alt="alternative text" title="Logo" /></p>
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

#### Pseudo-elements  

The same as the link element

<h2 id="html">HTML</h2>  


HTML is the main language of the Web. All pages visited by a browser are written in HTML.

<h3 id="html-document">Document</h3>


An HTML document is defined by a set of opening tags in the form "<element name> and closing tag that have the general form" </ element name>. "Each opening tag must be accompanied by a closing tag for the document to be considered valid An HTML document must begin with the document type tag, and must be followed by the opening tag "<html>" and end with the closing tag "</ html> ", these two tags create the" html "element.
 

Here is an example of an HTML document:

```html
<!doctype html>
	<html>
		<body>
		</body>
</html>
```

An HTML document contains elements that form a tree structure.

<h3 id="html-element">Element</h3> 

An element is the smallest unit of content in an HTML document. It defines content throughout the structure of the HTML document. As we have seen, an element is defined by an opening tag and a closing tag.

** The opening tag ** is the name of the element between chevrons. Here is for example the opening tag of the element named "html":

     <html>

** The closing tag ** consists of the name of the element preceded by the slash, all between chevrons. Here is for example the closing tag of the element named "html":

``` html
   </html>
```

Inline `<html>`

** The content ** of an element is everything between the opening tag and the closing tag of that element. Here is for example how to define a title element level 1 ("h1") with the content "A title":

``` html
    <h1> A title </h1>
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

Here is an example of an HTML document with content:


``` html
<!doctype html>
<html>
	<body>
		<h1> Title 1 </h1>
		<h2> Title 2 </h2>
		<p>Content of the first paragraph </p>
	</body>
</html>
```

{.test .class key=value}
The previous document contains five elements: html, body, h1, h2 and p.
{.test .class key=value}
1. html: the root element of the html document
2. body: The "body" element contains all the contents of the document.
3. h1: an element that defines a level 1 title
4. h2: an element that defines a level 2 title
5. p: an element that defines a paragraph

{.test .class key=value}
<h3 id="html-definitions">Definitions</h3> 


The **parent element** of an element is the element on top of that element, that is, the closest element that contains it. In the previous document, "html" is the parent of "body", and "body" is the parent of "h1", "h2", and "p". Each element can have only 1 parent element or 0 in the case of the root element which is the "html" element.


The **ascendant element** of a current element is an element that contains the current element either directly (as the parent) or indirectly, which is the ascendant of the parent of an element. In the previous document, the "html" element is the ascendant of all the elements of the document except for itself, the "body" element is the ascendant (and the parent) of the elements: "h1", " h2 "and" p ".


A **child element** of a current element is an element that is directly below the current element. The element whose child is the current element is also the parent of this element. For example, in the previous document, the "body" element is the child of the "html" element, and the "h1" element is the child of the "body" element.


A **descendant element** of a current element is either the child of that element, or a descendant of a child of that element. For example, in the previous document, the element "p" is the descendant of the elements: "body" and "html".


The **next neighbor** of a current element is the element that shares the same parent as the current element and is directly after the current element. For example, in the previous document, the element "p" is the next neighbor of the element "h2" and the element "h2" is in turn the next neighbor of the element "h1".


A **following neighbor** of a current element is an element that shares the same parent as the current element and is found after the current element. For example, in the previous document, the element "p" is the next neighbor of elements "h2" and "h1".


Now that we have covered a few definitions, we can dwell on an element in itself.

An element can have an "id", classes ("class") and / or attributes. CommonMark does not allow for the moment to define these properties on an element, so we will only have a quick overview of the issue.


<h3 id="html-attributes">Attributes</h3>


An element can have multiple attributes. An attribute has a name and a value. The name of an attribute must always be separated from the element name by at least one space. The value of an attribute is defined by following the name of the attribute with the sign "=" and then the value itself enclosed in quotation marks ("). In the following example we give an attribute to the attribute. 'element' h1 ':

``` html
<h1 valid="true">title 1</h1>
```

Two attribute names are reserved and have special meaning in HTML, "id" and "class".

<h3 id="html-id">Id</h3>

An "id" is a unique identifier, in the context of a document, given to an element. To give an "id" to an element, it suffices An "id" For example, in the following document, the element "h1" has the id "title":

``` html
<!doctype html>
<html>
	<body>
		<h1 id="my-first-title">Title 1</h1>
		<h2>Title 2</h2>
	</body>
</html>
```
::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

<h3 id="html-class">Class</h3>


A class groups a set of items under a name. It will later be possible to refer to these elements using the name of the class. To assign an element to a class, just set the class attribute for the element and add the class name to the attribute value. Here is an example that assigns the "title" class to "h1" and "h2" elements:

``` html
<!doctype html>
<html>
	<body>
		<h1 id="my-first-title" class="title">Title 1</h1>
		<h2 class="title">Title 2</h2>
	</body>
</html>
```

Note that it is possible to assign multiple classes to an element using the same "class" attribute and adding the names of all classes in the element separated by a space. For example, in the following document we assign the classes "title" and "other-classes" to the element "h2".

``` html
<!doctype html>
<html>
	<body>
		<h1 id="my-first-title" class="title">Title 1</h1>
		<h2 class="other-class title">Title 2</h2>
	</body>
</html>
```


<h2 id="css">CSS</h2> 

CSS is a language that defines a style. The language used mostly for styling HTML pages. The language is huge and supports an immeasurable number of functions and properties.

The CSS version of Stylo is a "standard conforming" lightweight version of CSS that retains original language elements useful in the context of editing a text in Markdown format and adds some other elements necessary to complete the language and adapt it to Markdown.

All rules defined by CSS are respected, only the available properties change in the Markdown version of CSS. In order to lighten the presentation, we will consider only the case of use inside Stylo.

<h3 id="css-style">Style</h3> 


A style is a set of properties with values. A style is always associated with a selector that allows you to specify the elements to which the style will apply. For example:

```
body {
	color: red;
}
```

{.test .class key=value}
In this example `body` is the selector. It specifies that the elements to which the properties defined in the style can be applied must be named "body". In the previous example, the style defines a single `color` (color) property and sets it to` red` (red).

It is possible to add the qualifier "! Important" after the value of a property in order to increase its priority compared to the other values ​​assigned to this property (see "Priority rules" below). Here is the same example that uses "! Important":

``` css
body {
	color: red! important;
}
```

{.test .class key=value}
_Note_: In Stylo, only a few properties are supported. For a complete list of supported properties and their function, see the "Properties" section.


<h3 id="css-selector">Selector</h3>


A selector makes it possible to specify the criteria of selection of the elements to which will be attributed the style which follows it. There are several different selectors:

- the selector by type
- the selector by "id"
- the class selector ("class")
- the attribute selector
- the pseudo selector

#### Selectors
 
##### Type selector

The selector by type selects an element according to the name of the element. For example, in the following HTML file:
 
``` html
<html>
	<body>
		<h1>Title 1</h1>
		<h2>Title 2</h2>
	</body>
</html>
```

it is possible to assign the red color to the element "h2" using the selector and the style:


``` css
h2 {
	color: red; 
}
```
{.test .class key=value}

_Note_: In Stylo, this will be th{.test .class key=value}e main selector used mainly because of the impossibility of assigning attributes to an element through the Markdown syntax.

##### Id selector 


The "id" selector allows to select an element according to the "id" of an element. It takes the general form of the square followed by the name of the element: "#<id of the element>". For example, in the following HTML file:

``` html
<!doctype html>
<html>
	<body>
		<h1 id="my-first-title">Title 1</h1>
		<h2>Title 2</h2>
	</body>
</html>
```

it is possible to assign the red color to the element "h1" using the selector and the style:

``` css
#my-first-title {
	color: red;
}
```

##### Class selector 

The class selector lets you select an element based on the value of the "class" attribute of an element. It takes the general form of the dot followed by the name of the element: ". <Element class>". For example, in the following HTML file:

``` html
<!doctype html>
<html>
	<body>
		<h1 id="my-first-title" class="title">Title 1</h1>
		<h2 class="other-class title">Title 2</h2>
	</body>
</html>
```

it is possible to assign the red color to the element "h2" using the selector and the style:

``` css
.title {
	color: red;
}
```

##### Universal selector 

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

The universal selector is used to select all the elements of the document. It takes the form of a star: "*". It can be placed at any position of a selector.

``` html
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
```

{.test .class key=value}
we could apply the red color to all elements with the following selector:

``` css
* {
	color: red;
}
```

It should be noted that we could have achieved the same effect by choosing the body element since all the visible elements are below it.

``` css
body {
	color: red;
}
```

The difference between the two will not be important in most cases, but for performance reasons it is better to avoid the use of the universal selector.


##### Attribute selector 

The attribute selector lets you select an element based on the presence or value of any attribute in an element. It takes the general form of the name of the attribute optionally followed by a "text selection expression" (explained below) and the partial or complete value of the attribute, all placed between an opening hook "[" and a closing hook "]".

Note: It is possible to use the attribute selector to select attributes "id" or "class" which are only special attributes for HTML but attributes like the others from the point of view of the selector by CSS attribute.

###### Attribute existence 


The attribute selector allows you to select an element based on the existence of an attribute for that element. Just place the name of the attribute in square brackets. In the case of the following HTML source:

``` html
<!doctype html>
<html>
	<body>
		<h1 author="john">Title 1</h1>
		<h2 class="other-class title">Title 2</h2>
	</body>
</html>
```


it is possible to assign the red color to the element "h1" using the selector and the style:

```css
[author] {
	color: red;
}
```

Here, we use the attribute selector to select all the elements that have the "author" attribute set, regardless of the value of it.

###### Attribute value 


The attribute value selector selects an element based on the value of an attribute for that element. Just place the name of the attribute in brackets, followed by the "text selection expression" that we have already mentioned, followed by a string of characters. There are four different selector values:

__[attribute="value"]__ allows you to select the elements whose value of attribute "attribute" is equal to "value". For example, in the following HTML source:


``` html
<!doctype html>
<html>
	<body>
		<h1 author="john">Title 1</h1>
		<h2 class="title other-classe">Title 2</h2>
	</body>
</html>
```

It would be possible to select the element "h1" using the following selector:

``` css
[author="john"] {
	...
}
```

__[attribute~="value"]__ allows you to select elements whose value of the "attribute" attribute contains the value "value". As mentioned above, an attribute can contain a list of values ​​separated by a space, for example:

``` html
<h1 authors="john marc">Title 1</h1>
```

With the attribute selector below, we could select the "h1" element with the following CSS:

``` css
[authors~="marc"] {
	...
}
```

__[attribute|="value"]__ selects items whose attribute value starts with the value "value". The value must be an entire word, alone or followed by a hyphen "-" For example, in the following HTML source:

``` html
<h1 authors="john marc">Title 1</h1>
```


With the attribute selector below, we could select the "h1" element with the following CSS:

``` css
[authors|="john"] {
	...
}
```


__[attribute^="value"]__ allows you to select the elements whose value of the attribute "attribute" begins with the value "value". Unlike the previous selector, the value does not have to be an integer word. For example, in the following HTML source:

```html
<h1 authors="john marc">Title 1</h1>
```

With the attribute selector below, we could select the "h1" element with the following CSS:

``` css
[authors^="jo"] {
	...
}
```

{.test .class key=value}
__[attribute$="value"]__ selects the elements whose value of attribute "attribute" ends with value "value". Here, the value does not have to be an entire word. For example, in the following HTML source:

``` html
<h1 authors="john marc">Title 1</h1>
```

With the attribute selector below, we could select the "h1" element with the following CSS:

``` css
[authors$="arc"] {
	...
}
```

__[attribute*="value"]__ allows you to select the elements whose value of the "attribute" attribute contains the value "value". Here again, the value does not have to be an entire word. For example, in the following HTML source:

``` html
<h1 authors="john marc">Title 1</h1>
```

With the attribute selector below, we could select the "h1" element with the following CSS:

``` css
[authors$="my"] {
	...
}
```

<h5 id="css-selector-pseudo-element">Pseudo-element selector</h5>


A pseudo-element is an element that is not part of the element tree of the document. Stylo, add a number of these pseudo-elements so that you can stylize the Markdown source more accurately. For example, Stylo introduces the little tag element (tag). For example, in Markdown we define a level 2 title as follows:

Markdown: 

``` markdown
## title level 2
```

The text "##" is the tag, or the label of the element. The pseudo tag element selector allows you to select only the tag of the element "h2" in the Markdown source. In Stylo, several pseudo-elements exist, for a complete list see below the section "Selectors".

The pseudo-element selector is introduced by two "colon" after the selector of an element and is followed by the name of the pseudo-element, for example:

``` css
h1::tag {
	...
}
```

to select the "tag" of a level 1 title element.


###### Several pseudo-elements of the same type


If a pseudo-element is defined several times for the same element, the one with the highest specificity will be the one that will be applied, and in case of equality, the last one encountered in the style sheet will be preserved.

###### Coverage of pseudo-elements

Regardless of the order of the pseudo-elements, those that contain others are always applied first, for example, with the following CSS:

``` css
em::opening-tag {
	color: red;
}

em::tag {
	color: blue;
}
```

{.test .class key=value}
the first tag of the element "em" will be red even if the following pseudo-element, which contains it, comes after, and defines it as blue.

In the case where several pseudo-elements of different types apply to the same text region, the one with the highest specificity, or in case of equality, the one that comes after, will apply.

##### Pseudo-class selector 

For the moment, no pseudo class selector is supported in Stylo.


#### Combinators 


A selector combinator allows you to combine multiple selectors into one by defining the relationship between the elements. A selector is evaluated from left to right. It exits several combiners of selectors.

Note: It may be helpful to re-read the "definitions" section of the "Element" section for a reminder of the main concepts used here.

All examples use the following HTML document:

``` html
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
```

__descendant__ is used to select the descendants of an element. A descendant selector combiner is represented by a space ('') between the selectors. For example, to select all descendent level 2 titles of the body element, the following CSS can be used:

``` css
body h2 {
	...
}
```


In this example, the two "h2" elements of the HTML document are selected.

__child__ is used to select the children of an element. A child selector combiner is represented by a larger ">" sign between the selectors. For example, to select all level 2 titles that are children of the body element, the following CSS can be used:
   
``` css
body > h2 {
	...
}
```

In this example, only the "h2" element under the "body" element of the HTML document is selected, the one with the text: "title 2". The one under the "p" element is not selected.

__general sibling selector__ selects the elements that follow an element. A combinator of "next" type selectors is represented by the sign "~" between the selectors. In the HTML of the previous document, we could use a "next" type selector to select the "h1" and "p" elements as follows:

``` css
h1 ~ * {
	...
}
```

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

__adjacent sibling selector__ selects the next element directly after an element. A "next neighbor" type selectors combiner is represented by the "+" sign between the selectors. In the HTML of the previous document, we could use a "next" type selector to select the element "h2" under the first "h1" as follows:

``` css
h1 + h2 {
	...
}
```


<h3 id="css-stylesheet">Stylesheet</h3>

A stylesheet is a set of styles with their associated selector. It allows to group together styles.

A style sheet can come from three different origins:

1. User Agent: This will be the browser in most cases, but Stylo in the case of this editor.
2. Author: style sheets edited by the user.
3. User: The style sheet that the user, usually a browser, can edit.

Of these three types of style sheets, only the second is available for editing. The "User" sheet does not exist in Stylo since access is given to all the power of CSS directly through the "Author" style sheet.


{.test .class key=value}
<h3 id="css-cascading">Cascading</h3> 


The purpose of the cascade process is to assign a value to all the properties supported by each element for all elements.

An element can get a particular value for a property in three ways:

1. One or more styles exist for this element that define a value for this property.
2. An element "ancestor" of the element defines a value for this property.
3. The property sets a default value.


If all properties have a value, the process stops here. Otherwise, for the values ​​that support the inheritance, we will get the values ​​to assign to the properties without values ​​in the ancestors of this element. If an ancestor sets a value for the property, the value will be assigned. For the remaining properties, the default values ​​defined by the properties themselves will be used.

This is the cascade process!


<h3 id="css-priority-rules">Priority rules</h3> 


We mentioned that when more than one style applicable to an element defines a value for a property, a priority system is applied to determine the value that will be selected.

When more than one style applies to an element and these styles define values ​​for the same property, a selection process must be applied to determine which style to choose. Here is, in ascending order, the priority assigned to each property:

1. user agent style
2. user styles
3. author's styles
4. Important styles of the author (marked with "! Important")
5. important user's systems

As a result of this prioritization process, it is possible for two properties to have the same priority. In this case, a pointing system is used which will depend on the selector


Note: for a full/alternative explanation of CSS priority rules and cascading process: [OpenWeb Cascade CSS](https://openweb.eu.org/articles/cascade_css).

<h3 id="css-properties">Properties</h3> 


Currently, Stylo supports the following properties:

{.test .class key=value}
- color
- background-color
- font-size
- font-family
- font-weight
- font-style
- text-decoration-style
- text-decoration-line
- text-decoration-color

To define a property, you must give the name of the property, followed by the dexu-points, followed by the property value and finally end the whole thing with a semicolon. A property therefore takes the following general form:

``` css
<property name>: <property value>;
```

#### color 


The property "color" makes it possible to attribute a color to an element, in the Stylo it is about the color of the text.

Formal definition: `color: color | initial | inherit;`


#### background-color 


The "background-color" property allows you to assign a color to the "background" of an element.

Formal definition: `background-color: color | initial | inherit;`

The values ​​that this property can take are the same as for the "color" property.

Note: Stylo, for performance reasons, does not support an alpha value other than 1 for the background-color property of the "body" element of a Markdown document.


#### font-size


The font-size property allows you to assign a size to a font. It is advisable to use the relative sizes in that they adapt to all devices and the design will be more adaptable. The Stylo agent style sheet uses them, see the "Appendix" section: "Stylo Agent Style Sheet".

Formal definition: `font-size: medium | xx-small | x-small | small | large | x-large | xx-large | smaller | larger | length |% | initial | inherit;`

##### Keyword

absolutes:

All these sizes are based on the `medium` size which is set to 16px in Stylo.

| Keyword | Value |
| ----- | ------ |
| xx-small | 9.6px |
| x-small | 12px |
| medium | 16 px |
| wide | 19.2px |
| x-large | 24px |
| xx-large | 32px |


relatives:

The size is based on the size of the parent element.

| Keyword | Value |
| ----- | ------ |
| smaller | 2/3 of the inherited value |
| larger | 3/2 of the inherited value |

##### length

{.test .class key=value}
The cut is expressed in units of length, the most commonly used being "px" for "pixels".

``` css
body {
	font-size: 16px;
}
```


For a complete list of length units supported by Stylo, see the section "length" in "Type of values".


##### percentage 


A percentage value, calculated from the value of this property for the parent element, for example:

``` css
body {
	font-size: 16px;
}
h1 {
	font-size: 80%;
}
```


In the following document:

``` html
<!doctype html>
<html>
	<body>
		<h1>Title 1</h1>
	</body>
</html>
```

The size of the font of element "h1" would be 0.8 x 16 = 12.8


Note: The sizes in Stylo are specified according to the size of the "viewport" with the unit,


#### font-family



The "font-family" property is used to specify the font of an element.

Formal definition: `font-family: family-name | generic-family | initial | inherit;`

To set the value of this property, we can use a comma-separated, prioritized list of specific or generic font names, or one of the "initial" or "inherit" values, used alone.

To define a sans-serif font for the element "h1" we could use the following CSS:

``` css
h1 {
	font-family: Arial, sans-serif;
}
```

For a complete list of font names see the appendix, section "Font Names."

##### Generic font names 

Here is the list of generic fonts:

| Generic font name |
| ------ |
|serif|
|sans-serif|
|cursive|
|fantasy|   
|monospace|


#### font-weight 

The property "font-weight" allows to assign a thickness to a font, ranging from very thin to bold. All values ​​are converted into one of the following numbers: 100, 200, 300, 400, 500, 600, 700, 800, 900 ranging from the thinnest (100) to the highest (900). The value 400 is equivalent to normal and the value 700 is equivalent to bold.

Formal definition: `font-weight: normal | bold | bolder | lighter | number | initial | inherit;`

The two keywords "lighter" and "bolder" define the value of the thickness of the current font relative to the inherited thickness.

{.test .class key=value}
In the following example, give the value "bold" for elements of type "h1":


``` css 
h1 {
	font-weight: bold; 
}
```  

#### font-style 

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

The "font-style" property allows you to define the style of the font, it admits three different values ​​(besides "initial" and "inherit"): normal, italic or oblique. It should be noted that in Stylo, the values ​​"italic" and "oblique" are the same style: "italic".

Formal definition: `font-style: normal | italic | oblique | initial | inherit;`

In the following example, give the value "italic" for elements of type "h1":

``` css 
h1 {
	font-style: italic; 
}
```  

#### text-decoration-line 


This property allows you to specify a type of decoration to use. There are four types of decorations: "none" the default, that is to say there is no decoration; "Underline", we emphasize the elements; "Overline", a line is placed above the elements; "Line-through", a line runs through the elements.

Formal definition: `text-decoration-line: none | underline | overline | line-through | initial | inherit;`

It is possible to use several lines at a time, for example:

``` css
h1 {
	text-decoration-line: overline, underline; 
}	
```

allows to decorate elements of type "h1" with a line above and a line below.


#### text-decoration-style

This property is used in conjunction with the property "text-decoration-line" and allows to assign a style to the lines.

Formal definition: `text-decoration-style: solid | double | dotted | dashed | wavy | initial | inherit;`

The default value is "solid" which gives a "full" style to the line; the "double" style doubles the line; the dotted style gives a dotted line; the "dashed" style gives a dotted line but replaces the dots with dashes; finally, the "wavy" style gives a wave shape to the line.


#### text-decoration-color

This property is used in conjunction with the property "text-decoration-line" and allows to assign a color to the lines.

The values ​​that this property can take are the same as for the "color" property.

Formal definition: `text-decoration-color: color | initial | inherit;`

{.test .class key=value}
For example to emphasize with a double line of red color elements of type "h1", we could use the following CSS:

``` css 
h1 {
	text-decoration-line: underline; 
	text-decoration-style: double;
	text-decoration-color: red; 
}
``` 


<h3 id="css-property-values">Property values types</h3> 

#### initial 

#### inherit 

#### length 


The type "length" in CSS defines a length. The value is mainly used in Stylo to assign a value to the "font-size" property.

The syntax of "length" is a decimal number followed by a unit.

##### Units relative to the font size 

###### em 


The "calculated" value (in the CSS sense, "which is obtained after cascading") of the current element. The number before this value determines the multiplier applied to this value. For example:

``` css 
body {
	font-size: 10px;
}
h1 {
	font-size: 1.2em; 
}
```

In the following document: 


``` html
<!doctype html>
<html>
	<body>
		<h1>title 1</h1> 
	</body>
</html>
```


We get: 1.2 x 10 = 12px.

###### ex 

The value is calculated from the value "[x-height](https://en.wikipedia.org/wiki/X-height)" of the current font. As in the case of "em" we prefix the unit of the multiplier to apply to it.

###### ch 

Value relative to the width of the "0" in the current font.

###### rem 

Value relative to the font size of the root element.

##### Units relative to viewport size 


The "viewport" in Stylo is the screen. And all the values ​​related to the viewport are calculated according to the size of the screen.

###### vw

Value equivalent to 1% of the width of the viewport.

###### vh

Value equivalent to 1% of the height of the viewport.

###### vmin

Value equivalent to 1% of the smallest dimension of the viewport.

###### vmax

Value equivalent to 1% of the largest dimension of the viewport.


##### Absolute units 

{.test .class key=value}
Absolute units are based on units of known length.

| Unit | Description |
| ----- | -------- |
| Cm | centimeters |
| Mm | millimeters |
| In | inches (1in = 96px = 2.54cm) 
|px | pixels (1px = 1 / 96th of 1in)|
| Pt | points (1pt = 1/72 of 1in) |
| Pc | picas (1pc = 12 pt) | 

::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

#### color 


In Stylo, the value of a color is ultimately represented by four components between 0 and 1: red, green, blue, and transparency (alpha). The value 0 for a color component means its absence, the value 1 that the component is represented completely and the intermediate values ​​determine the different variants in the presence of the component. In the case of transparency, the value 0 means that the color is completely transparent and the value 1, that it is completely opaque.

To get pure red, we will have: red: 1, green: 0, blue: 0, alpha: 0; white 1,1,1,1 and black: 0,0,0,1. All shades of pure gray use the three components present in equal amounts, for example, a dark gray could be obtained with the components: 0.8,0,8,0,8,1.

##### rgb

{.test .class key=value}
The `rgb (<red>, <green>, <blue>)` function allows you to define a color by passing the value of the three color components with a number between 0 and 255 for each component. This number is ultimately divided by 255 to get a value between 0 and 1 as mentioned previously. The alpha value will always be set to 1 by default.

For example, to assign the red color to the "color" property of elements of type "h1" of a document, we could use:

``` css
h1 {
	color: rgb(255, 0,0);
}
```


Here, the rgb function was used with the "red" component at its maximum value of 255 (255/255 = 1, therefore 1) and the green and blue components are not present.



##### rgba

The function `rgba (<red>, <green>, <blue>, <alpha>)` allows, like the function rgb, to define a color according to the three fundamental components with a value between 0 and 255, but allows in more, specify the value of the alpha.

For example, to assign the red color with an alpha of 0.5 to the "color" property of the "h1" elements of a document, we could use:

``` css
h1 {
	color: rgba(255, 0.0, 0.5);
}
```

##### hexadecimal


The hexadecimal value is one of the ways to represent the red, green, and blue components of a color. A value in hexadecimal is introduced by the character "#" and followed by the hexadecimal characters of the value. Valid hexadecimal characters are: 0,1,2,3,4,5,6,7,8,9, a, b, c, d, e, f. For example, "#F00" represents the red color with an alpha to 1. 

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


_Note_: The hexadecimal value is case insensitive. 



As a decimal value, for which each position represents a power of 10, in hexadecimal, each position represents a power of 16.

For example, the number 28 in decimal is:

2x10 ^ 1 + 8 x10 ^ 0 = 20 + 8 = 28

The same number in hexadecimal is written as "1c" ("c" is 12):

1x16 ^ 1 + 12x16 ^ 0 = 16 + 12 = 28


For a full explanation of the hexadecimal charatcteres, see the article on [wikipedia](https://en.wikipedia.org/wiki/Hex_System_Exad).
 
It is possible to express a color in hexadecimal with values ​​of several lengths, each length having its own interpretation.

1. three hexadecimal characters 

With a value of length 3, from left to right, the first character represents the red component, the second component, the green component, the third, the blue component. To get the value of each component, CSS doubles the character. Thus, for the value #abc, the value used will be: #aabbcc, the characters "aa" for the red component, the "bb" charatcères for the green component and finally, the "cc" characters for the blue component. The range of values ​​thus ranges from 0 (0x16 ^ 1 + 0x16 ^ 0 = 16 + 12 = 0) to 255 (15x16 ^ 1 + 15x16 ^ 0 = 240 + 15 = 255). The value of the alpha (as in the rgb function mentioned above) will always be equal to 1.


For example, we could set the color red, for a level 1 title:

``` css
h1 {
	color: #F00;
}
```


Which gives with doubled values: # FF0000, and therefore, a value of 255 for the red component, 0 for the green component, 0 for the blue component, and 1 for the alpha, by default.

2. four hexadecimal characters 


The interpretation remains the same with four characters, all the values ​​are doubled and the components remain the same for the first six characters. The only difference is that the last two characters are used to specify the "alpha value" of the color. This value is divided by 255 to obtain a value between 0 and 1.

To define, the red color with an alpha of 0.53 we will have:

``` css
h1 {
	color: #F008;
}
```
::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

3. six hexadecimal characters 


We find ourselves in the same case with three characters, except that the values ​​will not be doubled.

To obtain the pure blue color, we will use:

``` css
h1 {
	color: #00F;
}
```

4. height hexadecimal characters


We find ourselves this time in the same case with four characters, except that the values ​​are not doubled: we can completely define with a hexadecimal code 8 character one color, including its alpha value. For a green with alpha at 0.47:

``` css
h1 {
	color: #00FF0078;
}
```


Calculation for the alpha value gives: 7x16 ^ 1 + 8x16 ^ 0 = 112 + 8 = 120 -> 120/255 = 0.47.


##### keyword


Stylo supports all keywords supported by CSS. For a complete list of keywords see [w3school](https://www.w3schools.com/colors/colors_names.asp).

To assign the red color to the "color" property of elements of type "h1" we could use the following CSS:

``` css
h1 {
	color: red;
}
```

Keywords allow quick access to the main colors in CSS. See the full list of Stylo keywords supported by the appendix. TODO 

{.test .class key=value}
<h2 id="appendix">Appendix</h2>  

<h3 id="appendix-font-keywords">Fonts keywords</h3> 

|Font keyword|
|-----|
|Al Bayan|
|Al Nile|
|Al Tarikh|
|American Typewriter|
|Andale Mono|
|Arial|
|Arial Black|
|Arial Hebrew|
|Arial Hebrew Scholar|
|Arial Narrow|
|Arial Rounded MT Bold|
|Arial Unicode MS|
|Athelas|
|Avenir|
|Avenir Next|
|Avenir Next Condensed|
|Ayuthaya|
|Baghdad|
|Bangla MN|
|Bangla Sangam MN|
|Baoli SC|
|Baskerville|
|Beirut|
|Big Caslon|
|Bodoni 72|
|Bodoni 72 Oldstyle|
|Bodoni 72 Smallcaps|
|Bodoni Ornaments|
|Bradley Hand|
|Brush Script MT|
|Chalkboard|
|Chalkboard SE|
|Chalkduster|
|Charter|
|Cochin|
|Comic Sans MS|
|Copperplate|
|Corsiva Hebrew|
|Courier|
|Courier New|
|Damascus|
|DecoType Naskh|
|Devanagari MT|
|Devanagari Sangam MN|
|Didot|
|DIN Alternate|
|DIN Condensed|
|Diwan Kufi|
|Diwan Thuluth|
|Euphemia UCAS|
|Farah|
|Farisi|
|Futura|
|GB18030 Bitmap|
|Geeza Pro|
|Geneva|
|Georgia|
|Gill Sans|
|Gujarati MT|
|Gujarati Sangam MN|
|GungSeo|
|Gurmukhi MN|
|Gurmukhi MT|
|Gurmukhi Sangam MN|
|Hannotate SC|
|Hannotate TC|
|HanziPen SC|
|HanziPen TC|
|HeadLineA|
|Heiti SC|
|Heiti TC|
|Helvetica|
|Helvetica Neue|
|Herculanum|
|Hiragino Kaku Gothic Pro|
|Hiragino Kaku Gothic ProN|
|Hiragino Kaku Gothic Std|
|Hiragino Kaku Gothic StdN|
|Hiragino Maru Gothic Pro|
|Hiragino Maru Gothic ProN|
|Hiragino Mincho Pro|
|Hiragino Mincho ProN|
|Hiragino Sans GB|
|Hoefler Text|
|Impact|
|InaiMathi|
|Iowan Old Style|
|ITF Devanagari|
|Kailasa|
|Kaiti SC|
|Kaiti TC|
|Kannada MN|
|Kannada Sangam MN|
|Kefa|
|Khmer MN|
|Khmer Sangam MN|
|Kohinoor Devanagari|
|Kokonor|
|Krungthep|
|KufiStandardGK|
|Lantinghei SC|
|Lantinghei TC|
|Lao MN|
|Lao Sangam MN|
|Libian SC|
|LiHei Pro|
|LiSong Pro|
|Lucida Grande|
|Luminari|
|Malayalam MN|
|Malayalam Sangam MN|
|Marion|
|Marker Felt|
|Menlo|
|Microsoft Sans Serif|
|Mishafi|
|Mishafi Gold|
|Monaco|
|Mshtakan|
|Muna|
|Myanmar MN|
|Myanmar Sangam MN|
|Myriad Pro|
|Nadeem|
|Nanum Brush Script|
|Nanum Gothic|
|Nanum Myeongjo|
|Nanum Pen Script|
|New Peninim MT|
|Noteworthy|
|Optima|
|Oriya MN|
|Oriya Sangam MN|
|Osaka|
|Palatino|
|Papyrus|
|PCMyungjo|
|Phosphate|
|PilGi|
|Plantagenet Cherokee|
|PT Mono|
|PT Sans|
|PT Sans Caption|
|PT Sans Narrow|
|PT Serif|
|PT Serif Caption|
|Raanana|
|Sana|
|Sathu|
|Savoye LET|
|Seravek|
|Shree Devanagari 714|
|SignPainter|
|Silom|
|Sinhala MN|
|Sinhala Sangam MN|
|Skia|
|Snell Roundhand|
|Songti SC|
|Songti TC|
|STFangsong|
|STHeiti|
|STIXGeneral|
|STIXIntegralsD|
|STIXIntegralsSm|
|STIXIntegralsUp|
|STIXIntegralsUpD|
|STIXIntegralsUpSm|
|STIXNonUnicode|
|STIXSizeFiveSym|
|STIXSizeFourSym|
|STIXSizeOneSym|
|STIXSizeThreeSym|
|STIXSizeTwoSym|
|STIXVariants|
|STKaiti|
|STSong|
|Sukhumvit Set|
|Superclarendon|
|Symbol|
|Tahoma|
|Tamil MN|
|Tamil Sangam MN|
|Telugu MN|
|Telugu Sangam MN|
|Thonburi|
|Times|
|Times New Roman|
|Trattatello|
|Trebuchet MS|
|Verdana|
|Waseem|
|Wawati SC|
|Wawati TC|
|Webdings|
|Weibei SC|
|Weibei TC|
|Wingdings|
|Wingdings 2|
|Wingdings 3|
|Xingkai SC|
|Yuanti SC|
|YuGothic|
|YuMincho|
|Yuppy SC|
|Yuppy TC|
|Zapf Dingbats|
|Zapfino|
|Apple Braille|
|Apple Chancery|
|Apple Color Emoji|
|Apple SD Gothic Neo|
|Apple Symbols|
|AppleGothic|
|AppleMyungjo|

<h3 id="appendix-color-keywords">Color keywords</h3>
  
| keyword | rgb value |
|--------|-----------|
|black                   | rgb(0,0,0)|
|blanchedalmond | rgb(255,235,205)|
|transparent       | rgb(0,0,0,0)|
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

<h3 id="appendix-markdown-elements">Markdown elements</h3>

- html-block 
- reference 


<h3 id="appendix-keyboard-shortcuts">Keyboard shortcuts</h3>

#### Actions 

##### Sidebar

- Reveal the "Tools" tab of the sidebar: `⌘⌥S`
- Reveal the "Style Picker" tab of the sidebar: `⌘⌥⇧S`

##### Styles 

- Reveal/hide the "Styles List" : `⌘⇧S`
- Add a style: `⌘⇧A`
- Delete a style: `⌘⇧D`
- Edit a style: `⌘⇧E`

##### Style 

- Reveal / Hide Issue List: `⇧⌘I`
- Apply pending changes: `⇧⌘C`

##### Preview 

- Reveal/hide preview: `⌘R`

#### Mardown Editing  

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


<h3 id="appendix-markdown-ua-stylesheet">Markdown user-agent stylesheet</h3>

 
``` css
html {
    font-size: 1.2vw;
}

body {
    
    font-family: monospace;
    color: black;
}

h1 {
    
    font-size: 2.0rem;
    font-weight: bold;
}

h2 {
    font-size: 1.5rem;
    font-weight: bold;
}

h3 {
    font-size: 1.17rem;
    font-weight: bold;
}

h4 {
    font-weight: bold;
}

h5 {
    font-size: .83rem;
    font-weight: bold;
}

h6 {
    font-size: .67rem;
    font-weight: bold;
}
```


::: class container :::

<h3 id="ui-description">Description</h3> 

The interface is divided into three sections, the "Text", the "Styles" and the "Sidebar" section.

#### Text Section 

The "Text" section allows you to edit the text and preview the rendering in HTML. It is located at the left of Stylo document window. See the [HTML Preview](#ui-html-preview) section for more information.

:::

