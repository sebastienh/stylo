
# Image 

An image element, corresponding to the `img` HTML element, is an inline link to an image. Unlike the link element, it is replaced by the destination image at loading time: it doesn't need to be clicked to be accessed. 

## Syntax

The syntax difference with the link is the presence of an exclamation mark `!` before the image link definition. 

Markdown:

``` markdown 
![Logo](http://www.textually.net/images/stylo/logo.png)
```

HTML:

``` html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="Logo" /></p>
```

With a title: 

Markdown:

``` markdown 
![Logo](http://www.textually.net/images/stylo/logo.png "Logo")
```

HTML:

``` html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="Logo" title="Logo" /></p>
```

Like the links, the images also have a syntax in reference format:

Markdown:

``` markdown
![alternative text][idImage]

[idImage]: http://www.textually.net/images/stylo/logo.png "Logo"
```

HTML:

``` html 
<p><img src="http://www.textually.net/images/stylo/logo.png" alt="alternative text" title="Logo" /></p>
```

An image can reference a local file or a remote file on Internet but only the remote files will be shown in the HTML preview.

## Pseudo-elements  

- `tag`: the region that includes the start and end square braquet( "[", "]") and the two parenthesis ("(", ")")
- `text`: the part between the two square braquets
- `destination`: the destination URI if the image link does not point to a reference 
- `label`: the destination reference if the image link points to a reference 
- `title`: the title of the image link 
