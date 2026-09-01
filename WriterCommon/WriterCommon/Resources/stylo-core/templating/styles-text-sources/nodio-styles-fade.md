


body:fade {
    
}

# h1 Heading (h1:fade, h1::tag:fade)
## h2 Heading (h2:fade, h2::tag:fade)
### h3 Heading (h3:fade, h3::tag:fade)
#### h4 Heading (h4:fade, h4::tag:fade)
##### h5 Heading (h5:fade, h5::tag:fade)
###### h6 Heading (h6:fade, h6::tag:fade)
 


## Horizontal rule
 
___ (hr:fade)

--- (hr:fade)

*** (hr:fade)
 
## Emphasis:
 

### Emphasis: (:fade)

**This is bold text** (strong:fade, strong::tag:fade)

__This is bold text__ (strong:fade, strong::tag:fade)

*This is italic text* (em:fade, em::tag:fade)

_This is italic text_ (em:fade, em::tag:fade)

~~Strikethrough~~ (s:fade, s::tag:fade)

### Emphasis: (:fade normal)

**This is bold text** (:fade strong, :fade strong::tag)

__This is bold text__ (:fade strong, :fade strong::tag)

*This is italic text* (:fade em, :fade em::tag)

_This is italic text_ (:fade em, :fade em::tag)

~~Strikethrough~~ (:fade s, :fade s::tag)

### Emphasis: (:fade :fade)

**This is bold text** (:fade strong:fade, :fade strong::tag:fade)

__This is bold text__ (:fade strong:fade, :fade strong::tag:fade)

*This is italic text* (:fade em:fade, :fade em::tag:fade)

_This is italic text_ (:fade em:fade, :fade em::tag:fade)

~~Strikethrough~~ (:fade s:fade, :fade s::tag:fade)


## Blockquotes:

### Blockquotes: (blockquote:fade, blockquote::tag:fade)


 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


### Blockquotes: (:fade  blockquote, :fade blockquote::tag)
 
> Blockquotes can also be nested...
> > ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.


### Blockquotes: (:fade  blockquote:fade, :fade blockquote::tag:fade)
 
> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.




## Lists:

### Lists: (:fade)

Unordered (ul:fade, li:fade, li::tag:fade)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol:fade, li:fade, li::tag:fade)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


### Lists: (:fade normal)

Unordered (:fade ul, :fade li, :fade li::tag)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:fade ol, :fade li, :fade li::tag)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

### Lists: (:fade :fade)

Unordered (:fade ul:fade, :fade li:fade, :fade li::tag:fade)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (:fade ol:fade, :fade li:fade, :fade li::tag:fade)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar


## Code


### Code: (:fade) (code:fade, code::tag:fade, code::params:fade)

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

### Code: (:fade normal) (:fade code, :fade code::tag)

Inline `code`



## Tables


### Tables (:fade)(table:fade, thead:fade, tbody:fade, tr:fade, td:fade, table::tag:fade)

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

### Tables (:fade normal)(:fade thead, :fade tbody, :fade tr, :fade td, :fade table::tag)

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


### Tables (:fade :fade)(:fade thead:fade, :fade tbody:fade, :fade tr:fade, :fade td:fade, :fade table::tag:fade)

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


### Links (:fade)(a:fade, a::tag:fade, a::text:fade, a::destination:fade, a::label:fade, a::title:fade, img:fade, img::tag:fade, img::text:fade, img::destination:fade, img::label:fade, img::title:fade, ref:fade, ref::tag:fade, ref::text:fade, ref::destination:fade, ref::label:fade, ref::title:fade)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"


### Links (:fade normal)(:fade a, :fade a::tag, :fade a::text, :fade a::destination, :fade a::label, :fade a::title, :fade img, :fade img::tag, :fade img::text, :fade img::destination, :fade img::label, :fade img::title, :fade ref, :fade ref::tag, :fade ref::text, :fade ref::destination, :fade ref::label, :fade ref::title)

[link text](http://dev.nodeca.com)

[link with title](http://nodeca.github.io/pica/demo/ "title text!")


## Images

![Minion](https://octodex.github.com/images/minion.png)
![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

![Alt text][id]

With a ref later in the document defining the URL location:

[id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

### Links (:fade :fade)(:fade a:fade, :fade a::tag:fade, :fade a::text:fade, :fade a::destination:fade, :fade a::label:fade, :fade a::title:fade, :fade img:fade, :fade img::tag:fade, :fade img::text:fade, :fade img::destination:fade, :fade img::label:fade, :fade img::title:fade, :fade ref:fade, :fade ref::tag:fade, :fade ref::text:fade, :fade ref::destination:fade, :fade ref::label:fade, :fade ref::title:fade)

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

### html-block (html-block:fade)

<html>
    <body>
        <p>
            Paragraph.
        </p>
    </body>
</html>

## attributes

### attributes(:fade) (key-value-attr:fade, class-attr:fade, id-attr:fade, key-value-attr::tag:fade, class-attr::tag:fade, id-attr::tag:fade)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:fade normal) (:fade key-value-attr, :fade class-attr, :fade id-attr, :fade key-value-attr::tag, :fade class-attr::tag, :fade id-attr::tag)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

### attributes(:fade :fade) (:fade key-value-attr:fade, :fade class-attr:fade, :fade :fade id-attr:fade, :fade key-value-attr::tag:fade, :fade class-attr::tag:fade, :fade id-attr::tag:fade)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.

