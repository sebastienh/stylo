
# Last word ends with substring

_[attribute_name $="match_text"]_ matches the elements whose value last word of the attribute "attribute_name" *ends with* "match_text". Here, the value does not have to be an entire word. In the following HTML source:

HTML:

``` html
<h1 authors="john marc">Title 1</h1>
```

we could select the `h1` element, with the following attribute selector:

CSS:

``` css
[authors$="arc"] {
    ...
}
```