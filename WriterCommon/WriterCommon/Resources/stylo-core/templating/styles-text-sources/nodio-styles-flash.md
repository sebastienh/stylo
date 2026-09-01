

# h1 Heading (h1:flash, h1::tag:flash)
## h2 Heading (h2:flash, h2::tag:flash)
### h3 Heading (h3:flash, h3::tag:flash)
#### h4 Heading (h4:flash, h4::tag:flash)
##### h5 Heading (h5:flash, h5::tag:flash)
###### h6 Heading (h6:flash, h6::tag:flash)
 


## Horizontal rule
 
___ (hr:flash)

--- (hr:flash)

*** (hr:flash)
 
## Emphasis:
 

### Emphasis: (:flash)

**This is bold text** (strong:flash, strong::tag:flash)

__This is bold text__ (strong:flash, strong::tag:flash)

*This is italic text* (em:flash, em::tag:flash)

_This is italic text_ (em:flash, em::tag:flash)

~~Strikethrough~~ (s:flash, s::tag:flash)

### Emphasis: (:flash normal)

**This is bold text** (:flash strong, :flash strong::tag)

__This is bold text__ (:flash strong, :flash strong::tag)

*This is italic text* (:flash em, :flash em::tag)

_This is italic text_ (:flash em, :flash em::tag)

~~Strikethrough~~ (:flash s, :flash s::tag)


## Blockquotes:

### Blockquotes: (blockquote:flash, blockquote::tag:flash)


 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:flash  blockquote, :flash blockquote::tag)
 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


## Lists:

### Lists: (:flash)

Unordered (ul:flash, li:flash, li::tag:flash)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:flash, li:flash, li::tag:flash)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


### Lists: (:flash normal)

Unordered (:flash ul, :flash li, :flash li::tag)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:flash ol, :flash li, :flash li::tag)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar



## Code


### Code: (:flash) (code:flash, code::tag:flash, code::params:flash)

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

### Code: (:flash normal) (:flash code, :flash code::tag)

Inline `code`



## Tables


### Tables (:flash)(table:flash, thead:flash, tbody:flash, tr:flash, td:flash, table::tag:flash)

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

### Tables (:flash normal)(:flash thead, :flash tbody, :flash tr, :flash td, :flash table::tag)

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


### Links (:flash)(a:flash, a::tag:flash, a::text:flash, a::destination:flash, a::label:flash, a::title:flash, img:flash, img::tag:flash, img::text:flash, img::destination:flash, img::label:flash, img::title:flash, ref:flash, ref::tag:flash, ref::text:flash, ref::destination:flash, ref::label:flash, ref::title:flash)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:flash normal)(:flash a, :flash a::tag, :flash a::text, :flash a::destination, :flash a::label, :flash a::title, :flash img, :flash img::tag, :flash img::text, :flash img::destination, :flash img::label, :flash img::title, :flash ref, :flash ref::tag, :flash ref::text, :flash ref::destination, :flash ref::label, :flash ref::title)

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

### html-block (html-block:flash)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>

## attributes

### attributes(:flash) (key-value-attr:flash, class-attr:flash, id-attr:flash, key-value-attr::tag:flash, class-attr::tag:flash, id-attr::tag:flash)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:flash normal) (:flash key-value-attr, :flash class-attr, :flash id-attr, :flash key-value-attr::tag, :flash class-attr::tag, :flash id-attr::tag)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

