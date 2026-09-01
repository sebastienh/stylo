
# Id selector 

The id selector allows to select elements using the `id` attribute. It takes the general form of the hash sign followed by the `id` attribute's value: _#\<element id\>_. In the following HTML document:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1 id="my-first-title">Title 1</h1>
        <h2>Title 2</h2>
    </body>
</html>
```

it is possible to assign the red color to the element `h1` using the following style declaration:

CSS:

``` css
#my-first-title {
    color: red;
}
```
