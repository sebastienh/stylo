
# Type selector

The type selector is the most basic kind of selector. It selects elements according to their name (`localname`). For example, in the following HTML file:
 
HTML:

``` html
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
    </body>
</html>
```

it is possible to assign the red color to the element `h2` using the following style declaration:

CSS:

``` css
h2 {
    color: red; 
}
```

The `h2` selector effectively selects all elements of type `h2`.
