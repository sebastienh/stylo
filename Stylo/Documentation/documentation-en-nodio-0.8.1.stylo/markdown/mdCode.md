      
# Code 

A code element is any element that contains source code, generally a programming language or a markup language. There are three types of Markdown code elements: _inline_, _fenced_ and _indented_.

Elements of this type are used in Markdown to indicate that a text section is not part of the same syntactic space as the current document.

In the following example:

Markdown: 

``` markdown
# title
```
  
the Markdown title "# title" is not a title according to the current syntax space: it is in the block of code that contains it, but in the current document, it is source code inside a code block.

## Syntax

### Inline 

An inline code element is most often defined within a line and is delimited by two "`" grave accents, one at the beginning, and the other at the end of the text section that we want to define as a _code_ element.

Markdown:

``` markdown
A line with `code`.
```

HTML:

``` html
<p>
    A line with <code> code </ code>.
</p>
``` 
           
### Fenced 

The fenced code syntax is used to define a code element on several lines. It makes it possible to define the beginning of the code and the end on different lines. In this case, it will be necessary to use three grave accents side by side at the beginning of a line, optionally followed by a parameter, generally the name of the language used, and ended with three grave accents. All text between these two tags will be considered code. Here is an example:
 
Markdown: 

<pre><code>
``` swift
func estEven(number: Int) -> Bool {
    return number%2 == 0 
}
```
</code></pre>
 
HTML:

``` html
<pre><code>func estEven(number: Int) -> Bool {
    return number%2 == 0 
}
</code></pre>
```
          
{#indentedCodeBlock}
### Indented 

A third alternative to defining a code section is the indented syntax. Just place 4 or more spaces at the beginning of each line of code, as below:

Markdown / HTML:

``` html 
<pre><code>
    // Comment
    line 1 of the code
    line 2 of the code
    line 3 of the code
</pre></code>
```
   
HTML:

``` html
<pre><code>
    // Comment
    line 1 of the code
    line 2 of the code
    line 3 of the code
</pre></code>
```
                
## Pseudo-elements   

The inline code and the fenced code supports the following pseudo-elements:

- `tag`: defines the opening and closing tags text of the two code versions syntax: ```` ` ```` in the online code and <code>```</code> in the case of the closed code.

And the fenced code also supports the pseudo-element:

- `params`: which contains the text portion of the parameters of the fenced code opening tag.
  