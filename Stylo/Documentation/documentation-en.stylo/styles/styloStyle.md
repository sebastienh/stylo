# Build Styles 

The CSS standard is used in Stylo to define the text/markdown styles. This allows for knowledge transfer from CSS standard to Stylo style editing and vice-versa.   

## Style 

A _style_ comes in two appearances (light, dark) and is defined by a group of stylesheets. Each stylesheet can be applied to one appearance (light or dark) or both appearances (light and dark). To evaluate a style for a certain appearance, the algorithm will first collect all applicable stylesheets for the current appearance. To do so, it will go from top to bottom in the stylesheets list order (as defined in the [_style inspector_](../styleEditor#styleInspector) and will evaluate the if the stylesheet applies to the desired appearance or not, if yes, it will add the stylesheet to the _style assembly_. Once the _style assembly_ contains all the stylesheets, it will be evaluated, again, from top to bottom, and associated with the result of the evaluation in the form of a _css style_ which will be used to evaluate the style of each element in the Markdown source text. 

For all operations related to style and stylesheet, see the [style editor](#styleEditor) documentation.  

## CSS 

### Style States

In Stylo, each element can be in many _style state_ s, all defined based on the possiblity for an element to be faded, normal, focused, highlight and/or flashed. Here are the 10 _style states_ an element can be: 

 1. fade (`sts1`)
 2. highlight-fade (`sts2`)
 3. normal, highlight-highlight-fade (these two are at the same level) (`sts3`)
 4. highlight (`sts4`)
 5. highlight-highlight (`sts5`)
 6. focus (`sts6`)
 7. highlight-focus (`sts7`)
 8. highlight-highlight-focus (`sts8`)
 9. highlight-flash (`sts9`)
 10. highlight-flash-highlight (`sts10`)

To be complete, a style needs to define a style value for each properties in each of these _styling states_. In CSS these states are represented by CSS pseudo-classes, e.g. if an `h1` element is in _focus_, we can target that specific state using the following CSS: 

```css
h1:focus {
	color: red;
}
```

A stylesheet to target all the elements different states could be challenging to define. That's why Stylo comes with a default stylesheet (the user-agent stylesheet) that defines all the selectors to target all the possible states of an element. This stylesheet uses [CSS custom variables](../css#customVariables) to define the different _styling states_ values a element can take. For example, coming for the default stylesheet, the style for `hx` in `fade` mode is defined by: 

```css
h1:fade,
h2:fade,
h3:fade,
h4:fade,
h5:fade,
h6:fade {
    color: var(--h-sts1, black);
}
``` 
 
To define a style for all the headers (`hx`) in focus mode, a stylesheet needs just to define a value for this variable for the desired property and this value will picked up by the styling engine when a header element is in this state (sts1: style state 1). 

```css
--h-sts1: red;
```

### Predefined Elements Style States

The predefined styles in Stylo, are a good starting point when trying to define new styles. So, to get you started, choose a style which is close to the one you have in mind and [copy it](#addStyle).

If you decide to start from zero, here are the list of predefined color variables that you can use in your styles: 

- Headers colors: `--h-sts<1-10>`
- Headers's tags colors:`--h-tag-sts<1-10>`
- Horizontal rule colors: `--hr-sts<1-10>`
- Strong and emphasis colors:  `--strong-em-sts<1-10>`
- Strong and emphasis tag colors:  `--strong-em-tag-sts<1-10>`
- Strikethrough colors: `--s-sts<1-10>`
- Strikethrough's text under headers colors: `--h-s-sts<1-10>`
- Strikethrough's text tag under headers colors: `--h-s-tag-sts<1-10>`
- Strikethrough's line under headers colors: `--h-s-strikethrough-sts<1-10>`
- Strikethrough's line colors: `--s-strikethrough-sts<1-10>`    
- Strikethrough's text tag colors: `--s-tag-sts<1-10>`
- Strong and emphasis under header colors: `--h-strong-em-sts<1-10>`
- Strong and emphasis tag under header colors: `--h-strong-em-tag-sts<1-10>`
- Blockquote colors: `--blockquote-sts<1-10>`
- Blockquote tag colors: `--blockquote-tag-sts<1-10>`
- Unordered list colors: `--ul-sts<1-10>`
- Ordered list colors: `--ol-sts<1-10>`
- List element colors: `--li-sts<1-10>`
- List element tag colors: `--li-tag-sts<1-10>`
- Code colors: `--code-sts<1-10>`
- Code tag colors: `--code-tag-sts<1-10>`
- Code params colors: `--code-params-sts<1-10>`
- Table colors: `--table-sts<1-10>`
- Table tag colors: `--table-tag-sts<1-10>`
- Table head colors: `--thead-sts<1-10>`      
- Table body colors: `--tbody-sts<1-10>`
- Image, link, reference colors: `--a-img-ref-sts<1-10>`
- Image, link, reference under header colors: `--h-a-img-sts<1-10>`
- Image, link, reference tag colors: `--a-img-ref-tag-sts<1-10>`
- Image, link, reference tag under header colors: `--h-a-img-tag-sts<1-10>`
- Image, link, reference title colors: `--a-img-ref-title-sts<1-10>`
- Image, link, reference title under header colors: `--h-a-img-title-sts<1-10>`
- Image, link, reference lable colors: `--a-img-ref-lbl-sts<1-10>`
- Image, link, reference lable under header colors: `--h-a-img-lbl-sts<1-10>`
- Image, link, reference text colors: `--a-img-ref-text-sts<1-10>`
- Image, link, reference text under header colors: `--h-a-img-text-sts<1-10>`
- Image, link, reference destination colors: `--a-img-ref-dest-sts<1-10>`
- Image, link, reference destination under header colors: `--h-a-img-dest-sts<1-10>`
- HTML block colors: `--html-block-sts<1-10>`
- Attributes bloc colors: `--attr-bloc-tag-sts<1-10>`
- Attribute colors: `--key-value-attr-class-attr-id-attr-sts<1-10>`
- Attribute tag colors: `--key-value-attr-class-attr-id-attr-tag-sts<1-10>`









