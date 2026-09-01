
# Markdown elements types 

There is two kinds of Markdown elements: 

- blocs elements
- inline elements 

A Markdown document is parsed as a sequence of blocs. A bloc element is essentially a container of other Markdown elements which, in turn, can themselves be blocs and/or inline elements. A bloc can be either of `container` or `leaf` type depending if it can contain other blocs or not.

Container blocs include:
- [Blockquote](#mdBlockquote)
- [List and list items](#mdLists)
- [Table](#mdTable)

Leaf blocs include:
- [Paragraph](#mdParagraph)
- [Horizontal Bar](#mdHorizontalBar)
- [Headers](#mdHeaders)
- [Indented Code Block](#mdCode)
- [Fenced Code Block](#mdCode)
- HTML Block
- [Reference](#mdReference)
- Blank Lines 
- [Attributes Blocs](#mdAttributes)

An inline element is complete in itself and does not allow any other content. 

Inline elements include:
- [Strikethrough](#mdStrikethrough)
- [Emphasis](#mdEmphasis)
- [Inline Code](#mdCode)
- HTML Entities
- [Link](#mdLink)
- [Image](#mdImage)
- Autolink
- Inline Raw HTML 
- [Attributes Blocs*](#mdAttributes)


For more information, read the [CommonMark specification](https://spec.commonmark.org/0.29/#blocks-and-inlines).

*Attributes Blocs have a dual nature as they be defined inline e.g. inside a paragraph, or as a bloc, at the root or inside another bloc. 


