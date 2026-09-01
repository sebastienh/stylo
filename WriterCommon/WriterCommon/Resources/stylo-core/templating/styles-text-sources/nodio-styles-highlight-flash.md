


/********************************************/
/*           highlight-flash                */
/********************************************/


## Headers:

# h1 Heading (h1:highlight:flash, h1::tag:highlight:flash)
## h2 Heading (h2:highlight:flash, h2::tag:highlight:flash)
### h3 Heading (h3:highlight:flash, h3::tag:highlight:flash)
#### h4 Heading (h4:highlight:flash, h4::tag:highlight:flash)
##### h5 Heading (h5:highlight:flash, h5::tag:highlight:flash)
###### h6 Heading (h6:highlight:flash, h6::tag:highlight:flash)


## Horizontal rule
 
___ (hr:highlight:flash)

--- (hr:highlight:flash)

*** (hr:highlight:flash)


/*
 ## Emphasis:
 
 **This is bold text**

 __This is bold text__

 *This is italic text*

 _This is italic text_

 ~~Strikethrough~~
*/

## Emphasis:


### Emphasis: (:highlight:flash)

**This is bold text** (strong:highlight:flash, strong::tag:highlight:flash)

__This is bold text__ (strong:highlight:flash, strong::tag:highlight:flash)

*This is italic text* (em:highlight:flash, em::tag:highlight:flash)

_This is italic text_ (em:highlight:flash, em::tag:highlight:flash)

~~Strikethrough~~ (s:highlight:flash, s::tag:highlight:flash)

### Emphasis: (:highlight :flash)

**This is bold text** (:highlight strong:flash, :highlight strong::tag:flash)

__This is bold text__ (:highlight strong:flash, :highlight strong::tag:flash)

*This is italic text* (:highlight em:flash, :highlight em::tag:flash)

_This is italic text_ (:highlight em:flash, :highlight em::tag:flash)

~~Strikethrough~~ (:highlight s:highlight, :highlight s::tag:highlight)

### Emphasis: (:highlight :highlight:flash)

**This is bold text** (:highlight strong:highlight:flash, :highlight strong::tag:highlight:flash)

__This is bold text__ (:highlight strong:highlight:flash, :highlight strong::tag:highlight:flash)

*This is italic text* (:highlight em:highlight:flash, :highlight em::tag:highlight:flash)

_This is italic text_ (:highlight em:highlight:flash, :highlight em::tag:highlight:flash)

~~Strikethrough~~ (:highlight s:highlight:flash, :highlight s::tag:highlight:flash)

## Blockquotes:

### Blockquotes: (:highlight:flash)(blockquote:highlight:flash, blockquote::tag:highlight:flash)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight :flash)(:highlight blockquote:flash, blockquote::tag:flash)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight :highlight:flash)(:highlight blockquote:highlight:flash, blockquote::tag:highlight:flash)

> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


## Lists:

### Lists: (:highlight:flash)

Unordered (ul:highlight:flash, li:highlight:flash, li::tag:highlight:flash)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:highlight:flash, li:highlight:flash, li::tag:highlight:flash)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:highlight :flash)

Unordered (:highlight ul:flash, :highlight li:flash, :highlight li::tag:flash)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol:flash, :highlight li:flash, :highlight li::tag:flash)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:highlight :highlight:flash)

Unordered (:highlight ul:highlight:flash, :highlight li:highlight:flash, :highlight li::tag:highlight:flash)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol:highlight:flash, :highlight li:highlight:flash, :highlight li::tag:highlight:flash)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

## Code


### Code: (:highlight:flash) (code:highlight:flash, code::tag:highlight:flash, code::params:highlight:flash)

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

### Code: (:highlight :flash) (:highlight code:flash, :highlight code::tag:flash, :highlight code::params:flash)

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

### Code: (:highlight :highlight:flash) (:highlight code:highlight:flash, :highlight code::tag:highlight:flash, :highlight code::params:highlight:flash)

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


### Tables (:highlight:flash)(table:highlight:flash, thead:highlight:flash, tbody:highlight:flash, tr:highlight:flash, td:highlight:flash, table::tag:highlight:flash)


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


### Tables (:highlight :flash)(:highlight table:flash, :highlight thead:flash, :highlight tbody:flash, :highlight tr:flash, :highlight td:flash, :highlight table::tag:flash)


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


### Tables (:highlight :highlight:flash)(:highlight table:highlight:flash, :highlight thead:highlight:flash, :highlight tbody:highlight:flash, :highlight tr:highlight:flash, :highlight td:highlight:flash, :highlight table::tag:highlight:flash)


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


### Links (:highlight:flash)(a:highlight:flash, a::tag:highlight:flash, a::text:highlight:flash, a::destination:highlight:flash, a::label:highlight:flash, a::title:highlight:flash, img:highlight:flash, img::tag:highlight:flash, img::text:highlight:flash, img::destination:highlight:flash, img::label:highlight:flash, img::title:highlight:flash, ref:highlight:flash, ref::tag:highlight:flash, ref::text:highlight:flash, ref::destination:highlight:flash, ref::label:highlight:flash, ref::title:highlight:flash)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:highlight :flash)(:highlight a:flash, :highlight a::tag:flash, :highlight a::text:flash, :highlight a::destination:flash, :highlight a::label:flash, :highlight a::title:flash, :highlight img:flash, :highlight img::tag:flash, :highlight img::text:flash, :highlight img::destination:flash, :highlight img::label:flash, :highlight img::title:flash, :highlight ref:flash, :highlight ref::tag:flash, :highlight ref::text:flash, :highlight ref::destination:flash, :highlight ref::label:flash, :highlight ref::title:flash)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"



### Links (:highlight :highlight:flash)(:highlight a:highlight:flash, :highlight a::tag:highlight:flash, :highlight a::text:highlight:flash, :highlight a::destination:highlight:flash, :highlight a::label:highlight:flash, :highlight a::title:highlight:flash, :highlight img:highlight:flash, :highlight img::tag:highlight:flash, :highlight img::text:highlight:flash, :highlight img::destination:highlight:flash, :highlight img::label:highlight:flash, :highlight img::title:highlight:flash, :highlight ref:highlight:flash, :highlight ref::tag:highlight:flash, :highlight ref::text:highlight:flash, :highlight ref::destination:highlight:flash, :highlight ref::label:highlight:flash, :highlight ref::title:highlight:flash)

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

### html-block (:highlight:flash)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>


## attributes

### attributes(:highlight:flash) (key-value-attr:highlight:flash, class-attr:highlight:flash, id-attr:highlight:flash, key-value-attr::tag:highlight:flash, class-attr::tag:highlight:flash, id-attr::tag:highlight:flash)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.


### attributes(:highlight :flash) (:highlight key-value-attr:flash, :highlight class-attr:flash, :highlight id-attr:flash, :highlight key-value-attr::tag:flash, :highlight class-attr::tag:flash, :highlight id-attr::tag:flash)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.


### attributes(:highlight :highlight:flash) (:highlight key-value-attr:highlight:flash, :highlight class-attr:highlight:flash, :highlight id-attr:highlight:flash, :highlight key-value-attr::tag:highlight:flash, :highlight class-attr::tag:highlight:flash, :highlight id-attr::tag:highlight:flash)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.
