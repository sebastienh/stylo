
# Cascading 

The purpose of the cascade process is to assign a value to all the properties supported by each element, and this, for all document's elements.

An element can get a particular value for a property in three ways:

1. One or more styles declarations, whose selector matches this element, define a value for this property.
2. An element _ancestor_ defines a value for this property.
3. None of the above, the property then gets its default value.

If all properties of element have their value defined after the first step (1), the process stops here. Otherwise, for the values ​​that support the inheritance, we will get the values ​​to assign to the properties without values ​​in the ancestors of this element(2). If an ancestor sets a value for the property, the value will be assigned. For the remaining properties, the default values (3) ​​defined by the properties themselves will be used.

This is the cascade process!
