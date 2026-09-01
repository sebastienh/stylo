
# length 

The type _length_ in CSS defines a length.

The syntax of _length_ is a decimal number followed by a unit.

## Units relative to the font size 

### em 

This unit applies the decimal number as a multiplier to the value we would normally have after cascading for this property.

For example:

CSS:

``` css 
body {
    font-size: 10px;
}
h1 {
    font-size: 1.2em; 
}
```

In the following document, for `h1` element font-size value: 

HTML:

``` html
<!doctype html>
<html>
    <body>
        <h1>title 1</h1> 
    </body>
</html>
```


We get: 1.2 x 10 = 12px

### ex 

The value is calculated from the current font "[x-height](https://en.wikipedia.org/wiki/X-height)" value. As in the case of "em" we prefix the unit with the multiplier to apply to it.

### ch 

Value relative to the width of the "0" in the current font.

### rem 

Value relative to the font size of the root element.

## Units relative to viewport size 

The "viewport" in Stylo is the screen. And all the values ​​related to the viewport are calculated according to the size of the screen.

### vw

Value equivalent to 1% of the viewport's width.

### vh

Value equivalent to 1% of the viewport's height.

### vmin

Value equivalent to 1% of the viewport 's smallest dimension.

### vmax

Value equivalent to 1% of the viewport's largest dimension.


## Absolute units 
 
Absolute units are based on units of known length.

| Unit | Description |
| ----- | -------- |
| Cm | centimeters |
| Mm | millimeters |
| In | inches (1in = 96px = 2.54cm) |
|px | pixels (1px = 1 / 96th of 1in)|
| Pt | points (1pt = 1/72 of 1in) |
| Pc | picas (1pc = 12 pt) | 

