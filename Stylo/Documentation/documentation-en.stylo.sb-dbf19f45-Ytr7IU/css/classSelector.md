
# Class selector 

The class selector allows to select elements using the `class` attribute. It takes the general form of the dot ('.') followed by the element class name: ". \<element class\>". In the following HTML document:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1 id="my-first-title" class="title">Title 1</h1>
        <h2 class="other-class title">Title 2</h2>
    </body>
</html>
```

it is possible to assign the red color to the elements `h1` and `h2` using the following style declaration (since they share the `class`'s value `title`):

CSS:

``` css
.title {
    color: red;
}
```
