
# Priority rules 

When more than one style applies to an element and these styles define values ​​for the same property, a selection process must be applied to determine which style's property to choose. Here is, in ascending order, the priority assigned to each property:

1. user agent style
2. user styles
3. author's styles
4. important author's styles (marked with "!important")
5. important user's styles

At the end of this prioritization process, it is possible for two properties to have the same priority. In this case, a pointing system is used which will depend on the selector. 

Note: for a full/alternative explanation of CSS priority rules and cascading process: [OpenWeb Cascade CSS](https://openweb.eu.org/articles/cascade_css).
