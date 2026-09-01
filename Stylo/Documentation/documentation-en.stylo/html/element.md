# Element 

Elements are the unit of content in an HTML document. They define the content structure of the HTML document. An element is defined by an opening tag and a closing tag.

## Opening tag

**The opening tag** is the name of the element between smaller and bigger than signs. Here is for example the opening tag of the element named _html_:

     <html>

## Closing tag

**The closing tag** consists of the name of the element preceded by the slash, all between a smaller and bigger than signs. For example, here is how we could define the `html` element:

HTML:

``` html
<html>
</html>
```

## Content 

**The content** of an element is everything between the opening tag and the closing tag of that element. For example, here is how to define a title element level 1 (_h1_) with the content _A title_:

HTML:

``` html
    <h1>A title</h1>
```

Here is an example of an HTML document with content:

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1>Title 1</h1>
        <h2>Title 2</h2>
        <p>Content of the first paragraph </p>
    </body>
</html>
```

The previous document contains five elements: `html`, `body`, `h1`, `h2` and `p`.

1. `html`: the root element of the html document
2. `body`: the _body_ element contains all the contents of the document
3. `h1`: an element that defines a level 1 title
4. `h2`: an element that defines a level 2 title
5. `p`: an element that defines a paragraph

The doctype is not an HTML element in itself. It is simply used to specify that the content is of HTML type. 
