
# Exact match

_[attribute_name="match_text"]_ matches the elements whose value of attribute "attribute_name" *is equal* to "match_text". Here we match the *complete* value, meaning the complete list of "words" part of the attribute value. In the following HTML document:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1 authors="john" class="title">Title 1</h1>
        <h2 class="title other-classe" authors="john marc">Title 2</h2>
    </body>
</html>
```

we can select the `h1` element using the following selector:

CSS:

``` css
[authors="john"] {
    ...
}
```

Note that the `h2` element is not selected because it also contains the substring `marc` in the `authors` attribute's value. To match the `h2` using the exact match text selection expression we would need to use the following CSS:

CSS:

``` css
[authors="john marc"] {
    ...
}
```

Note that we used the same order of words. For the exact match the order of the elements is important e.g. `marc john` would not select the `h2` element. 
