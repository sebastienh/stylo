


body:focus {
    
}

# h1 Heading (h1:focus, h1::tag:focus)
## h2 Heading (h2:focus, h2::tag:focus)
### h3 Heading (h3:focus, h3::tag:focus)
#### h4 Heading (h4:focus, h4::tag:focus)
##### h5 Heading (h5:focus, h5::tag:focus)
###### h6 Heading (h6:focus, h6::tag:focus)
 


## Horizontal rule
 
___ (hr:focus)

--- (hr:focus)

*** (hr:focus)
 
## Emphasis:
 

### Emphasis: (:focus)

**This is bold text** (strong:focus, strong::tag:focus)

__This is bold text__ (strong:focus, strong::tag:focus)

*This is italic text* (em:focus, em::tag:focus)

_This is italic text_ (em:focus, em::tag:focus)

~~Strikethrough~~ (s:focus, s::tag:focus)

### Emphasis: (:focus normal)

**This is bold text** (:focus strong, :focus strong::tag)

__This is bold text__ (:focus strong, :focus strong::tag)

*This is italic text* (:focus em, :focus em::tag)

_This is italic text_ (:focus em, :focus em::tag)

~~Strikethrough~~ (:focus s, :focus s::tag)

### Emphasis: (:focus :focus)

**This is bold text** (:focus strong:focus, :focus strong::tag:focus)

__This is bold text__ (:focus strong:focus, :focus strong::tag:focus)

*This is italic text* (:focus em:focus, :focus em::tag:focus)

_This is italic text_ (:focus em:focus, :focus em::tag:focus)

~~Strikethrough~~ (:focus s:focus, :focus s::tag:focus)


## Blockquotes:

### Blockquotes: (blockquote:focus, blockquote::tag:focus)


 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:focus  blockquote, :focus blockquote::tag)
 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


### Blockquotes: (:focus  blockquote:focus, :focus blockquote::tag:focus)
 
> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.




## Lists:

### Lists: (:focus)

Unordered (ul:focus, li:focus, li::tag:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:focus, li:focus, li::tag:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


### Lists: (:focus normal)

Unordered (:focus ul, :focus li, :focus li::tag)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:focus ol, :focus li, :focus li::tag)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:focus :focus)

Unordered (:focus ul:focus, :focus li:focus, :focus li::tag:focus)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:focus ol:focus, :focus li:focus, :focus li::tag:focus)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


## Code


### Code: (:focus) (code:focus, code::tag:focus, code::params:focus)

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

### Code: (:focus normal) (:focus code, :focus code::tag)

Inline `code`



## Tables


### Tables (:focus)(table:focus, thead:focus, tbody:focus, tr:focus, td:focus, table::tag:focus)

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

### Tables (:focus normal)(:focus thead, :focus tbody, :focus tr, :focus td, :focus table::tag)

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


### Tables (:focus :focus)(:focus thead:focus, :focus tbody:focus, :focus tr:focus, :focus td:focus, :focus table::tag:focus)

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


### Links (:focus)(a:focus, a::tag:focus, a::text:focus, a::destination:focus, a::label:focus, a::title:focus, img:focus, img::tag:focus, img::text:focus, img::destination:focus, img::label:focus, img::title:focus, ref:focus, ref::tag:focus, ref::text:focus, ref::destination:focus, ref::label:focus, ref::title:focus)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:focus normal)(:focus a, :focus a::tag, :focus a::text, :focus a::destination, :focus a::label, :focus a::title, :focus img, :focus img::tag, :focus img::text, :focus img::destination, :focus img::label, :focus img::title, :focus ref, :focus ref::tag, :focus ref::text, :focus ref::destination, :focus ref::label, :focus ref::title)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

### Links (:focus :focus)(:focus a:focus, :focus a::tag:focus, :focus a::text:focus, :focus a::destination:focus, :focus a::label:focus, :focus a::title:focus, :focus img:focus, :focus img::tag:focus, :focus img::text:focus, :focus img::destination:focus, :focus img::label:focus, :focus img::title:focus, :focus ref:focus, :focus ref::tag:focus, :focus ref::text:focus, :focus ref::destination:focus, :focus ref::label:focus, :focus ref::title:focus)

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

### html-block (html-block:focus)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>

## attributes

### attributes(:focus) (key-value-attr:focus, class-attr:focus, id-attr:focus, key-value-attr::tag:focus, class-attr::tag:focus, id-attr::tag:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:focus normal) (:focus key-value-attr, :focus class-attr, :focus id-attr, :focus key-value-attr::tag, :focus class-attr::tag, :focus id-attr::tag)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:focus :focus) (:focus key-value-attr:focus, :focus class-attr:focus, :focus :focus id-attr:focus, :focus key-value-attr::tag:focus, :focus class-attr::tag:focus, :focus id-attr::tag:focus)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

