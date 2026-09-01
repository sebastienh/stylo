
# text-decoration-line 

This property allows to specify the decoration type to use. There are four types of decorations: `none` the default, that is to say there is no decoration; `underline`, we underline the elements; `overline`, a line is placed above the elements; `line-through`, a line runs through the elements, this is equivalent to a strikethrough.

Formal definition: <code>text-decoration-line: none | underline | overline | line-through | [initial](#cssPropertyValuesInitial) 
| [inherit](#cssPropertyValuesInherit);</code>

It is possible to use several decorations at a time, for example, the following CSS decorates `h1` elements with a line above and a line below.:

CSS:

``` css
h1 {
    text-decoration-line: overline, underline; 
}   
```
