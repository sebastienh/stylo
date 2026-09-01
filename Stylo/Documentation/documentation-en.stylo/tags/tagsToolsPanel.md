

# Tags Tool Panel

The _Tags Tool_ panel shows all the controls to manage tags in Stylo/Nodio. A tag is a representation of a [Markdown attribute](../markdown#mdAttributes) in the form of a token. Markdown attributes are defined in the source text files using the syntax defined in the documentation for [Markdown attributes](../markdown#mdAttributes).  

The _Tags Tool_ panel shows all the attributes values defined in the currently selected [_Editors Panel_](../nodio#editorsPanel). 

The tags are selectable and when some tags are selected the [_editors panel_](../nodio#editorsPanel) will change the display mode to _tags highlight mode_. In this mode, the text parts attributed with the [Markdown attributes](../markdown#mdAttributes) represented by the selected tags will become highlighted making them easily identifiable from their context. The visual form that the highlight might take is style dependant.     

The _Tags Tool_ panel also allows to navigate through the selected tags using the _Tags Tool Toolbar_'s _Previous_ and _Next_ buttons temporarly higlighthing the text attributed with the target tag revealing it among the text attributed with the other selected tags.

{#attributes-display-mode}
## Display modes

[Markdown attributes](../markdown#mdAttributes) can be displayed two ways: in _Values_ and in _Attributes_ mode. 


### Attributes 

In _Attributes_ display mode, the attributes are displayed with their keys, all values for each key being displayed in its own dedicated section.       

This means that if we have defined two tags like: 

```
{.revised}
Tagged text.
```

and:

```
{status=revised}
Another tagged text.
```

In the  _Tags Tools_, the first tag will be shown under the `class` section and the second will be shown under the `status` section. 

### Values

In _Values_ display mode, only the values of the attributes are shown in the tags list. All attributes with a same value will be represented using only one tag even if they come from different attributes _key_. Using the previous example, in _Values_ display mode, they will both be shown with the `revised` tag in the _Tags Tool_.
         

{.actions}
## Actions 


### Open_Tags Tool_

To open the _Tags Tool_:

- From the [_Navigator Title Bar_](../common#navigatorTitle): click on the [_tool selector button_](../common#toolSelectorButton) and choose the `Tags` item.   
