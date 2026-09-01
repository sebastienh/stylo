
# Attributes

An element can have multiple attributes. An attribute has a name and a value. The name of an attribute must always be separated from the element name by at least one space. The value of an attribute is defined by  the name of the attribute followed by the `=` sign and then the value itself enclosed in quotation marks (`"`). The value contains a list of one or more value (word) separated by one or more space. In the following example we define the attribute `valid` with a value `true` for the `h1` element:

HTML:

``` html
<h1 valid="true">title 1</h1>
```

Here is another example with a list of words: 

HTML:

``` html
<h1 authors="john marc">title 1</h1>
```

Two attributes names are reserved and have special meaning in HTML, `id` and `class`.

## HTML Syntax

An attribute contains a name and a value separated by an equal sign "=" with optional space(s) before and after. An element can not contain two attributes with the same name. 

### Name

The name must be a sequence of one or more Unicode character not containing: 

> the space characters, U+0000 NULL, """, "'", ">", "/", "=", the control characters, and any characters that are not defined by Unicode.

### Value 

The value must be a sequence of one or more valid Unicode characters other than the `U+0000` and control characters (with the exception of [spaces characters](#html-space), which are allowed), optionally enclosed in two single quotes or two double quotes. If the value is enclosed in quotes, it must not contain the enclosing quote character. An attribute value can also contain HTML entity. 




