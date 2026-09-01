
# Child combinator 

__child combinator__ is used to select the children of an element. A child selector combinator is represented by a larger than (`>`) sign between the selectors. For example, to select all `h2` that are children of the `body` element, the following CSS could be used:
   
CSS:

``` css
body > h2 {
    ...
}
```

In this example, only the `h2` element under the `body` element is selected, the one with the text: `title 2`. The one under the `p` element is not selected.

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
