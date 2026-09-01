
# Link  

A link is an element that allows to insert a Unique Resource Identifier (URI) to a resource. This element corresponds to the `a` (anchor) element of HTML.

## Syntax

There are two main syntaxes for links, the difference being how to specify the URI: with or without reference. A reference (see the [Reference](#mdReference) section for more information) is an identifier given to a URI and can be used instead of a URI in a link (or image). 

### Without reference 

Markdown: 

``` markdown 
[Stylo](www.textually.net/stylo)
```

HTML: 

``` html 
<p><a href="www.textually.net/stylo">Stylo</a></p>
```
or with a title: 

Markdown:

``` markdown 
[link with title](http://www.textually.net/stylo "Stylo!")
```

HTML: 

``` html 
<p><a href="http://www.textually.net/stylo" title="Stylo!">link with title</a></p>
```

### With reference 

Markdown:

``` markdown
[link] [idStylo]

[idStylo]: http://www.textually.net/stylo
```

Note: If a reference is not found in the current document the links and images that use it will be considered text.

## Pseudo-elements  

- `tag`: the region that includes the start and end square braquet( "[", "]") and the two parenthesis ("(", ")")
- `text`: the part between the two square braquets
- `destination`: the destination URI if the link does not point to a reference 
- `label`: the destination reference if the link points to a reference 
- `title`: the title of the link 
