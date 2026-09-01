


# h1 Heading (h1, h1::tag)
## h2 Heading (h2, h2::tag)
### h3 Heading (h3, h3::tag)
#### h4 Heading (h4, h4::tag)
##### h5 Heading (h5, h5::tag)
###### h6 Heading (h6, h6::tag)
 


## Horizontal rule
 
___ (hr)

--- (hr)

*** (hr)
 
## Emphasis:
 
**This is bold text** (strong, strong::tag)

__This is bold text__ (strong, strong::tag)

*This is italic text* (em, em::tag)

_This is italic text_ (em, em::tag)

~~Strikethrough~~ (s, s::tag)



## Blockquotes: (blockquote, blockquote::tag)
 
> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
 


## Lists:

Unordered (ul, li, li::tag)

+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!

Ordered (ol, li, li::tag)

1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa


1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar

## Code: (code, code::tag, code::params)

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


## Tables (table, thead, tbody, tr, td, table::tag)

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



## Links (a, a::tag, a::text, a::destination, a::label, a::title, img, img::tag, img::text, img::destination, img::label, img::title, ref, ref::tag, ref::text, ref::destination, ref::label, ref::title)

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

## attributes (key-value-attr, class-attr, id-attr, key-value-attr::tag, class-attr::tag, id-attr::tag)

{key=“value”}
Attributed text.

{.class}
Attributed text.

{#id}
Attributed text.


