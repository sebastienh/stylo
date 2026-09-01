
# Edit a stylesheet

To edit a stylesheet:

1. Make sure the _style inspector_ is opened (see [Edit a Style](#editStyle))  
2. Put the mouse cursor over the stylesheet, two buttons should appear: a`Delete` and an`Edit` button. 
3. Click on the `Edit` button

Once in editing mode the [stylesheet panel](#stylesheetPanel) is presented that allows to change a stylesheet in the current Markdown style. To change the appearance of an element in the Markdown source, the HTML type of the element to style must be used. The [Markdown Reference](../markdown#mdContents) contains, for each Markdown element, the corresponding HTML element type that must be used in the style. Another way to know the corresponding HTML element type of a Markdown element, is to right click on it in the Markdown source editor, and choose _Copy selector_. See [_Copy selector_](#copySelector) section for more information.

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



