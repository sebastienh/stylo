
# Next sibling combinator 

__next sibling selector__ selects the next sibling element (the one right after an element). A _next sibling_ selectors combinator is represented by the `+` sign between the selectors. In the HTML of the previous document, we could use a next sibling selector to select the `h2` element  under the first `h1` as follows:

CSS:

``` css
h1 + h2 {
    ...
}
```

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