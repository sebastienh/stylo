# Style Inspector (`⇧⌘E`)

A style can only be _inspected_ if it is selected, this allows any change to the style to be [applied](#applyPendingStyleShanges) directly to the Mardkown text. 

Each style is expected to support two appearances: light and dark. It implements an appearance support by defining stylesheets that applies to it. A stylesheet can be applied to muliple appearances. In case a style does not have any stylesheet defined for an appearance, a default, system defined, stylesheet will be applied for that paricular appearance. 

The style inspector allows to add/delete/update stylesheets in a style; to set their appearances which can be light, dark or both; and to change a stylesheet name. It also allows to reorder stylsheets, simply by dragging them, to change their order in the style evaluation process; the last stylsheet having the higher priority. 

When one or more stylesheet(s) has been updated, either their source, their order or their appplicable appearance(s), we can then update the document style using the [_Update Document Style_](#applyPendingChanges) button.  


## Open the _style inspector_

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

To open a style inspector, do one of the following:

- Click on the `Edit` button of the selected style
- From the menu, choose: `Styles`→`Open Style Inspector`
- With the keyboard shortcut: `⇧⌘E`

## Add a stylesheet 

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

- From the _style inspector_ click on the top rightmost `+` button. 

## Rename a stylesheet 

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

- From the _style inspector_ click on the stylesheet name to rename in the _Stylesheets list_, the stylesheet's name text field should become editable. Type enter on the keyboard or click anywhere else in the window to apply the new name.   

## Edit a stylesheet 

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

- From the _style inspector_, move the mouse cursor over the stylesheet to edit. Two buttons should appear on the right: `Delete Stylesheet` and `Edit Stylesheet`. Click on the `Edit Stylesheet` to open the [_stylesheet panel_](#stylesheetPanel).

## Delete a stylesheet 

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

- From the _style inspector_, move the mouse cursor over the stylesheet to edit. Two buttons should appear on the right: `Delete Stylesheet` and `Edit Stylesheet`. Click on the `Delete Stylesheet` to delete the stylesheet.

## Set stylesheet's applicable appearance(s) 

Prerequisite: The styles list panel is visible (see [styles list](#stylesList))

 - From the _style inspector_ click on the stylesheet's appearance(s) selector popup button in the _Stylesheets list_, 





