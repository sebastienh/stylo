


{.red}
******************* DISCLAIMER: ********************
******* This is a replacement of the old post*******   


After some days developing the attributes blocs for [Stylo](www.textually.net) I came out with an implementation which closely follows the draft proposal from @mb21 and the specifications stated in my previous message.   

All examples below, which are loosely inspired from the @mb21 draft proposal, will apply the following CSS and I show the final rendering in [Stylo](www.textually.net):

```css
.blue {
	color: blue;
}
.red {
	color: red;
}
.green {
	color: green;
}
.pink {
	color: pink;
}
```

This proposal follows the draft proposal on many points but simplifies it on others and add three new capabilities: 

1. Possibility to add attributes blocs before bloc.
2. Attributes aggregation of all attributes blocs pertaining to a bloc.
3. Inline attributes blocs are applied to the inline element defined before them, if there is no such element, they apply to the bloc in which they are defined.

There is also some difference with my last proposal: instead of allowing attributes blocs after only for terminating blocs, I followed the simpler rule of allowing an attributes bloc one the line below any bloc, like the draft proposal is suggesting.

On the simplifications side, 
- no requirement for the attributes blocs to follow the bloc indentation to apply to them
- also removed, is the necessity to have spacing (or no spacing) between the attributes blocs and the elements. The three rules below cover all cases without the need of such rules. 
- no line feed are allowed inside attributes blocs. This last rule could have become a problem as more attributes are added to an element, but since aggregation is supported they can just be added separatly, like here: 


{.green}
{.red}
{.blue}
Paragraph is green because .green selector has higher priority. 

  

# Rules 

So, here are the modified/new rules: 

1. if an attributes bloc is one line below a non-attributes bloc, it is always assigned to this bloc (the one above). One line below in this definition, means there is no blank lines between the end of the non-attributes bloc above and the attributes bloc, otherwise we get unintuitive results with list contination where a list is terminated by the attr-bloc a couple of lines below but is still considered on the line below because of lazy list continuation. 

2. if an attributes block is placed before (see definition below*), it is assigned to the first non-attributes bloc element below

3. otherwise, it is assigned to the first element on the left on the same line, unless this element is an attributes bloc, in which case it should apply to the first bloc it is contained in.


*An


# Some examples: 


## ATX Headers:

{#id .red}
### foo 

### foo {#id .red}

or 

### foo 
{#id .red}

are allowed.

Or inline: 

### foo {.red} ### 


Since the element parsing stays the same, putting the attributes bloc after the closing header sequence would result attributes to be applied to the whole content including the closing header sequence as it becomes part of the content because it is not closing the header content. So this would not be allowed:  

### foo ### {.red}

# horizontal rule 

--- {.red}

Following these rules, we don't care if there is spaces between the attributes bloc and the horizontal rule: 

---{.red #id}


In my implementation, a line feed inside an attributes bloc invalidate it, the same as blank lines inside it: 

---{.red 
#id}




# Setext headers

Foo {.red}
===========

# fenced code block 

In my case, fenced code blocks do not change. Since they are self-closing blocks they does not support inline elements. So, to add additionnal attributes, we must put them before of after the fenced code block: 

Before: 

{.red}
```
some text 
```

After: 

```
some text 
```
{.red}

This means that the same exact syntax is used for the fenced code params. 


# Reference Links

In the reference links case, there is no need for spaces before the attributes bloc (it is never required): 

[foo][bar]

[bar]: /url "title"{.red}


# Paragraphs 

As usual, attributes are supported before, inline and after: 

{.red}
Some text.

Some text.{.red}

Some text.
{.red}
 
Inline blocs, apply to the previous inline element unless, this previous inline element is itself an attributes bloc: 

Some {.red} text.

**Some** {.red} text.


There is no need for the attribute blocks to be indented exactly as much as the first line of the paragraph: if it is on the line below it applies to it, unless it is indented enough to become an indented code blcok: 

Some text.
 {.red}



Some text.
           {.red}


# Block quotes


No need for the attributes bloc to be indented as the block quote to apply to it, since it is on the line below at the same level, it is sufficient: 

> Blockquote with attributes.
 {.red}


> Paragraph with attributes
> inside a block quote.
> {.red}


The same rules apply inside a bloc quote, : 

> {.red}
> Paragraph with attributes
> inside a block quote.
> 
> Some more text. 
		

Bloc indentation does not change anything: 

   > Blockquote with attributes.
   {.red}

> Blockquote without attributes.
  {.red}

> Blockquote with
lazy continuation
{.red}

> Blockquote with
lazy continuation
  {.red}


# Lists

- list with
- attributes
{.red}


Attributes bloc that are not directly under a bloc are applied to the following one:  


{.blue}
- a tight list
- with lazy
continuation

{.red}

Red paragraph. 

The same goes for lists inside another bloc, here a blockquote: 

> {.blue}
> - a tight list
> - with lazy
> continuation
>
> {.red}
> 
> Red paragraph.
>


To get red color applied to the list, we need to put attributes bloc directly under it: 

{.blue}
- a tight list
- with lazy
continuation
{.red}

We can apply different attributes to the lists

{.blue}
- one 1
- two 2
    - 2.1
    {.red}


{.blue}
- one 1
- two 2
    - 2.1
    {.red}



- a loose list

- with attributes

{.red}


- loose list

- with attributes
{.red}


- a loose list

- without attributes


{.red}




- a loose list where

- the last paragraph has attributes.
  Note that the indentation of the
  attribute block is significant.
  {.red}



- a loose list

- with lazy
continuation
{.red}


- a tight list
{.red}
- with lazy
continuation



{.red}
Test 


- > Item text. 
  > 
  > a list where each
  > item is a blockquote
  > {.green}
  
- Some other text. 

- Some yellow text {.pink}

- > to see what is possible
  > 
  {.red}
{.blue}

- > Item text. 
  > 
  > a list where each
  > item is a blockquote
  > {.green}
  
- Some other text. 

  {.pink}
- Some yellow text 

- > to see what is possible
  > 
  {.red}
{.blue}


The attributes can be put before for the list too: 

{.blue}
- > Item text. 
  > 
  > a list where each
  > item is a blockquote
  > {.green}
  
- Some other text. 

  {.pink}
- Some yellow text 

- > to see what is possible
  > 
  {.red}




>
> rrr
> `foo` {.red}
>

{.red}
Some text.
      ssssssssss



Note that list items themselves can not have attributes.

`foo`{.red}

The spaces don't matter, rule number 3 is applied: 

`foo` {.red}

Or rule number 2: 

> rrrr
> `foo` {.red}
>

_foo_{.red}


**foo**{.red}

[link](/uri){.red}


![foo](/url){.red}


Allowed characters in attributes:


# test {att="w^$%^@"}


    {.eeee}


# fenced code block 

For the fenced code block, I followed the draft except one the criteria to have one space before the attributes bloc and I don't see the necessity for it. 





