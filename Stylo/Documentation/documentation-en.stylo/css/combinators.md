
# Combinators 

Selector combinator allows to combine multiple selectors into one by defining the relationship between each of them. For example, we may want to select all `h1`'s descendant elements that are of type `strong`. To do this we would need to use the descendant combinator as in the following example: 

``` css
h1 strong {
	...
}
```

In the previous example, we used the descendant combinator, represented by a space between the two type selectors. The complete selector is evaluated from left to right as follows: first it selects all elements in the document, and then selects the elements of type `h1`,  and then apply the descendant selector by retaining all descandants of all `h1` elements previously selected. The selector then continues by evaluating the `strong` type selector to keep only the elements of this type.  

At the end of the selection process we effectively end up with all `strong` elements that are descendants of `h1` elements. 

There exists four kinds of selector combinators:

- [Descandant combinator](#descendantCombinator)
- [Child combinator](#childCombinator)
- [Following sibling combinator](#followingSiblingCombinator)
- [Next sibling combinator](#nextSiblingCombinator)

Note: It may be helpful to re-read the [Definitions](#definitions) section of "Element" section for a reminder of the main concepts used here.

