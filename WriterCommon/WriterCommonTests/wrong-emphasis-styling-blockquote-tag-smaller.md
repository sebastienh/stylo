


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





# Some examples: 


## ATX Headers:

{#id .red}
### foo 

### foo {#id .red}

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





