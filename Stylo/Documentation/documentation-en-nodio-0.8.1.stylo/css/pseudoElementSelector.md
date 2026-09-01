
# Pseudo-element selector

A pseudo-element is an element that is not part of the document's elements tree but represents some logical part of an element. Stylo adds a number of these pseudo-elements so that it becomes possible to style the Markdown source more accurately. For example, in Markdown we define a header level 2 as follows:

Markdown: 

``` markdown
## header level 2
```

The text "##" is the tag, or the label of the element. The pseudo-element selector `::tag`  allows to select only the tag of the element `h2` in the previous Markdown source. In Stylo, several pseudo-elements exist, for a complete list see the [Pseudo-elements](#pseudoElements) section.

The pseudo-element selector is introduced by two "colon" ("::") after the selector of an element and is followed by the name of the pseudo-element, for example:

CSS:

``` css
h1::tag {
    ...
}
```

matches the `tag` pseudo-element of a level 1 title element.

Note: Stylo does not support the historical single colon syntax for pseudo-elements. 

## Several pseudo-elements of the same type

If a pseudo-element is defined several times for the same element, the one with the highest specificity will be the one that will be applied, and in case of equality, the last one encountered in the stylesheet will have higher priority.

In the case where several pseudo-elements of different types apply to the same text region, the one with the highest specificity, or in case of equality, the one that comes after, will apply.
