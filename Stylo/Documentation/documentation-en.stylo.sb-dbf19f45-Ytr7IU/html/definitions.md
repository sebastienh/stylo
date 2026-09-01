# Definitions 

The **parent element** of a current element is the element on top of that element, that is, the closest element that contains it. In the previous document, `html` is the parent of `body`, and `body` is the parent of `h1`, `h2`, and `p`. Each element can have a maximum of 1 parent element. The root element, which is the `html` element, has no parent .

An **ascendant element** of a current element is any element that contains the current element either directly (as the parent) or indirectly, which is the ascendant of the parent of an element. In the previous document, the `html` element is the ascendant of all the elements of the document except itself, the `body` element is the ascendant (and the parent) of the elements: `h1`, `h2` and `p`.

A **child element** of a current element is defined as any element that is directly below this current element. An element's child parent is the element for which this element is the child. The relationship "parent-child" is symmetrical. In the previous document, the `body` element is the child of the `html` element, and the `h1` element is the child of the `body` element.

A **descendant element** of a current element is either the child of that element, or a descendant of a child of that element. In the previous document, the element `p` is the descendant of the elements: `body` and `html`.

The **next sibling** of a current element is the element that shares the same parent as the current element and is directly after the current element. In the previous document, the element `p` is the next sibling of the element `h2` and the element `h2` is in turn the next sibling of the element `h1`.

A **following sibling** of a current element is any element that shares the same parent as the current element and is the next sibling the current element or the following sibling of this next sibling. In the previous document, the element `p` is the next sibling of the elements `h2` and `h1`.

Now that we have covered a few definitions, we can dwell on the element itself.

An element can have an `id`, classes (`class`) and/or attributes. CommonMark,  in itself, does not allow for the moment to define these properties on an element, but it is still possible to define them in HTML, so we will have a quick overview of the subject. 
