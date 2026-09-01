# Custom Variables

Custom variables are used to define independant values that can be reused in properties in stylesheets. A custom variable is defined by preceeding its name with a double-dash `--` e.g.

```css
--my-custom-color: red;
``` 

Once defined a custom variable can be reused everywhere needed using the var(...) function, which take as parameters the custom variable name and optionally a default value, in case the used custom variable is not defined anywhere. The rules to define the value of a custom variable are simply the cascading rules. So, for a variable to be available in a certain subtree, we need to have it defined somewhere in at least one of the ancestors. That's the reason why custom variables are often defined in the [`:root`](#pseudoClassSelector) pseudo-class: to make sure it is defined in the top ancestor of all elements in the document tree. 

Here is an example illustrating the complete process of defining and using a custom variable: 

```css
:root {
	--my-custom-color: red;
}

body {
	background-color: var(--my-custom-color, white);
}

```

Custom variables are used everywhere in Stylo, so they need to be understood by all style editors.  


