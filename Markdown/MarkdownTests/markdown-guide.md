
# Markdown

Markdown est le language de balises léger utilisé dans Stylo. C'est un language simple qui met l'accent sur la lisibilité et la facilité d'utilisation. Markdown existe en plusieurs versions mais une version semble de plus en plus faire consensus: CommonMark, et c'est la version implémentée par Stylo. Pour tout question relative à la syntaxe Markdown, le site officiel de [CommonMark](https://commonmark.org/) offre une [documentation](https://spec.commonmark.org) complète et un [outil d'essai en ligne](https://spec.commonmark.org/dingus/). 

## Règles de syntaxe 

Voici un inventaire simplifié des règles de syntaxe principales dans CommonMark et Stylo. Pour toute référence définitive il faut se référer à la [spécification CommonMark](https://spec.commonmark.org).  

### Titres  


## Titre de niveau 1 

Un titre de niveau peut s'écrire de deux façons, avec un dièse, comme dans l'exemple suivant:    

``` markdown 
# titre 1
```

Un titre de niveau 1 peut aussi s'écrire en soulignant d'une ligne double (formée de signes « égal » (=) accolés les uns aux autres.  

``` markdown
Titre 1 
=========
```

## Titre de niveau 2


``` markdown
## titre 2 
```

``` markdown
Titre 2
--------------
```

## Autres niveaux 

Les autres niveaux s'écrivent avec 

``` markdown 
### titre 3
#### titre 4 
##### titre 5 
###### titre 6 
``` 

### Barre horizontale 
--- 
***

### Emphase  

*Texte en italique*
_Texte en italique_ 

**Texte gras**  
__Texte gras__

### Bloc de code 

> Bloc de code    
Bloc de code 

Les blocs de code peuvent s'imbriquer les uns dans les autres: 

> Bloc de code    
> > Bloc de code imbriqué
> > > Second bloc de code imbriqué

### Listes 

#### Non ordornées  

* List
* List
* List

- List
- List
- List

#### Imbriquées 

* Une puce
* Une autre puce
    * Une sous-puce
    * Une autre sous-puce
    * Et encore une autre puce !
    
    #### Ordornées  
    
    1. One
    2. Two
    3. Three
    
    1) One
    2) Two
    3) Three
    
    Commencé le numérotage à une valeur précise:
    
    57. foo
    1. bar
    
    ### Code
    
    #### En ligne (avec un accent grave)
    
    `code`
    
    
    #### Sur plusieurs lignes (avec trois ou plus accents graves)
    
    ```
    Texte en mode code.
    ```
    #### Indenté (quatre espaces ou plus devant)
    
    // Commentaires
    ligne 1 du code
    ligne 2 du code
    ligne 3 du code
    
    ### Tables
    
    | Colonne 1 | Colonne 2 |
    | ------ | ----------- |
    | Texte colonne 1   | Texte colonne 2 |
    | Texte colonne 1   | Texte colonne 2 |
    | Texte colonne 1   | Texte colonne 2 |
    
    Titre de colonnes alignées à droites:
    
    | Colonne 1 | Colonne 2 |
    | ------:| -----------:|
    | Long texte de la colonne 1   | Long texte de la  colonne 2 |
    | Long texte de la  colonne 1  | Long texte de la  colonne 2 |
    | Long texte de la  colonne 1  | Long texte de la  colonne 2 |
    
    ### Liens 
    
    [texte du lien](http://www.stylowriter.com)
    
    [lien avec titre](http://www.stylowriter.com "Stylo!")
    
    Il est aussi possible d'utiliser une notation en mode « note de bas de page »:
    
    ![lien][idStylo]
    
    Avec une référence plus tard dans le même document qui définit l'URL destination:
    
    [idStylo]: http:// http://www.stylowriter.com "Stylo"
    
    ### Images
    
    ![Logo](http://www.stylowriter.com/images/logo.png)
    ![Logo](http://www.stylowriter.com/images/logo.png "Logo")
    
    Comme les liens, les images ont aussi une syntaxe en format note de bas de page:
    
    ![texte alternatif][idImage]
    
    Avec une référence plus tard dans le même document qui définit l'URL destination:
    
    [idImage]: http:// http://www.stylowriter.com/images/logo.png "Logo"
    
    ## DOM 
    
    Dans Stylo, CSS est utilisé pour « styliser » le texte Markdown. Certains éléments de Markdown sont éliminés lors de la conversion en HTML; que l'on pense aux références qui ne sont remplacées par la destination du lien lorsqu'utilisées dans un lien. Afin de permettre de styliser aussi les éléments de Markdown, Stylo créé des éléments Markdown dans un espace de noms ( « namespace » ) séparé. Pour ceux qui savent comment utiliser un « namespace » en CSS, le « namespace » de Markdown est définit comme: `"http://net.daringfireball.markdown"`, pour les autres, il n'est que très rarement utile d'utiliser un « namespace » dans un sélecteur CSS. 
    
    Les éléments qui ont été ajoutés sont les suivants: 
    
    - `html-block`: HTML peut être utilisé directement dans Markdown. Dans Stylo, les blocks de code en HTML sont groupés sous des éléments de type: `html-block`. 
    - `reference`: Une référence prend la forme: [<nom de la rérérence>]: <url de destination> "<titre>". Il est possible de styliser une référence Markdown avec l'élément `reference`
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


