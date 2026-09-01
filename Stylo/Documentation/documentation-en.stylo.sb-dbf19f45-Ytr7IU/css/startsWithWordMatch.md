
# Starts with word match

_[attribute_name|="value"]_ matches the elements whose attribute "attribute_name" *starts with* "match_text". The value must be an entire word, alone or followed by a hyphen "-". Here again we are matching a value's complete substring. For example, in the following HTML source:

HTML:

``` html
<h1 authors="john marc">Title 1</h1>
<h2 authors="anne-marie marc">Title 2</h1>
```

With the attribute selector below, we could select the `h1` element:

CSS:

``` css
[authors|="john"] {
    ...
}
```

With the attribute selector below, we could select the `h2` element:

CSS:

``` css
[authors|="anne"] {
    ...
}
```

or

CSS:

``` css
[authors|="anne-marie"] {
    ...
}
```

Note that the following CSS would *not* work: 

``` css
[authors|="ann"] {
    ...
}
```

because the _starts with word_  text selection expression addresses a complete word inside the attribute's value. 
