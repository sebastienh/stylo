
# First word begins with substring

_[attribute_name^="value"]_ matches the elements whose value first word of the attribute "attribute_name" *begins with* "match_text" substring. Unlike the previous selector, the value does not have to be a whole word. In the following HTML source:

HTML:

```html
<h1 authors="john marc">Title 1</h1>
```

with the attribute selector below, we could select the `h1` element with the following CSS:

CSS:

``` css
[authors^="jo"] {
    ...
}
```
