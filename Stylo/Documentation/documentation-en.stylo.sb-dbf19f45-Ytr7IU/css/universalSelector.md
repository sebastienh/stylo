
# Universal selector 

The universal selector matches all elements. It takes the form of a star: `*`. 

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
        <p>
            A paragraph with <strong>bold text</strong>.
        </p>
    </body>
</html>
```

We could apply the red color to all elements in this document with the following style declaration:

CSS:

``` css
* {
    color: red;
}
```

We could have achieved the same effect by using the body element type selector since all the visible elements are its descendants.

CSS:

``` css
body {
    color: red;
}
```

The difference between the two will not be important in most cases, but for performance reasons it is better to avoid the use of the universal selector.
