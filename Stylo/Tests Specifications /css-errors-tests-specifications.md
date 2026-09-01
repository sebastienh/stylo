## CSS Errors 

### Expected colon error

Steps: 
- Enter `color blue;` in the CSS editor 
Result:
- Should get "Expected colon" error 

### Missing selector before combinator

Steps: 
- Enter 

 ``` css
+ test, h1 {

}

```
 
in the CSS editor 
Result:
- Should get "Missing  selector before combinator" error 
- The complex selector should be invalid with a warning "Invalid complex selector"

### Missing selector after combinator

Steps: 
- Enter 

 ``` css
test +, h1 {

}

```
 
in the CSS editor 
Result:
- Should get "Missing  selector after combinator" error 
- The complex selector should be invalid with a warning "Invalid complex selector"

### Invalid complex selector

Steps: 
- Enter 

 ``` css
test +, h1 {

}

```
 
in the CSS editor 
Result:
- Should get "Missing  selector after combinator" error 
- The complex selector should be invalid with a warning "Invalid complex selector"

### Invalid compound selector

I don't have this error anymore, the validations are done at the complex selector level to allow some sort of certainty. 

### Missing attribute name

Steps: 
- Enter 

 ``` css
[], h1 {

}

```
 
in the CSS editor 
Result:
- Should get "Missing attribute name" error 
- The complex selector should be invalid with a warning "Invalid complex selector"

### Missing attribute selector right square bracket

Steps: 
- Enter 

 ``` css
[name, h1 {

}

```
 
in the CSS editor 
Result:
- Should get "Expected right square bracket" error 
- The complex selector should be invalid with a warning "Invalid complex selector"

### Unexpected end of selector

We don't throw that error. 

### Missing exclamation point before important keyword: font-family declaration

Steps: 
- Enter 

 ``` css
... {
    font-family: "Avenir Next" important;
}
```
Result:
- Should get "Unsupported font-family: "important"" error 
- The complex selector should be invalid with a warning "Invalid declaration"

### Missing exclamation point before important keyword: color declaration

Steps: 
- Enter 

 ``` css
... {
    color: rgb(200,200,200) important;
}
```
Result:
- Should get "Missing exclamation point before important keyword" error 
- The complex selector should be invalid with a warning "Invalid declaration"

### Expected important keyword after exclamation point

Steps: 
- Enter 

 ``` css
... {
    color: #45233a !;
}
```
Result:
- Should get "Expected important keyword after exclamation point" error 
- The complex selector should be invalid with a warning "Invalid declaration"

Fail:
We get "Unexpected token"


### Unexpected character while parsing Unicode range

Steps: 
- Enter 

 ``` css

U+3213-U+3232

... {
    
}
```
Result:
- Should get "Unexpected character while parsing Unicode range" error 
- The complex selector should be invalid with a warning "Invalid declaration"

Fail:
We get "Unexpected token"


### Unable to convert number

Test needs to be done. 

### Unknown color

Steps: 
- Enter 

 ``` css

... {
    color: thth;
}
```
Result:
- Should get "Unknown color" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Invalid hex color value

Steps: 
- Enter 

 ``` css

... {
    color: #tretre;
}
```
Result:
- Should get "Invalid hex color value" error 
- The declaration should be invalid with a warning "Invalid declaration"


### Unsupported color function

Steps: 
- Enter 

 ``` css

... {
    color: rgbf(3,33,3);
}
```
Result:
- Should get "Unsupported color function" error 
- The declaration should be invalid with a warning "Invalid declaration"

Actual result: we get "Unsupported function" error which is acceptable

### Unsupported function

Steps: 
- Enter 

 ``` css

... {
    color: rgbf(3,33,3);
}
```
Result:
- Should get "Unsupported color function" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Too much arguments passed to function

Steps: 
- Enter 

 ``` css
... {
    color: rgb(3,33,3,444);
}
```
Result:
- Should get "Too much arguments passed to function" error 
- Should not get the "Alpha component is not in the 0 to 1 range"
- The declaration should be invalid with a warning "Invalid declaration"

### Not enough arguments passed to function: rgb

Steps: 
- Enter 

 ``` css
... {
    color: rgb(3,33);
}
```
Result:
- Should get "Not enough arguments passed to function" error 
- Should not get the "Alpha component is not in the 0 to 1 range"
- The declaration should be invalid with a warning "Invalid declaration"

### Not enough arguments passed to function: rgba

Steps: 
- Enter 

 ``` css
... {
    color: rgba(3,33);
}
```
Result:
- Should get "Not enough arguments passed to function" error 
- Should not get the "Alpha component is not in the 0 to 1 range"
- The declaration should be invalid with a warning "Invalid declaration"

### Invalid argument passed to function
### No arguments passed to function
### Color is not in the 0 to 255 range
### Color percentage is not in the 0 to 100 range
### Alpha component is not in the 0 to 1 range
### Alpha value in color is not supported when set as body background color

### Hue component is not in the 0 to 360 range

Steps: 
- Enter 

 ``` css
... {
    background-color: hsl(420, 100%, 50%); 
}
```
Result:
- Should get "Hue component is not in the 0 to 360 range" error 
- The declaration should be invalid with a warning "Invalid declaration"

### HSL hue component must be expressed in degrees from 0 to 360 and not in percentage

Steps: 
- Enter 

 ``` css
... {
    background-color: hsl(42%, 100%, 50%); 
}
```
Result:
- Should get "HSL hue component must be expressed in degrees from 0 to 360 and not in percentage" error 
- The declaration should be invalid with a warning "Invalid declaration"


### Expecting comma at this position

This error is not raised. 

### Unexpected character at this position

This error is not raised. 

### Unsupported font-style

Steps: 
- Enter 

 ``` css
... {
    font-style: blue; 
}
```
Result:
- Should get "Unsupported font-style" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-variant

This error is not raised. 

### Unsupported font-size keyword

Steps: 
- Enter 

 ``` css
... {
    font-size: blue; 
}
```
Result:
- Should get "Unsupported font-size keyword" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-size unit

Steps: 
- Enter 

 ``` css
... {
    font-size: 20.0th; 
}
```
Result:
- Should get "Unsupported font-size unit" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-size value

Steps: 
- Enter 

 ``` css
... {
    font-size: -440.0px; 
}
```
Result:
- Should get "Unsupported font-size value" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-weight keyword

Steps: 
- Enter 

 ``` css
... {
    font-weight: red; 
}
```
Result:
- Should get "Unsupported font-weight keyword" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-weight value

Steps: 
- Enter 

 ``` css
... {
    font-weight: 2000; 
}
```
Result:
- Should get "Unsupported font-weight value" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-weight value type(real number)

Steps: 
- Enter 

 ``` css
... {
    font-weight: 2000; 
}
```
Result:
- Should get "Unsupported font-weight value" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unsupported font-stretch

Steps: 
- Enter 

 ``` css
... {
    font-strech: djdjd; 
}
```
Result:
- Should get "Unsupported font-weight value" error 
- The declaration should be invalid with a warning "Invalid declaration"

Actual result: 

Since font-strech property is not supported yet, we get the error: "Unsupported of invalid property: "font-strech"" which is totally ok. 


### Unsupported text-decoration-style keyword

Steps: 
- Enter 

 ``` css
... {
    text-decoration-style: djdjd; 
}
```
Result:
- Should get "Unsupported text-decoration-style keyword" error 
- The declaration should be invalid with a warning "Invalid declaration"

### None value should be alone : consider removing

This error is not raised. 

### Unsupported font-family

Steps: 
- Enter 

 ``` css
... {
    font-family: "sss"; 
}
```
Result:
- Should get "Unsupported font-family" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Unexpected token

Steps: 
- Enter 

 ``` css
... {
    text-decoration-style: djdjd none; 
}
```
Result:
- Should get "Unexpected token" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Invalid declaration

Steps: 
- Enter 

 ``` css
... {
    text-decoration-style: djdjd none; 
}
```
Result:
- Should get "Invalid declaration" error 
- The declaration should be invalid with a warning "Invalid declaration"

### Invalid pseudo selector syntax

Error is not raised.

### Compound selector is empty

Error is not raised.

### Unsupported or invalid property

Steps: 
- Enter 

 ``` css
... {
    font-s: djdjd; 
}
```
Result:
- Should get "Unsupported or invalid property" error 
- The declaration should be invalid with a warning "Invalid declaration" 

### Missing end semi-colon

Steps: 
- Enter "color: blue" in the CSS editor 
Result:
- Should get "Expected colon" error 

### Unexpected function

Error is not raised.

### Unexpected parameter

Error is not raised.

### Following siblings selector may impact performance

Steps: 
- Enter 

 ``` css
h1 ~ p {
    
}
```
Result:
- Should get "Following siblings selector may impact performance" error 
- The declaration should be invalid with a warning "Invalid declaration" 

### Ignored default namespace definition.



### This selector does not select anything



### Missing URI

Steps: 
- Enter 

 ``` css
@namespace ;

```

Result:
- Should get "Missing URI" error 
- The declaration should be invalid with a warning "Invalid declaration" 

### Unsupported pseudo-element

Steps: 
- Enter 

 ``` css
h1::p {
    
}
```
Result:
- Should get "Unsupported pseudo-element" error 
- The declaration should be invalid with a warning "Invalid declaration" 


### Pseudo-class selector is not supported

Steps: 
- Enter 

 ``` css
h1:p {
    
}
```
Result:
- Should get "Pseudo-class selector is not supported" error 
- The declaration should be invalid with a warning "Invalid declaration" 

