
# Headers   

## Syntax

### Header level 1 

A level 1 title can be written in two ways, with a number sign, as in the following example:

Markdown: 

``` markdown 
# title 1
```

or, with one or more `=` characters under the header text, like the following: 

Markdown: 

``` markdown 
title 1
=======
```

Both are equivalent to the following HTML: 

HTML:

``` html
<h1>titre 1</h1>
```

### Header level 2 

Markdown: 

``` markdown
## titre 2 
```

HTML:

``` html
<h2>titre 2</h2>
```

As for the level 1 title, an _underlined_ syntax exists for the level 2 title. It uses the `-` character instead: 

Markdown: 

``` markdown
Titre 2
-------
```

HTML:

``` html
<h2>titre 2</h2>
```

### Other levels 

The other levels are written with the number of dashes corresponding to the header level wanted:   

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

## Pseudo-elements  

All titles offer the following pseudo-element:

- `tag`: allows to style the region used to define the title, in the case of syntax with `#`, only sharps will be styled, and in the case of the _underlined_ syntax, the underline bar will be styled. For example, the following CSS will color the "tag" part of the "h1" elements with the red color:

``` css
h1::tag {
    color: red;
}
```