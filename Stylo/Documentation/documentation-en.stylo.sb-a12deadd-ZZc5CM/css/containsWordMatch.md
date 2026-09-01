
# Contains word match

_[attribute_name~="match_text"]_ matches the elements whose attribute "attribute_name"'s value *contains* the word "match_text". An attribute contains a list of words; with this text selection expression we are looking for a specific word inside this list. This value needs to be the exact match of one these words for example:

HTML:

``` html
<h1 authors="john marc">Title 1</h1>
```

With the attribute selector below, we could select the `h1` element:

CSS:

``` css
[authors~="marc"] {
    ...
}
```

The following CSS would *not* work since it does not contains a complete value's substring: 

CSS:

``` css
[authors~="ma"] {
    ...
}
```