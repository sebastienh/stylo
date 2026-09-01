
# Mardkown specific elements 


In Stylo, CSS is used to style the Markdown text. Some Markdown elements have no correspondent HTML elements, so two elements were added specificifically for Markdown*: `html-block` and `reference`.

- `html-block`: An `html-block` defines any HTML block in a Markdown source. 
 
``` markdown 

# title level 1 
 
<p>A simple paragraph.</p>

```

In the last Markdown extract, the region delimited by `<p>` and `</p>` is an `html-block`. We could give it a red color using the following CSS: 

``` css
html-block {
    color: red;
}
```

- `reference`: A `reference` is used to create a label that represents an URI. This label can then be used in the links and images in a Markdown document to refer to this URI, see the [Reference](#mdReference) section for a complete description. When converting a Markdown document to HTML, the links and images using reference are populated with the real URI defined in the references and the references are removed since they are no longer needed. For styling purpose, in Stylo, these references are kept. When exporting a document to HTML or previewing it, all `reference` elements are removed as they don't serve any purpose. 

We could, for example, style a reference with the blue color using the following CSS: 

``` css
reference {
    color: blue; 
}
```

*The namespace for these elements is defined as: `https://commonmark.org`.
