
# Reference  

A reference takes the form: `[\<reference label\>]: \<destination uri\> "\<title\>"`, where the \<reference label\> is the name of the reference used in links and images and the \<destination uri\> is the target URI for this reference. It is possible to style a Markdown reference using the `reference` element. 

## Syntax

An example of a reference to [Index](http://www.textually.net):

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
[textually]: www.textually.net "Index website"
```

Note: A link or an image using a non existing reference label, will be treated as text by Stylo. 


## Pseudo-elements  

The reference element supports four pseudo-elements: 

- `tag`: the region with the start and end square braquet( "[", "]") and the colon
- `label`: the part between the two square braquets
- `destination`: the destination URI 
- `title`: the reference title