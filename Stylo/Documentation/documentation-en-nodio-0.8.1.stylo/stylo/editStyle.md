

# Editing a style (`⇧⌘E`)

A style can only be edited if it is selected, this allows any change to the style to be [applied](#applyPendingStyleShanges) directly to the Mardkown text. 

To edit a style, do one of the following:

- Click on the `Edit` button of the selected style
- From the menu, choose: `View`→`Styles`→`Edit Style`
- With the keyboard shortcut: `⇧⌘E`

Once in editing mode the CSS editor is presented that allows to change the current Markdown style. To add a style to an element in the Markdown source, the HTML type of the element to style must be used. The [Markdown Reference](../markdown#mdContents) contains, for each Markdown element, the corresponding HTML element type that must be used in the style. Another way to know the corresponding HTML element type of a Markdown element, is to right click on it in the Markdown source editor, and choose _Copy selector_. See [_Copy selector_](#copySelector) section for more information.

To style the following Markdown: 

``` markdown 

# A title level one 

Some paragraph that we want to style. 

```

we could use this simple CSS: 

``` css
body {
	background-color: gray;
}

h1 {
	color: blue;
}

p {
	color: red;
}

```

In the preceding CSS extract, `body` represents the whole document, we use it to assign a background color to the Mardkown source editor. To style `# A title level one`, we use the corresponding HTML element type for a title level one: `h1` to style it with a blue color, and finally we use the `p` element to style the paragraph `Some paragraph that we want to style.` with a red color. 

The corresponding HTML element of a Markdown element is most of the time really straightforward i.e. a Markdown title level 1 is an `h1` HTML element; a Markdown paragraph is a `p` HTML element, etc... When in doubt, look in the [Markdown Reference](../markdown#mdContents) for the element specific section which will give the corresponding HTML element for it, or use the [_Copy selector_](#copySelector) selector option of the element contextual menu which can be obtained by right clicking on it in the Markdown source.
