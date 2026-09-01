
# Properties 

Currently, Stylo supports the following properties:

- [color](#cssColorProperty)
- [background-color](#cssBackgroundColorProperty)
- [font-size](#cssFontSizeProperty)
- [font-family](#cssFontFamilyProperty)
- [font-weight](#cssFontWeightProperty)
- [font-style](#cssFontStyleProperty)
- [text-decoration-style](#cssTextDecorationStyleProperty)
- [text-decoration-line](#cssTextDecorationLineProperty)
- [text-decoration-color](#cssTextDecorationColorProperty)

A property declaration takes the following general form:

CSS:

``` css
<property name>: <property value>;
```

To define a property, we must enter the property name, followed by a colon (':'), followed by the property value and, finally, end the declaration with a semicolon. 

It is possible to add the qualifier "!important" after the value of a property in order to increase its priority compared to the other values ​​assigned to this property (see [_Priority rules_](#priorityRules)). Here is an example that uses "!important":

CSS:

``` css
body {
    color: red! important;
}
```