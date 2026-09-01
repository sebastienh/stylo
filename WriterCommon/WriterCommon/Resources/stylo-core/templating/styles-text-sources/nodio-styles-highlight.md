

body:highlight {
    
}

# h1 Heading (h1:highlight, h1::tag:highlight)
## h2 Heading (h2:highlight, h2::tag:highlight)
### h3 Heading (h3:highlight, h3::tag:highlight)
#### h4 Heading (h4:highlight, h4::tag:highlight)
##### h5 Heading (h5:highlight, h5::tag:highlight)
###### h6 Heading (h6:highlight, h6::tag:highlight)
 


## Horizontal rule
 
___ (hr:highlight)

--- (hr:highlight)

*** (hr:highlight)
 
## Emphasis:
 

### Emphasis: (:highlight)

**This is bold text** (strong:highlight, strong::tag:highlight)

__This is bold text__ (strong:highlight, strong::tag:highlight)

*This is italic text* (em:highlight, em::tag:highlight)

_This is italic text_ (em:highlight, em::tag:highlight)

~~Strikethrough~~ (s:highlight, s::tag:highlight)

### Emphasis: (:highlight normal)

**This is bold text** (:highlight strong, :highlight strong::tag)

__This is bold text__ (:highlight strong, :highlight strong::tag)

*This is italic text* (:highlight em, :highlight em::tag)

_This is italic text_ (:highlight em, :highlight em::tag)

~~Strikethrough~~ (:highlight s, :highlight s::tag)

### Emphasis: (:highlight :highlight)

**This is bold text** (:highlight strong:highlight, :highlight strong::tag:highlight)

__This is bold text__ (:highlight strong:highlight, :highlight strong::tag:highlight)

*This is italic text* (:highlight em:highlight, :highlight em::tag:highlight)

_This is italic text_ (:highlight em:highlight, :highlight em::tag:highlight)

~~Strikethrough~~ (:highlight s:highlight, :highlight s::tag:highlight)


## Blockquotes:

### Blockquotes: (blockquote:highlight, blockquote::tag:highlight)


 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:highlight  blockquote, :highlight blockquote::tag)
 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


### Blockquotes: (:highlight  blockquote:highlight, :highlight blockquote::tag:highlight)
 
> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.




## Lists:

### Lists: (:highlight)

Unordered (ul:highlight, li:highlight, li::tag:highlight)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:highlight, li:highlight, li::tag:highlight)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


### Lists: (:highlight normal)

Unordered (:highlight ul, :highlight li, :highlight li::tag)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol, :highlight li, :highlight li::tag)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:highlight :highlight)

Unordered (:highlight ul:highlight, :highlight li:highlight, :highlight li::tag:highlight)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:highlight ol:highlight, :highlight li:highlight, :highlight li::tag:highlight)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


## Code


### Code: (:highlight) (code:highlight, code::tag:highlight, code::params:highlight)

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

### Code: (:highlight normal) (:highlight code, :highlight code::tag)

Inline `code`



## Tables


### Tables (:highlight)(table:highlight, thead:highlight, tbody:highlight, tr:highlight, td:highlight, table::tag:highlight)

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

### Tables (:highlight normal)(:highlight thead, :highlight tbody, :highlight tr, :highlight td, :highlight table::tag)

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


### Tables (:highlight :highlight)(:highlight thead:highlight, :highlight tbody:highlight, :highlight tr:highlight, :highlight td:highlight, :highlight table::tag:highlight)

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


### Links (:highlight)(a:highlight, a::tag:highlight, a::text:highlight, a::destination:highlight, a::label:highlight, a::title:highlight, img:highlight, img::tag:highlight, img::text:highlight, img::destination:highlight, img::label:highlight, img::title:highlight, ref:highlight, ref::tag:highlight, ref::text:highlight, ref::destination:highlight, ref::label:highlight, ref::title:highlight)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:highlight normal)(:highlight a, :highlight a::tag, :highlight a::text, :highlight a::destination, :highlight a::label, :highlight a::title, :highlight img, :highlight img::tag, :highlight img::text, :highlight img::destination, :highlight img::label, :highlight img::title, :highlight ref, :highlight ref::tag, :highlight ref::text, :highlight ref::destination, :highlight ref::label, :highlight ref::title)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

### Links (:highlight :highlight)(:highlight a:highlight, :highlight a::tag:highlight, :highlight a::text:highlight, :highlight a::destination:highlight, :highlight a::label:highlight, :highlight a::title:highlight, :highlight img:highlight, :highlight img::tag:highlight, :highlight img::text:highlight, :highlight img::destination:highlight, :highlight img::label:highlight, :highlight img::title:highlight, :highlight ref:highlight, :highlight ref::tag:highlight, :highlight ref::text:highlight, :highlight ref::destination:highlight, :highlight ref::label:highlight, :highlight ref::title:highlight)

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

### html-block (html-block:highlight)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>

## attributes

### attributes(:highlight) (key-value-attr:highlight, class-attr:highlight, id-attr:highlight, key-value-attr::tag:highlight, class-attr::tag:highlight, id-attr::tag:highlight)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:highlight normal) (:highlight key-value-attr, :highlight class-attr, :highlight id-attr, :highlight key-value-attr::tag, :highlight class-attr::tag, :highlight id-attr::tag)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:highlight :highlight) (:highlight key-value-attr:highlight, :highlight class-attr:highlight, :highlight :highlight id-attr:highlight, :highlight key-value-attr::tag:highlight, :highlight class-attr::tag:highlight, :highlight id-attr::tag:highlight)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

