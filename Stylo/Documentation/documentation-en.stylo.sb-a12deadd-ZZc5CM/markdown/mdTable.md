
# Table  

A table is used to tabulate information. It corresponds to the _table_ HTML element.

## Syntax

Each row of a table starts at the beginning of a line and is optionnally indicated by a vertical bar: "| ". Each column is separated from the previous ones by a vertical bar, and the last column of a row optionnally ends with a vertical bar.

The first row is the title row. It allows to give a title to each of the columns of the table, the title of each column can be empty.

The second row is the separators row. It separates the titles row from the values rows. Each column of this row, like that of the titles, optionnally begins with a vertical bar, and the last column is optionnally terminated by a vertical bar. Each column must contain at least a hyphen "-". This dash may optionally be preceded or followed by a ":" colon to specify a left alignment of the corresponding column, or a right alignment, respectively. The absence of two-point signifies an alignment in the center.

Then come the values rows which follow the same pattern as the title row but contains the values ​​of each column.

Some examples:

A table with two centred columns and three rows of values:

Markdown: 

``` markdown
| Column 1 | Column 2 |
| - | - |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
| Text column 1   | Text column 2 |
```

HTML

``` html
<table>
    <thead>
        <tr>
            <th>Column 1</th>
            <th>Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Text column 1</td>
            <td>Text column 2</td>
        </tr>
        <tr>
            <td>Text column 1</td>
            <td>Text colonne 2</td>
        </tr>
        <tr>
            <td>Text column 1</td>
            <td>Text column 2</td>
        </tr>
    </tbody>
</table>
```

A table with right-aligned columns:

Markdown: 

``` markdown
| Column 1 | Column 2 |
| ------:| -----------:|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
```

HTML:

``` html
<table>
    <thead>
        <tr>
            <th style="text-align:right">Column 1</th>
            <th style="text-align:right">Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:right">column 1 long text</td>
            <td style="text-align:right">column 2 long text</td>
        </tr>
    </tbody>
</table>
```

A table with left-aligned columns:

Markdown: 

``` markdown 
| Column 1 | Column 2 |
| :------| :-----------|
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
| column 1 long text  | column 2 long text |
```

HTML:

``` html 
<table>
    <thead>
        <tr>
            <th style="text-align:left">Column 1</th>
            <th style="text-align:left">Column 2</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
        <tr>
            <td style="text-align:left">column 1 long text</td>
            <td style="text-align:left">column 2 long text</td>
        </tr>
    </tbody>
</table>
```

## Pseudo-elements  

The `table` element supports the `tag` pseudo-element which contains all the vertical separators as well as the line separating the title row from the values rows. It can be used as follows:

``` css
table::tag {
    color: orange;
}
```