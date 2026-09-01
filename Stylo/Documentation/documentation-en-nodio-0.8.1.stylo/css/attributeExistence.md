
# Attribute existence 

The attribute selector allows to select elements based on the existence of an attribute. To do that, we need to use the name of the attribute in square brackets. In the case of the following HTML document:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1 author="john">Title 1</h1>
        <h2 class="other-class title">Title 2</h2>
    </body>
</html>
```

it is possible to assign the red color to the `h1` element using the style declaration:

CSS:

```css
[author] {
    color: red;
}
```

Here, we use the attribute selector to select all the elements that have the "author" attribute set, regardless of the it's value.