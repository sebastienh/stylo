
# A word contains substring

_[attribute_name*="match_text"]_ matches the elements whose attribute "attribute_name"'s value *contains* "match_text". Here again, the value does not have to be an entire word. In the following HTML source:

HTML:

``` html
<h1 authors="john marc">Title 1</h1>
```

we could select the `h1` element with the attribute selector below:

CSS:

``` css
[authors$="ma"] {
    ...
}
```