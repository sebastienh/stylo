
# color

In Stylo, the value of a color is ultimately represented by four components between 0 and 1: red, green, blue, and alpha. A color component with value 0 is absent; with value 1, the component is present at 100%. The intermediate values ​​determine the different variants in the presence of the component. In the case of the alpha component, the value 0 means that the color is completely transparent and the value 1, that it is completely opaque.

Pure red, is represented by: red: 1, green: 0, blue: 0, alpha: 0; white 1,1,1,1 and black: 0,0,0,1. All shades of gray use the three components in equal amounts, for example, a dark gray could be obtained with the components: 0.2,0,2,0,2,1.

## rgb

The `rgb(<red>,<green>,<blue>)` function allows to define a color by passing the value of the three color components with a number between 0 and 255 for each component. This number is ultimately divided by 255 to get a value between 0 and 1 as mentioned previously. The alpha value is set to 1 by default.

For example, to assign the red color to the `color` property of `h1` elements, we could use:

CSS:

``` css
h1 {
    color: rgb(255, 0,0);
}
```

Here, the `rgb` function was used with the red component at its maximum value of 255 (255/255 = 1) and the green and blue components are not present.

## rgba

The `rgba (<red>, <green>, <blue>, <alpha>)` function allows, like the `rgb` function, to define a color according to the three fundamental components with a value between 0 and 255, but also allows to specify the alpha component value.

For example, to assign the red color with an alpha of 0.5 to the `h1` elements `color` property, we could use:

CSS:

``` css
h1 {
    color: rgba(255, 0.0, 0.5);
}
```

Note: The `background-color` property of the body element does not support alpha component value different than 1 for perfomance reasons.  

## hexadecimal

An hexadecimal value is another way to represent the red, green, and blue color components. An hexadecimal value is introduced by the character "#" and followed by the hexadecimal characters of the value. Valid hexadecimal characters are: 0,1,2,3,4,5,6,7,8,9, a, b, c, d, e, f, case insensitive. For example, "#F00" represents the red color with an alpha to 255. 

| hexadecimal character | decimal value |
| ------ | ------ |
| 0 | 0 |
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 4 |
| 5 | 5 |
| 6 | 6 |
| 7 | 7 |
| 8 | 8 |
| 9 | 9 |
| A | 10 |
| B | 11 |
| C | 12 |
| D | 13 |
| E | 14 |
| F | 15 |


As a decimal value, for which each position represents a power of 10, in hexadecimal, each position represents a power of 16.

For example, the number 28 in decimal is:

2x10<sup>1</sup> + 8 x10<sup>0</sup> = 20 + 8 = 28

Reminder: \<any number\><sup>0</sup> = 1

The same number in hexadecimal is written as "1c" ("c" is 12):

1x16<sup>1</sup> + 12x16<sup>0</sup> = 16 + 12 = 28


For a full explanation of the hexadecimal characters, see the [Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) article on Wikipedia.
 
It is possible to express a color in hexadecimal with values ​​of several lengths, each length having its own interpretation.

1. three hexadecimal characters 

With a value of length 3, from left to right, the first character represents the red component; the second component, the green component; the third, the blue component. To get the value of each component, Stylo doubles the character. Thus, for the value `#abc`, the value used will be: `#aabbcc`, the `aa` characters  for the red component, the `bb` characters for the green component and finally, the `cc` characters for the blue component. The range of values ​​thus goes from 0 (0x16<sup>1</sup> + 0x16<sup>0</sup> = 0 + 0 = 0) to 255 (15x16<sup>1</sup> + 15x16<sup>0</sup> = 240 + 15 = 255). The value of the alpha (as in the rgb function mentioned above) will always default to 255.


For example, we could set the color red, for a level 1 title:

CSS:

``` css
h1 {
    color: #F00;
}
```


Which gives with the values doubled: `#FF0000`, and therefore, a value of 255 for the red component, 0 for the green component, 0 for the blue component, and 255 for the alpha, by default.

2. four hexadecimal characters 


The interpretation remains the same with four characters, all the values ​​are doubled and the components remain the same as for the first six characters except the added last two characters that are used to specify the color's alpha component. 

To define the red color with an alpha of 0.53, we will have:

CSS:

``` css
h1 {
    color: #F008;
}
```

3. six hexadecimal characters 


We find ourselves in the same case with three characters, except that the values ​​will not be doubled.

To obtain the pure blue color, we will use:

CSS:

``` css
h1 {
    color: #0000FF;
}
```

4. height hexadecimal characters

This time, we find ourselves in the same case as with four characters, except that the values ​​are not doubled: we can completely define a color with an 8 characters hexadecimal code, including its alpha component. For a green with an alpha component at 0.47:

CSS:

``` css
h1 {
    color: #00FF0078;
}
```

Calculation for the alpha value gives: 7x16<sup>1</sup> + 8x16<sup>0</sup> = 112 + 8 = 120 -> 120/255 = 0.47.


## keyword

Stylo supports all keywords supported by CSS. 

To assign the red color to the `color` property of elements of type `h1` we could use the following CSS:

CSS:

``` css
h1 {
    color: red;
}
```

Keywords allow quick access to the main colors in CSS. See the full list of Stylo [color keywords](#color-keywords). 

