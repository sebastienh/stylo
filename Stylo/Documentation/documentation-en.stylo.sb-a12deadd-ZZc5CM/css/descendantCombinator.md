
# Descendant combinator

__descendant selector__ is used to select the descendants of an element. A descendant selector combinator is represented by a space (' ') between the selectors. For example, to select all headers level 2 descendant of the body element, the following CSS could be used:

CSS:

``` css
body h2 {
    ...
}
```

In this example, the two `h2` elements of the HTML document are selected.

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
        <h2>title 2</h2>
        <p> 
            <h2>title 2 in p</h2>
        </p>
    </body>
</html>
```
