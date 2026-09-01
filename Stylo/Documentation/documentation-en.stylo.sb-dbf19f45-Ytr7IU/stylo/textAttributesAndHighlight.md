
# Text attributes and highlight 

Text attributes allows to assign attributes to any part of a text. These parts can then be highlighted using a CSS style targeting them. Use it for any purpose you may see fit! It's also a really flexible way to keep external notes in a text as they are not exported with the document. 

For example, we could want to mark a paragraph as needing further work: 

```markdown
{.need-rework}
I started to write when I was young. This paragraph is not complete...  
```

And we could also specify other things such a the subject of the paragraph:

```markdown 
{.young .need-rework} 
I started to write when I was young. This paragraph is not complete... 
```

Attributes can be stacked, meaning they can be be defined in different attributes blocs:  

```markdown
{.young} 
{.need-rework}
I started to write when I was young. This paragraph is not complete... 
```

To highlight the attributed parts of the text we just need to define a style to do so. The style would preferably make the elements we want to higlight standout against the other elements. For example, we could higlight all paragraphs that needs rework using the following simple style: 

```css
body {
	background-color: #eee;
	color: #ccc;
}
.need-rework {
	color: black;
}
```
 
This style would look like this in Stylo: 

![highlight-need-rework](./need-rework.jpg)


Three types of attributes can be added: class, key value attribute and id. 

```markdown
{ .class key=value #id }
A paragraph.
```

_Attributes blocs_ can be put before, below, on the line directly after an element, or inline where they will apply to the inline element directly preceeding them, or to the enclosing bloc if there is no such element. 

```markdown
{ .class key=value }
A _paragraph_ {.inline-class} {.paragraph-class}.
{#id}
```
 
This completes the overview of text attributes! 





