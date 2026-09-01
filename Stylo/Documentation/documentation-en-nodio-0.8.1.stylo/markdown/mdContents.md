
# Markdown Reference 

Markdown is the lightweight markup language used in Stylo. It's a simple language that emphasizes readability and ease of use. Markdown exists in several versions but a version seems to make more and more consensus: _CommonMark_, and this is the version implemented by _Stylo Core_ which is shared by both Stylo and Nodio Apps. For any questions regarding the Markdown syntax, the official site of [CommonMark](https://commonmark.org/) offers a complete [documentation](https://spec.commonmark.org) and an [online test tool](https://spec.commonmark.org/dingus/). 

CommonMark currently lacks the table and strikethough elements, Stylo adds them in their GitHub flavoured versions. See the GitHub Markdown documentation for a complete reference: [GFM tables](https://github.github.com/gfm/#tables-extension-) and [GFM strikethrough](https://github.github.com/gfm/#strikethrough-extension-).

Markdown defines a non-intrusive syntax that allows to define HTML elements. As a last resort, since valid HTML code is interpreted as such by Markdown, it is always possible to resort to HTML when an element is not supported. It should be noted that there is no _invalid_ Markdown. A text document is a valid Markdown document. If a tag is not recognized it will simply be interpreted as text.

In Stylo*, an element can also define one or more sub-regions that can be targeted by a pseudo-element (see [Pseudo-element selector](../css/pseudoElementSelector.html) section) selector section. For each element, the associated pseudo-elements will be listed in the section pertaining to the element in the subsection _Pseudo-elements_.

CSS is used to style and specify the appearance of the Markdown text. To use CSS we need a way to identify elements to style. Since some Markdown elements have no correspondent HTML elements, we defined [Markdown specific elements](markdownSpecificElements.html) for them, to allow targeting them in CSS. 

Here is a simplified inventory of the main syntax rules. Please refer to the [CommonMark Specification](https://spec.commonmark.org) and [GitHub Flavoured Markdown](https://help.github.com/articles/github-flavored-markdown) for more information.

- [Markdown elements types](#mdElementTypes)
- [Markdown Specific Elements](#markdownSpecificElements)
- [Headers](#headers)
- [Horizontal Bar](#mdHorizontalBar)
- [Emphasis](#mdEmphasis)
- [Strikethrough](#mdStrikethrough)
- [Blockquote](#mdBlockquote)
- [List](#mdLists)
- [Code](#mdCode)
- [Table](#mdTable)
- [Reference](#mdReference)
- [Link](#mdLink)
- [Image](#mdImage)
- [Attributes](#mdAttributes)

_Note_: This feature is part of the _Style Editor_ which is currently unavailable in Nodio.