
# Strikethrough  

The _strikethrough_ implementation in Stylo is based on the GitHub Flavored Markdown(GFM), see [strikethrough extension](https://github.github.com/gfm/#strikethrough-extension-) for more information. 

## Syntax

To create a strikethrough simply surround the text to be strikedthrough by two '~' on each side. 

Markdown: 

``` markdown 
~~strikethrough text~~  
```

HTML:

``` html
<p><s>strikethrough text</s></p>
```     

## Pseudo-elements  

There is one pseudo-element offered by this element:

- `tag`: covers the `~~` signs used to define the strikedthrough text.
