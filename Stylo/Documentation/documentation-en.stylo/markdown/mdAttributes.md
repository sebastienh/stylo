# Markdown Attributes 
    
Markdown attributes allow to assign [id](../html/#id), [class](../html/#class) and [attributes](../html/#attributes) to Markdown elements using Markdown syntax instead of raw HTML. 

Markdown attributes are composed of two parts, firstly, the attributes themselves which can be of [id](../html/#id), [class](../html/#class) or [attributes](../html/#attributes) types, and secondly, the attributes blocs which allow to group together attributes to be assigned to Markdown elements.

An attributes bloc take the general form: 

```
{ <attribute-1> <...> <attribute-n> }
```

e.g. to define an attribute bloc that assign the value `john` to the value `name` we would use the following syntax: 

```markdown
{name=john}
```

In the following sections, we will first start the description of Markdown attributes by defining the attributes types and their syntax before moving to the description of the attribute blocs. We will then define the rules used to associated attributes blocs to Markdown elements and conclude by giving some examples of their use with common Markdown elements types. 
 
## Attribute 

An attribute is a "name value" pair property that is assigned to a Markdown element. There is three attributes types, each corresponding to their HTML equivalent:

- [id](../html/#id)
- [class](../html/#class)
- [attributes](../html/#attributes)

### `id` attribute 

The id attribute adds an [HTML id](../html/#id) to a Markdown element. To define an `id`, we should use the pound character `#` followed by the id we want to assign to the attribute. Remember that ids are supposed to be unique in an HTML document! 

#### Syntax 

Markdown:

```markdown
{#myid}
Text with id attribute.
```

HTML:

```html 
<p id="myid">
Text with id attribute.
</p>

```

Only one id should be defined per element. If multiple ids are defined, only the last one will be considered. 

Markdown: 

```markdown 
{#id1 #id2}
Text with id attribute.
```

HTML:

```html 
<p id="id2">
Text with id attribute.
</p>
```

#### HTML Element

The `id` attribute offers the following HTML element for styling: 

- `id-attr`: allows to style the region used to defines the `id` attribute, including the `#` sign.

{#id-element}
#### HTML Pseudo-element

The `id` attribute offers the following pseudo-element:

- `tag`: allows to style the region used to define the `id`, basically the `#` sign.

- `attr-indicator`: see `tag`. 

### `class` attribute 

The class attribute adds an [HTML class](../html/#class) to a Markdown element. To define a `class` attribute we should use the `.` character followed by the class value we want to define. Any number of class values can be added to any element. 

#### Syntax 

Markdown:

```markdown
{.myclass}
Text with class attribute.
```

HTML:

```html 
<p class="myclass">
Text with class attribute.
</p>

```


#### HTML Element

The `class` attribute offers the following HTML element for styling: 

- `class-attr`: allows to style the region used to defines the `class` attribute, including the `.` sign.

{.class-element}
#### HTML Pseudo-element

The `class` attribute offers the following pseudo-element:

- `tag`: allows to style the region used to define the `class`, basically the `.` sign.

- `attr-indicator`: see `tag`. 

### Key-value attributes

A key-value attribute adds an [HTML attribute](../html/#attributes) to a Markdown element. A key-value attribute has, well, two parts: a key and a value. 

The key and the value cannot start with a number but they can start with any letter or an underscore `_`. 


#### Syntax 

Markdown:

```markdown
{key=value}
Attributed text.

```

HTML:

```html
<p key="value">Attributed text.</p>
```

An attribute definition with multiple values for the same key should be enclosed within double quotes `"` and separated by at least one space. 

Markdown:

```markdown
{key="value1 value2"}
Attributed text.

```

HTML:

```html
<p key="value1 value2">Attributed text.</p>
```

Complex attributes can be added, for example, to add style attributes: 

Markdown:

```markdown
{style="color: red"}
Red text.

```

HTML:

```html
<p style="color: red">Red text.</p>
```

#### HTML Element

The `key-value` attribute offers the following HTML element for styling: 

- `key-value-attr`: allows to style the region used to defines the `key-value-attr` attribute, including the `=` sign.

{key=value}
#### HTML Pseudo-element

The `key-value-attr` attribute offers the following pseudo-element:

- `tag`: allows to style the region used to define the `key-value-attr`, basically the `=` sign.

- `attr-indicator`: see `tag`. 

## Attributes bloc

Attributes blocs are used are used to group attributes together and to assign them to any Markdown element, except attributes blocs themselves. Attributes added by attributes blocs are kept in the final HTML file and can be used as any other attributes from CSS to style the HTML elements. 

  
### Syntax

An attributes bloc starts with a left curly brace `{` and ends with a right curly brace `}`. Multilines attributes bloc are not allowed and must start and end on the same line. Inside the the opening and closing curly braces it's possible to define any number of attributes, of any type, as long as they do not extend to more than one line.   


### HTML Element

The attribute bloc offers the following HTML element for styling: 

- `attr-bloc`: allows to style the region used to defines the attribute bloc, including the opening and closing curly braces signs.
 
{.attributes-bloc}
### HTML Pseudo-element

The `key-value-attr` attribute offers the following pseudo-element:

- `tag`: allows to style the region used to define the `attr-bloc`, basically the `=` sign.

- `attr-indicator`: see `tag`. 

### Using attributes with Markdown 

To start using attributes effectively we need to understand how they interoperate with the other Markdown elements. 

Please note that the examples thats follows will use the CSS* below: 

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

*Note that the last CSS style rules have higher priority than preceeding ones, some examples below will need to have this fact in mind.  

#### Attributes application rules  

Attributes can be assigned to Markdown [inline or bloc elements](../markdown/#mdElementTypes). 

Here are the rules to use them: 

1. Attributes blocs can be added before* any markdown bloc. 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red paragraph with attributes before.</span>
</code></pre>

2. All attributes blocs before a Markdown bloc that applies to that bloc will be aggregated together. 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attribute-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attribute-tag">}</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="green">Paragraph is green because .green selector has higher priority.</span>
</code></pre>

3. Attributes blocs can also be added after a markdown bloc, on the line directly below it. No blank lines must separare the markdown bloc and the attributes bloc for the attributes bloc to be considered on the line directly below this bloc.

<pre><code>
<span class="red">Red paragraph with attributes after.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

4. Inline attributes blocs are applied to the inline element defined before them, if there is no such element, they apply to the enclosing bloc in which they are defined.	
Example of inline attributes blocs applied to the inline element defined before, here an [emphasis](#mdEmphasis): 

<pre><code>
This is <span class="red">*red*</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>.</span>
</code></pre>


Example of inline attributes blocs applied to the enclosing bloc in which they are defined:

<pre><code>
<span class="red">This is all red.</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>.</span>
</code></pre>


*Note: An attributes bloc can be defined inline e.g. inside a paragraph, or as a bloc, at the root or inside another bloc. *_* *Before* *_* or *_* *after* *_* refers to the position of an attributes bloc relatively to another bloc level element under the same bloc or the root. The notion is quite intuitive: 

Attributes bloc after: 

<pre><code>
<span class="red">Red paragraph with attributes after.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Or: 

<pre><code>
<span class="blockquote-tag">></span><span class="red"> Red paragraph with attributes after.</span>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Attributes bloc before: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red paragraph with attributes before.</span>
</code></pre>

Or: 

<pre><code>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Red paragraph with attributes before.</span>
</code></pre>

To be considered a bloc, the attributes bloc must not be followed by anything else than whitespaces: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span><span class="red"> Red paragraph with inline attributes bloc.</span>
This paragraph does not inherit the attributes before because they are considered <em>inline</em>.
</code></pre>


## Examples: 

### ATX Headers:

Before: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
<span class="heading-tag">###</span> <span class="red">foo</span>
</code></pre>

inline:

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo</span> <span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> <span class="heading-tag">###</span>
</code></pre>

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo ### </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

or after:

<pre><code>
<span class="heading-tag">###</span> <span class="red">foo</span>
<span class="attributes-tag">{</span><span class="attribute">#id .red</span><span class="attributes-tag">}</span>
</code></pre>

are allowed.

### horizontal rule 

<pre><code>
<span class="red">---</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

No spaces are needed between the attributes bloc and the horizontal rule: 

<pre><code>
<span class="red">---</span><span class="attributes-tag">{</span><span class="attribute">.red #id</span><span class="attributes-tag">}</span>
</code></pre>

A line feed inside an attributes bloc invalidate it, the same as blank lines inside it: 

<pre><code>
---{.red 
#id}
</code></pre>

### Setext headers

<pre><code>
<span class="red">Foo </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="attributes-tag">==========</span>
</code></pre>

### fenced code block 

An attributes bloc can be put in place of the usual params or "info string" and become "syntactic sugar for classes".

But attributes can be put before or after as with any other bloc element:

Before: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="fence-tag">```</span>
<span class="red">some text</span>
<span class="fence-tag">```</span>
</code></pre>

After: 

<pre><code>
<span class="fence-tag">```</span>
<span class="red">some text</span>
<span class="fence-tag">```</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
</code></pre>

Replacing the params:   

<pre><code>
<span class="fence-tag">```</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="red">some text</span>
<span class="fence-tag">```</span>
</code></pre>

### Reference Links

<pre><code>
<span class="reference-tag">[</span><span class="red">foo</span><span class="reference-tag">]</span><span class="reference-tag">[</span>bar<span class="reference-tag">]</span>
<span class="reference-tag">[</span><span class="red">bar</span><span class="reference-tag">]:</span> /url "title"<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> 
<span class="reference-tag">[</span><span class="blue">bar</span><span class="reference-tag">]:</span> /url "title"<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>


In the previous example, only the first attributes are propagated since it is the active reference (because it is the first one). Also, attributes propagation to the referencing links and images is applied.  

### Paragraphs 

As usual, attributes are supported before, inline and after: 

Before: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="red">Red paragraph with attributes before.</span>
</code></pre>

Inline: 

<pre><code>
<span class="red">Red paragraph with inline attributes.</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

After: 

<pre><code>
<span class="red">Red paragraph with attributes after.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>
 
Inline blocs, apply to the previous inline element unless, this previous inline element is itself an attributes bloc: 

<pre><code>
<span class="red">Red paragraph with attributes </span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span><span class="red"> inside.</span>
</code></pre>


<pre><code>
<span class="strong-tag">**</span><span class="red">Red emphasized text</span><span class="string-tag">**</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span> text.
</code></pre>


If the previous element is an attribute bloc then the attributes apply to the enclosing bloc: 


<pre><code>
<span class="strong-tag">**</span><span class="red">Red emphasized text</span><span class="strong-tag">**</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span> <span class="blue">blue text.</span>
</code></pre>

There is no need for the attribute blocks to be indented exactly as much as the first line of the paragraph: if it is on the line below it applies to it: 

<pre><code>
<span class="red">Red text with attributes after.</span>
 <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

### Block quotes

No need for the attributes bloc to be indented as the block quote to apply to it, since it is on the line below at the same level, it is sufficient: 

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with attributes.</span>
 <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Paragraph with attributes.</span>
<span class="blockquote-tag">></span> <span class="red">inside a blockquote.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

The same rules apply inside a bloc quote, : 

<pre><code>
<span class="blockquote-tag">></span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Paragraph with attributes.</span>
<span class="blockquote-tag">></span> <span class="red">inside a blockquote.</span>
<span class="blockquote-tag">></span>
<span class="blockquote-tag">></span> Some more text.
</code></pre>

Bloc indentation does not change anything: 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
   <span class="blockquote-tag">></span> <span class="blue">Blockquote with attributes.</span>
     <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

But as we can see, depending on where the attributes belong they apply to different blocs (remember that red has higher priority than blue in the CSS style): 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
   <span class="blockquote-tag">></span> <span class="red">Blockquote with attributes.</span>
   <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">></span> <span class="red">Blockquote without attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with</span>
<span class="red">lazy continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="blockquote-tag">></span> <span class="red">Blockquote with</span>
<span class="red">lazy continuation.</span>
  <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

### Lists

<pre><code>
<span class="list-tag">- </span> <span class="red">List with</span>
<span class="list-tag">- </span> <span class="red">attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

Attributes blocs that are not directly under a bloc are applied to the following one:  

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">A tight list</span>
<span class="list-tag">- </span> <span class="blue">with lazy</span>
<span class="blue">continuation.</span>

<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>

<span class="red">Red paragraph.</span>
</code></pre>


The same goes for lists inside another bloc, here a blockquote: 

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

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="red">A tight list</span>
<span class="list-tag">- </span> <span class="red">with lazy</span>
<span class="red">continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

We can apply different attributes to the lists

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">1</span>
<span class="list-tag">- </span> <span class="blue">2</span>
    <span class="list-tag">- </span> <span class="red">2.1</span>
    <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="list-tag">- </span> <span class="blue">1</span>
<span class="list-tag">- </span> <span class="blue">2</span>
    <span class="list-tag">- </span> <span class="red">2.1</span>
    <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>


<span class="list-tag">- </span> <span class="blue">a loose list</span>

<span class="list-tag">- </span> <span class="blue">with attributes.</span>
</code></pre>

<pre><code>
<span class="list-tag">- </span> <span class="red">A loose list</span>

<span class="list-tag">- </span> <span class="red">with attributes.</span>
<span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

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

<pre><code>
<span class="list-tag">- </span> <span class="green">A loose list</span>

<span class="list-tag">- </span> <span class="green">with lazy</span>
<span class="green">continuation.</span>
<span class="attributes-tag">{</span><span class="attribute">.green</span><span class="attributes-tag">}</span>
</code></pre>


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

### inline code

The spaces don't matter: 

<pre><code>
<span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span> <span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

or 

<pre><code>
<span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="blockquote-tag">> </span>Bar.
<span class="blockquote-tag">> </span><span class="inline-code-tag">`</span><span class="red">foo</span><span class="inline-code-tag">`</span><span class="attributes-tag">{</span><span class="attribute">.red</span><span class="attributes-tag">}</span>
<span class="blockquote-tag">> </span>
</code></pre>

### emphasis

<pre><code>
<span class="emphasis-tag">_</span><span class="blue"><em>foo</em></span><span class="emphasis-tag">_</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="strong-tag">**</span><span class="blue"><strong>foo</strong></span><span class="strong-tag">**</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

### links

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span>
</code></pre>

<pre><code>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="link-tag">[</span><span class="blue">link</span><span class="link-tag">]</span><span class="link-tag">(</span><span class="blue">/uri</span><span class="link-tag">)</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

### images

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span>
</code></pre>

<pre><code>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span><span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="image-tag">![</span><span class="blue">link</span><span class="image-tag">]</span><span class="image-tag">(</span><span class="blue">/uri</span><span class="image-tag">)</span>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

### reference 

<pre><code>
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net
</code></pre>

<pre><code>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net <span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

<pre><code>
<span class="reference-tag">[</span><span class="blue">link</span><span class="reference-tag">]:</span> www.textually.net
<span class="attributes-tag">{</span><span class="attribute">.blue</span><span class="attributes-tag">}</span>
</code></pre>

