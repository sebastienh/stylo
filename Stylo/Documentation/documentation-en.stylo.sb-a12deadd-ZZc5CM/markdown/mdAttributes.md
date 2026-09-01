
# Attributes

After developing the attributes blocs for [Stylo](www.textually.net) I came out with an implementation which follows in part the draft proposal from @mb21 and the specifications stated in my previous message (which this message replace). 

All examples below, which are loosely inspired from the @mb21 draft proposal, will apply the following CSS and I show the final rendering in Stylo:

```css

.blue {
    color: blue;
}
.red {
    color: red;
}
.green {
    color: #44bec7;
}
.pink {
    color: pink;
}


```


This proposal follows the draft proposal on many points but simplifies it on others and add three new capabilities: 

1. Possibility to add attributes blocs before bloc.

2. Attributes aggregation of all attributes blocs pertaining to a bloc.

3. Inline attributes blocs are applied to the inline element defined before them, if there is no such element, they apply to the bloc in which they are defined, the enclosing bloc.	

There is also some difference with my last proposal: instead of allowing attributes blocs after only for terminating blocs, I followed the simpler rule of allowing an attributes bloc one the line below any bloc, like the draft proposal is suggesting.

On the simplifications side, 

- no requirement for the attributes blocs to follow the bloc indentation to apply to them, unless normal parsing implies such necessity e.g. a list of paragraphs 

- also removed, is the necessity to have spacing (or no spacing) between the attributes blocs and the elements. The three rules below cover all cases without the need of such rules. 

- no line feed are allowed inside attributes blocs. This last rule could have become a problem as more attributes are added to an element, but since aggregation is supported they can just be added separately, like here: 
 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attribute-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attribute-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="green">Paragraph is green because .green selector has higher priority.</span>
</code></pre>

# Rules 

So, here are the modified/new rules: 

1. if an attributes bloc is one line below a non-attributes bloc, it is always assigned to this bloc (the one before). One line below in this definition, means there is no blank lines between the end of the non-attributes bloc before and the attributes bloc, otherwise we get unintuitive results with list continuation where a list is terminated by the attr-bloc a couple of lines below but is still considered on the line below because of lazy list continuation. 

2. if an attributes block is placed before (see definition of _before_ and _after_ below*), it is assigned to the first non-attributes bloc element after

3. otherwise, it is assigned to the first element on the left on the same line, unless this element is an attributes bloc, in which case it should apply to the first bloc it is contained in.

*An attributes bloc can be defined inline e.g. inside a paragraph, or as a bloc, at the root or inside another bloc. *_* *Before* *_* or *_* *after* *_* refers to the relative position of an attributes bloc relatively to another bloc level element under the same bloc or the root. The notion is quite intuitive in fact: 

Attributes bloc after: 

Example 1: 

<pre><code>
<span class="red">Red paragraph with attributes after.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Or: 

Example 2: 

<pre><code>
<span class="blockquote-tag">></span><span class="red"> Red paragraph with attributes after.</span>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Attributes bloc before: 

Example 3: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red paragraph with attributes before.</span>
</code></pre>

Or: 

Example 4: 

<pre><code>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Red paragraph with attributes before.</span>
</code></pre>

To be considered a bloc, the attributes bloc must not be followed by anything else than whitespaces: 

Example 5: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span><span class="red"> Red paragraph with inline attributes bloc.</span>
This paragraph does not inherit the attributes before because they are considered <em>inline</em>.
</code></pre>

# Some examples: 

## ATX Headers:

Before: 

Example 6: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
<span class="heading-tag">###</span> <span class="red">foo</span>
</code></pre>

inline:

Example 7: 

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo</span> <span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
</code></pre>

or after:

Example 8: 

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo</span>
<span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
</code></pre>

are allowed.

Or inline: 

Example 9: 

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> <span class="heading-tag">###</span>
</code></pre>

There is also some difference with my last proposal: instead of allowing attributes blocs after only for terminating blocs, I followed the simpler rule of allowing an attributes bloc one the line below any bloc, like the draft proposal is suggesting.

On the simplifications side, 

- no requirement for the attributes blocs to follow the bloc indentation to apply to them, unless normal parsing implies such necessity e.g. a list of paragraphs 

- also removed, is the necessity to have spacing (or no spacing) between the attributes blocs and the elements. The three rules below cover all cases without the need of such rules. 

- no line feed are allowed inside attributes blocs. This last rule could have become a problem as more attributes are added to an element, but since aggregation is supported they can just be added separately, like here: 

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo ### </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

# horizontal rule 

Example 11: 

<pre><code>
<span class="red">---</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Following these rules, we don't care if there is spaces between the attributes bloc and the horizontal rule: 

Example 12:

<pre><code>
<span class="red">---</span><span class="attributes-tag">{</span><span class="attribute">.red #id</span><span class="attributes-tag">}</span>
</code></pre>

In my implementation, a line feed inside an attributes bloc invalidate it, the same as blank lines inside it: 

Example 13:

<pre><code>
---{.red 
#id}
</code></pre>

# Setext headers

Example 14:

<pre><code>
<span class="red">Foo </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="attributes-tag">==========</span>
</code></pre>

# fenced code block 

As in the draft proposal, an attributes bloc can be put in place of the usual params or "info string" and become "syntactic sugar for classes".

But attributes can be put before or after as with any other bloc element:

Before: 

Example 15:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="fence-tag">```</span>
<span class="red">some text</span>
<span class="fence-tag">```</span>
</code></pre>

After: 

Example 16:

<pre><code>
<span class="fence-tag">```</span>
<span class="red">some text</span>
<span class="fence-tag">```</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
</code></pre>

Replacing the params:  

Example 17: 

<pre><code>
<span class="fence-tag">```</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="red">some text</span>
<span class="fence-tag">```</span>
</code></pre>

# Reference Links

In the reference links case, there is no need for spaces before the attributes bloc: 

Example 18:


<pre><code>
<span class="reference-tag">[</span><span class="red">foo</span><span class="reference-tag">]</span><span class="reference-tag">[</span>bar<span class="reference-tag">]</span>
<span class="reference-tag">[</span><span class="red">bar</span><span class="reference-tag">]:</span> /url "title"<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="reference-tag">[</span><span class="blue">bar</span><span class="reference-tag">]:</span> /url "title"<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>


In the previous example, only the first attributes are propagated since it is the active reference (because it is the first one).

For now, in Stylo, the attributes propagation to the referencing links and images is applied. I am still not sure about this feature though. For me it agravates the problem on non-locality of the information and adds the necessity to look at the reference to know the attributes applied to the link or images. It is acceptable but not an ideal situation. 

# Paragraphs 

As usual, attributes are supported before, inline and after: 

Before: 

Example 19:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red paragraph with attributes before.</span>
</code></pre>

Inline: 

Example 20:

<pre><code>
<span class="red">Red paragraph with inline attributes.</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

After: 

Example 21:

<pre><code>
<span class="red">Red paragraph with attributes after.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>
 
Inline blocs, apply to the previous inline element unless, this previous inline element is itself an attributes bloc: 

Example 22:


<pre><code>
<span class="red">Red paragraph with attributes <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> inside.</span>
</code></pre>


Example 23:

<pre><code>
<span class="strong-tag">**</span><span class="red">Red emphasized text</span><span class="string-tag">**</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> text.
</code></pre>


If the previous element is an attribute bloc then the attributes apply to the enclosing bloc: 

Example 24:

<pre><code>
<span class="strong-tag">**</span><span class="red">Red emphasized text</span><span class="strong-tag">**</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span> <span class="blue">blue text.</span>
</code></pre>

There is no need for the attribute blocks to be indented exactly as much as the first line of the paragraph: if it is on the line below it applies to it: 

Example 25:

<pre><code>
<span class="red">Red text with attributes after.</span>
 <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

# Block quotes

No need for the attributes bloc to be indented as the block quote to apply to it, since it is on the line below at the same level, it is sufficient: 

Example 26:

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with attributes.</span>
 <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 27:

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Paragraph with attributes.</span>
<span class="blockquote-tag">></span> <span class="red">inside a blockquote.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

The same rules apply inside a bloc quote, : 

Example 28:

<pre><code>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Paragraph with attributes.</span>
<span class="blockquote-tag">></span> <span class="red">inside a blockquote.</span>
<span class="blockquote-tag">></span>
<span class="blockquote-tag">></span> Some more text.
</code></pre>

Bloc indentation does not change anything: 

Example 29:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
   <span class="blockquote-tag">></span> <span class="blue">Blockquote with attributes.</span>
     <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

But as we can see, depending on where the attributes belong they apply to different blocs (remember that red has higher priority than blue in the CSS style): 

Example 30:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
   <span class="blockquote-tag">></span> <span class="red">Blockquote with attributes.</span>
   <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 31:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Blockquote without attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 32:

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with</span>
<span class="red">lazy continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 33:

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with</span>
<span class="red">lazy continuation.</span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

# Lists

Example 34:

<pre><code>
<span class="list-tag">- </span> <span class="red">List with</span>
<span class="list-tag">- </span> <span class="red">attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Attributes blocs that are not directly under a bloc are applied to the following one:  

Example 35:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">A tight list</span>
<span class="list-tag">- </span> <span class="blue">with lazy</span>
<span class="blue">continuation.</span>

<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>

<span class="red">Red paragraph.</span>
</code></pre>


The same goes for lists inside another bloc, here a blockquote: 

Example 36:

<pre><code>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="list-tag">- </span> <span class="blue">A tight list</span>
<span class="blockquote-tag">></span> <span class="list-tag">- </span> <span class="blue">with lazy</span>
<span class="blockquote-tag">></span> <span class="blue">continuation.</span>
<span class="blockquote-tag">></span> 
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> 
<span class="blockquote-tag">></span> <span class="red">Red paragraph.</span>
<span class="blockquote-tag">></span> 
</code></pre>

To get red color applied to the list, we need to put attributes bloc directly under it: 

Example 37:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="red">A tight list</span>
<span class="list-tag">- </span> <span class="red">with lazy</span>
<span class="red">continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

We can apply different attributes to the lists

Example 38:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">1</span>
<span class="list-tag">- </span> <span class="blue">2</span>
    <span class="list-tag">- </span> <span class="red">2.1</span>
    <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 39:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">1</span>
<span class="list-tag">- </span> <span class="blue">2</span>
    <span class="list-tag">- </span> <span class="red">2.1</span>
    <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>


<span class="list-tag">- </span> <span class="blue">a loose list</span>

<span class="list-tag">- </span> <span class="blue">with attributes.</span>
</code></pre>

Example 40:

<pre><code>
<span class="list-tag">- </span> <span class="red">A loose list</span>

<span class="list-tag">- </span> <span class="red">with attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 41:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">A loose list where</span>

<span class="list-tag">- </span> <span class="red">The last paragraph has attributes.</span>
  <span class="red">Note that the indentation of the</span>
  <span class="red">attributes block is significant depending</span>
  <span class="red">on if the attributes bloc after is part of the</span>
  <span class="red">list or the paragraph (here paragraph case).</span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 42:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="red">A loose list where</span>

<span class="list-tag">- </span> <span class="red">The last paragraph has attributes.</span>
  <span class="red">Note that the indentation of the</span>
  <span class="red">attributes block is significant depending</span>
  <span class="red">on if the attributes bloc after is part of the</span>
  <span class="red">list or the paragraph (here list case).</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 43:

<pre><code>
<span class="list-tag">- </span> <span class="green">A loose list</span>

<span class="list-tag">- </span> <span class="green">with lazy</span>
<span class="green">continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attributes-tag">}</span>
</code></pre>

{.darkblue}
Example 44:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red text.</span>


<span class="list-tag">- </span><span class="blockquote-tag">> </span></span><span class="blue">Item text.</span>
  <span class="blockquote-tag">> </span>
  <span class="blockquote-tag">> </span><span class="green">A list where each</span>
  <span class="blockquote-tag">> </span><span class="green">item is a blockquote</span>
  <span class="blockquote-tag">> </span><span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attributes-tag">}</span>

<span class="list-tag">- </span><span class="blue">Text without specific attributes, the list ones apply.</span>

<span class="list-tag">- </span><span class="pink">Some pink text.</span> <span class="attributes-tag">{</span><span class="attribute">.pink</span><span class="attributes-tag">}</span>

<span class="list-tag">- </span><span class="blockquote-tag">> </span><span class="red">Paragraph inside a red blockquote.</span>
  <span class="blockquote-tag">> </span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Pink class attribute is put on top: 

Example 45:

<pre><code>
<span class="list-tag">- </span><span class="blockquote-tag">> </span></span><span class="blue">Item text.</span>
  <span class="blockquote-tag">> </span>
  <span class="blockquote-tag">> </span><span class="green">A list where each</span>
  <span class="blockquote-tag">> </span><span class="green">item is a blockquote</span>
  <span class="blockquote-tag">> </span><span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attributes-tag">}</span>

<span class="list-tag">- </span><span class="blue">Text without specific attributes, the list ones apply.</span>

  <span class="attributes-tag">{</span><span class="attribute">.pink</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span><span class="pink">Some pink text.</span> 

<span class="list-tag">- </span><span class="blockquote-tag">> </span><span class="red">Paragraph inside a red blockquote.</span>
  <span class="blockquote-tag">> </span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

The attributes can be put before for the list too: 

Example 46:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span><span class="blockquote-tag">> </span></span><span class="blue">Item text.</span>
  <span class="blockquote-tag">> </span>
  <span class="blockquote-tag">> </span><span class="green">A list where each</span>
  <span class="blockquote-tag">> </span><span class="green">item is a blockquote</span>
  <span class="blockquote-tag">> </span><span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attributes-tag">}</span>

<span class="list-tag">- </span><span class="blue">Text without specific attributes, the list ones apply.</span>

  <span class="attributes-tag">{</span><span class="attribute">.pink</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span><span class="pink">Some pink text.</span> 

<span class="list-tag">- </span><span class="blockquote-tag">> </span><span class="red">Paragraph inside a red blockquote.</span>
  <span class="blockquote-tag">> </span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

# inline code

The spaces don't matter: 

Example 47:

<pre><code>
<span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

or 

Example 48:

<pre><code>
<span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Example 49:

<pre><code>
<span class="blockquote-tag">> </span>Bar.
<span class="blockquote-tag">> </span><span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">> </span>
</code></pre>

# emphasis

Example 50:

<pre><code>
<span class="emphasis-tag">_</span><span class="blue"><em>foo</em></span><span class="emphasis-tag">_</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 51:

<pre><code>
<span class="strong-tag">**</span><span class="blue"><strong>foo</strong></span><span class="strong-tag">**</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

# links

Example 52:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span>
</code></pre>

Example 53:

<pre><code>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 54:

<pre><code>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

# images

Example 55:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span>
</code></pre>

Example 56:

<pre><code>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 57:

<pre><code>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

# reference 

Example 58:

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net
</code></pre>

Example 59:

<pre><code>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

Example 60:

<pre><code>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

