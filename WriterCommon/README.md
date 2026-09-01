#  Writer Common notes  

## Attributes compilation process





## Stylesheet resources origins  rules 

Any user stylesheet should end with "user" e.g. "simple-user.css" 
Any user agent stylesheet should end with "ua" e.g. "simple-ua.css"
Any other stylesheet is considered an "author" stylesheet.  


## Stylesheet for CSS writing rules 

The css-style-sheet element should define a color attribute, for it the be applied when to other colors applies. It is also the only element where we can define,
font value because we want uniformity in the stylesheet.


## Generate protocol buffers 

`protoc --swift_opt=Visibility=Public --swift_out=. ./stylo.proto`
