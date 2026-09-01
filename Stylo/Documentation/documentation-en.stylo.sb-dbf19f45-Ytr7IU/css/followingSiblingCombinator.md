
# Following sibling combinator

__following sibling selector__ matches the elements that are following sibling of an element. It is represented by the sign "~" between the selectors. In the HTML of the previous document, we can use a _following sibling_ selector to select the `h2` and `p` elements as follows:

CSS:

``` css
h1 ~ * {
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