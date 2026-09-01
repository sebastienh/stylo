
# Lists  

A list in Markdown, equivalent to the element _ul_ or _ol_, for _unordered list_ and _ordered list_, is a sequence of elements that belongs to the same logical set. As in its HTML version, a list can be ordered or unordered.

## Syntax

### Unordered 

The `*`, `-` or the `+` can be used to create unordered lists. At the start of each line of a list, simply use the same marker for all list items inside one list. 

Markdown: 

``` markdown 
* list element
* list element
* list element
```
or 

``` markdown 
- list element
- list element
- list element
```
or 

``` markdown 
+ list element
+ list element
+ list element
```

HTML:

``` html
<ul>
    <li>list element</li>
    <li>list element</li>
    <li>list element</li>
</ul>
```

Using a different marker force to start a new list. 

Markdown:

``` markdown 
- item one
- item two
+ other list item one
+ other list item  two
```

HTML:

``` html 
<ul>
    <li>item one</li>
    <li>item two</li>
</ul>
<ul>
    <li>other list item one</li>
    <li>other list item two</li>
</ul>
```


### Ordered   

The `<number>.` or the `<number>)` syntax can be used to create ordered lists.

Markdown:

``` markdown 
1. first item  
2. second item 
3. third item 
```
or 

``` markdown 
1) first item  
2) second item 
3) third item 
```

HTML:

``` html 
<ol>
    <li>first item</li>
    <li>second item</li>
    <li>third item</li>
</ol>
```

We can also start the numbering at a specific value, as in the following example:

Markdown:

``` markdown 
57. item 57
1. item 58
```

HTML:

``` html 
<ol start="57">
    <li>item 57</li>
    <li>item 58</li>
</ol>
```


### Nested 

To nest a list inside another list simply indent all items of the nested list by a minimum of two spaces from the start of the line of the nesting list. 

Markdown:

``` markdown 
- item one
- item two
  + nested list using two spaces after the start of nesting list  
  + nested sublist item 
    * another nested list started two spaces after the nesting list (four from the start)
    * another nested list
```

HTML:

``` html
<ul>
    <li>item one</li>
    <li>item two
        <ul>
            <li>nested list using two spaces after the start of nesting list </li>
            <li>nested sublist item
                <ul>
                    <li>another nested list, started two spaces after the nesting list, four spaces after the list nesting the nesting list</li>
                    <li>another nested list</li>
                </ul>
            </li>
        </ul>
    </li>
</ul>
```

## Pseudo-elements  

In the case of lists, the list items are the elements that contain pseudo-element, and there is one:

- `tag`: covers the list item mark

In the previous example we could put "57." and "1." in red using the following CSS:

CSS: 

``` css
li::tag {
    color: blue;
}
```

or more specifically the elements of any ordered lists:

CSS:

``` css
ol li::tag {
    color: blue;
}
```
