

/********************************************/
/*           highlight-focus                */
/********************************************/


## Headers:

# h1 Heading (h1:highlight:focus, h1::tag:highlight:focus)
## h2 Heading (h2:highlight:focus, h2::tag:highlight:focus)
### h3 Heading (h3:highlight:focus, h3::tag:highlight:focus)
#### h4 Heading (h4:highlight:focus, h4::tag:highlight:focus)
##### h5 Heading (h5:highlight:focus, h5::tag:highlight:focus)
###### h6 Heading (h6:highlight:focus, h6::tag:highlight:focus)


## Horizontal rule
 
___ (hr:highlight:focus)

--- (hr:highlight:focus)

*** (hr:highlight:focus)


/*
 ## Emphasis:
 
 **This is bold text**

 __This is bold text__

 *This is italic text*

 _This is italic text_

 ~~Strikethrough~~
*/

## Emphasis:


### Emphasis: (:highlight:focus)

**This is bold text** (strong:highlight:focus, strong::tag:highlight:focus)

__This is bold text__ (strong:highlight:focus, strong::tag:highlight:focus)

*This is italic text* (em:highlight:focus, em::tag:highlight:focus)

_This is italic text_ (em:highlight:focus, em::tag:highlight:focus)

~~Strikethrough~~ (s:highlight:focus, s::tag:highlight:focus)

### Emphasis: (:highlight :focus)

**This is bold text** (:highlight strong:focus, :highlight strong::tag:focus)

__This is bold text__ (:highlight strong:focus, :highlight strong::tag:focus)

*This is italic text* (:highlight em:focus, :highlight em::tag:focus)

_This is italic text_ (:highlight em:focus, :highlight em::tag:focus)

~~Strikethrough~~ (:highlight s:highlight, :highlight s::tag:highlight)

### Emphasis: (:highlight :highlight:focus)

**This is bold text** (:highlight strong:highlight:focus, :highlight strong::tag:highlight:focus)

__This is bold text__ (:highlight strong:highlight:focus, :highlight strong::tag:highlight:focus)

*This is italic text* (:highlight em:highlight:focus, :highlight em::tag:highlight:focus)

_This is italic text_ (:highlight em:highlight:focus, :highlight em::tag:highlight:focus)

~~Strikethrough~~ (:highlight s:highlight:focus, :highlight s::tag:highlight:focus)

### Emphasis: (:highlight:focus :highlight:focus)

**This is bold text** (:highlight:focus strong:highlight:focus, :highlight strong::tag:highlight:focus)

__This is bold text__ (:highlight:focus strong:highlight:focus, :highlight strong::tag:highlight:focus)

*This is italic text* (:highlight:focus em:highlight:focus, :highlight em::tag:highlight:focus)

_This is italic text_ (:highlight:focus em:highlight:focus, :highlight em::tag:highlight:focus)

~~Strikethrough~~ (:highlight:focus s:highlight:focus, :highlight s::tag:highlight:focus)

## Blockquotes:

### Blockquotes: (:highlight:focus)(blockquote:highlight:focus, blockquote::tag:highlight:focus)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight :focus)(:highlight blockquote:focus, blockquote::tag:focus)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight :highlight:focus)(:highlight blockquote:highlight:focus, blockquote::tag:highlight:focus)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight:focus :highlight:focus)(:highlight:focus blockquote:highlight:focus, blockquote::tag:highlight:focus)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.



## Lists:

### Lists: (:highlight:focus)

Unordered (ul:highlight:focus, li:highlight:focus, li::tag:highlight:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:highlight:focus, li:highlight:focus, li::tag:highlight:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:highlight :focus)

Unordered (:highlight ul:focus, :highlight li:focus, :highlight li::tag:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol:focus, :highlight li:focus, :highlight li::tag:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:highlight :highlight:focus)

Unordered (:highlight ul:highlight:focus, :highlight li:highlight:focus, :highlight li::tag:highlight:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol:highlight:focus, :highlight li:highlight:focus, :highlight li::tag:highlight:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar



### Lists: (:highlight:focus :highlight:focus)

Unordered (:highlight:focus ul:highlight:focus, :highlight:focus li:highlight:focus, :highlight:focus li::tag:highlight:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight:focus ol:highlight:focus, :highlight:focus li:highlight:focus, :highlight:focus li::tag:highlight:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

## Code


### Code: (:highlight:focus) (code:highlight:focus, code::tag:highlight:focus, code::params:highlight:focus)

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```

### Code: (:highlight :focus) (:highlight code:focus, :highlight code::tag:focus, :highlight code::params:focus)

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```

### Code: (:highlight :highlight:focus) (:highlight code:highlight:focus, :highlight code::tag:highlight:focus, :highlight code::params:highlight:focus)

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```

### Code: (:highlight:focus :highlight:focus) (:highlight:focus code:highlight:focus, :highlight:focus code::tag:highlight:focus, :highlight:focus code::params:highlight:focus)

Inline `code`

Indented code

    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code


Block code "fences"

```
Sample text here...
```

Syntax highlighting

``` js
var foo = function (bar) {
  return bar++;
};

console.log(foo(5));
```


## Tables


### Tables (:highlight:focus)(table:highlight:focus, thead:highlight:focus, tbody:highlight:focus, tr:highlight:focus, td:highlight:focus, table::tag:highlight:focus)


| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


### Tables (:highlight :focus)(:highlight table:focus, :highlight thead:focus, :highlight tbody:focus, :highlight tr:focus, :highlight td:focus, :highlight table::tag:focus)


| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


### Tables (:highlight :highlight:focus)(:highlight table:highlight:focus, :highlight thead:highlight:focus, :highlight tbody:highlight:focus, :highlight tr:highlight:focus, :highlight td:highlight:focus, :highlight table::tag:highlight:focus)


| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


### Tables (:highlight:focus :highlight:focus)(:highlight:focus table:highlight:focus, :highlight:focus thead:highlight:focus, :highlight:focus tbody:highlight:focus, :highlight:focus tr:highlight:focus, :highlight:focus td:highlight:focus, :highlight:focus table::tag:highlight:focus)


| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |

Right aligned columns

| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |


## Links


### Links (:highlight:focus)(a:highlight:focus, a::tag:highlight:focus, a::text:highlight:focus, a::destination:highlight:focus, a::label:highlight:focus, a::title:highlight:focus, img:highlight:focus, img::tag:highlight:focus, img::text:highlight:focus, img::destination:highlight:focus, img::label:highlight:focus, img::title:highlight:focus, ref:highlight:focus, ref::tag:highlight:focus, ref::text:highlight:focus, ref::destination:highlight:focus, ref::label:highlight:focus, ref::title:highlight:focus)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:highlight :focus)(:highlight a:focus, :highlight a::tag:focus, :highlight a::text:focus, :highlight a::destination:focus, :highlight a::label:focus, :highlight a::title:focus, :highlight img:focus, :highlight img::tag:focus, :highlight img::text:focus, :highlight img::destination:focus, :highlight img::label:focus, :highlight img::title:focus, :highlight ref:focus, :highlight ref::tag:focus, :highlight ref::text:focus, :highlight ref::destination:focus, :highlight ref::label:focus, :highlight ref::title:focus)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"



### Links (:highlight :highlight:focus)(:highlight a:highlight:focus, :highlight a::tag:highlight:focus, :highlight a::text:highlight:focus, :highlight a::destination:highlight:focus, :highlight a::label:highlight:focus, :highlight a::title:highlight:focus, :highlight img:highlight:focus, :highlight img::tag:highlight:focus, :highlight img::text:highlight:focus, :highlight img::destination:highlight:focus, :highlight img::label:highlight:focus, :highlight img::title:highlight:focus, :highlight ref:highlight:focus, :highlight ref::tag:highlight:focus, :highlight ref::text:highlight:focus, :highlight ref::destination:highlight:focus, :highlight ref::label:highlight:focus, :highlight ref::title:highlight:focus)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:highlight:focus :highlight:focus)(:highlight:focus a:highlight:focus, :highlight:focus a::tag:highlight:focus, :highlight:focus a::text:highlight:focus, :highlight:focus a::destination:highlight:focus, :highlight:focus a::label:highlight:focus, :highlight:focus a::title:highlight:focus, :highlight:focus img:highlight:focus, :highlight:focus img::tag:highlight:focus, :highlight:focus img::text:highlight:focus, :highlight:focus img::destination:highlight:focus, :highlight:focus img::label:highlight:focus, :highlight:focus img::title:highlight:focus, :highlight:focus ref:highlight:focus, :highlight:focus ref::tag:highlight:focus, :highlight:focus ref::text:highlight:focus, :highlight:focus ref::destination:highlight:focus, :highlight:focus ref::label:highlight:focus, :highlight:focus ref::title:highlight:focus)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

## html-block (html-block)

### html-block (:highlight:focus)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>


## attributes

### attributes(:highlight:focus) (key-value-attr:highlight:focus, class-attr:highlight:focus, id-attr:highlight:focus, key-value-attr::tag:highlight:focus, class-attr::tag:highlight:focus, id-attr::tag:highlight:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.


### attributes(:highlight :focus) (:highlight key-value-attr:focus, :highlight class-attr:focus, :highlight id-attr:focus, :highlight key-value-attr::tag:focus, :highlight class-attr::tag:focus, :highlight id-attr::tag:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.


### attributes(:highlight :highlight:focus) (:highlight key-value-attr:highlight:focus, :highlight class-attr:highlight:focus, :highlight id-attr:highlight:focus, :highlight key-value-attr::tag:highlight:focus, :highlight class-attr::tag:highlight:focus, :highlight id-attr::tag:highlight:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:highlight:focus :highlight:focus) (:highlight:focus key-value-attr:highlight:focus, :highlight:focus class-attr:highlight:focus, :highlight:focus id-attr:highlight:focus, :highlight:focus key-value-attr::tag:highlight:focus, :highlight:focus class-attr::tag:highlight:focus, :highlight:focus id-attr::tag:highlight:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.
