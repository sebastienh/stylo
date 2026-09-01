
# Blockquote  

A quoted block, equivalent to the "blockquote" HTML element, is used to identify a quoted section of text from another source.

## Syntax

Markdown: 

``` markdown 
> citation bloc    
citation  bloc
```

HTML:

``` html
<blockquote>
    <p>
        citation bloc<br>
        citation bloc
    </p>
</blockquote>
```

The quoted blocks can nest into each other:

Markdown:

``` markdown 
> citation bloc    
> > nested citation block
> > > second nested citation bloc
```

HTML:

``` html
<blockquote>
    <p>
        citation bloc
    </p>
    <blockquote>
        <p>
            nested citation block
        </p>
        <blockquote>
            <p>
                second nested citation bloc
            </p>
        </blockquote>
    </blockquote>
</blockquote>
```

## Pseudo-elements  

There is one pseudo-element offered by this element:

- `tag`: covers the `>` (larger) signs used to define the quote blocks.

