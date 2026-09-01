
# font-weight 

The `font-weight` property  allows to assign a thickness to a font. All values ​​are converted into one of the following numbers: 100, 200, 300, 400, 500, 600, 700, 800, 900, ranging from the thinnest (100) to the thickest (900). The value 400 is equivalent to normal and the value 700 is equivalent to bold.

Formal definition: <code>
font-weight: normal | bold | bolder | lighter | number
| [initial](#cssPropertyValuesInitial) 
| [inherit](#cssPropertyValuesInherit);</code>

The two keywords `lighter` and `bolder` define the value of the thickness of the current font relative to the inherited thickness. The final value is computed using this table: 

|Inherited value| bolder | lighter |
|--|---|---|
| 100 | 400| 100 |
| 200 | 400 | 100 |
| 300 | 400 | 100 |
| 400 | 700 | 100 |
| 500 | 700 | 100 |
| 600 | 900 | 400 |
| 700 | 900 | 400 |
| 800 | 900 | 700 |
| 900 | 900 | 700 |

In the following example, we give `h1` elements `font-weight` property the `bold` value:

CSS:

``` css 
h1 {
    font-weight: bold; 
}
```  