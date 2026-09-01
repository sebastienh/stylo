# `class`

A `class` groups a set of elements under a name. It will later be possible to refer to these elements using the name of the class. To assign a class to an element, we just need to add a `class` attribute and add a class name to the attribute value. Here is an example that assigns the `title` class to the `h1` and the `h2` elements:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1 class="title" id="my-first-title">Title 1</h1>
        <h2 class="title">Title 2</h2>
    </body>
</html>
```

Note that it is possible to assign multiple classes to an element using the same `class` attribute by adding the names of all classes as the `class` attribute value, separated by a space. For example, in the following document we assign the classes `title` and `other-class` to the `h2` element.

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h2 class="title other-class">Title 2</h2>
    </body>
</html>
```

## HTML Syntax

A class name must begin with a letter and may be followed by a sequence of unicode characters exept line feed, whitespace, tab character. 
