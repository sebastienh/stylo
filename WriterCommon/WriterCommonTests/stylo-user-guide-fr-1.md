# Stylo - Guide d'utilisation 



## Contenu 


``` 
- Contenu
- Introduction
- Fichier _.stylo_
- Interface 
	Écriture sans distraction 
	Section « Texte »
		Éditeur 
		Apperçu HTML 
	Barre latérale 
		Onglet « Outils »
		Onglet « Sélecteur de style »
	Liste des styles 
	Éditeur de style 
Themes 
Opérations 
	Document Stylo 
		Créer un nouveau document 
		Sauvegarder un document 
		Renommer un documnt 
		Exporter un document 
		Imprimer un document 
		Appliquer un nouveau thème 
	 Barre latérale 
		Révéler/Cacher la barre latérale 
			Révéler la barre latérale 
			Cacher la barre latérale 
		Montrer/Cacher l'onglet « Outils » de la barre latérale d' (⌘⌥⇧S)
			Révéler l'onglet « Outils » de la barre latérale 
			Cacher l'onglet « Outils » de la barre latérale  
		Montrer/Cacher l'onglet « Sélecteur de style » de la barre latérale  (⌘⌥S)
			Montrer l'onglet « Sélecteur de style » de la barre latérale
			Cacher l'onglet « Sélecteur de style » de la barre latérale
	Liste des Styles 
		Montrer/Cacher la liste des styles  (⇧⌘S)
			Afficher la liste des styles
			Cacher la liste des styles 
		Sélectionner un style 
		Editer un style (⇧⌘E)
		Ajouter un style (⇧⌘A)
		Supprimer un style (⇧⌘D)
		Changer le nom d'un style 
	Éditeur de style 
		Montrer/cacher le paneau des problèmes (⇧⌘I)
			Montrer le panneau des problèmes
			Cacher le panneau des problèmes
		Mettre en évidence un problème
		Révéler tous les problèmes 
		Appliquer les changements en attente (⇧⌘C)
	Éditeur Markdown 
		Créer un titre de niveau 1 
		Créer un titre de niveau 2  
		Créer un titre de niveau 3
		Créer un titre de niveau 4 
		Créer un titre de niveau 5 
		Créer un titre de niveau 6 
		Indenter un bloc
		Créer une liste non ordonnée 
		Créer une liste ordonnée 
		Convertir en gras 
		Convertir en italique 
		Make Strikethrough
		Ajouter un lien 
Racourcis clavier 
	General 
	Actions 
		Barre latérale 
		Styles 
	 	Style 
		Preview 
		Édition 
	Rechercher et remplacer 
	Mardown Editing  
```

    ddddddd
    ddddddd
    ddddddd

## Introduction

Stylo est une application d'édition de texte en format Markdown dans la version [CommonMark](https://commonmark.org/).   

La création de Stylo a été motivé par l'absence d'éditeur Markdown permettant une complète liberté dans la personnalisation de l'environnement d'écriture. Afin de permettre cette personnalisation de la manière la plus ouverte et standard possible, Stylo intègre un éditeur de style CSS permettant de définir des styles qui pourront être appliqués au texte. Stylo devient transparant et laisse place au texte lorsque l'usager écrit. 

## Fichier _.stylo_

En Markdown les fichiers sont sauvegardés en utilisant l'extension _.md_. Stylo sauvegarde tous les fichiers d'un document dans un répertoire, dont il est possible d'examiner le contenu en utilisant le bouton droit de souris sur le fichier _.stylo_ et en choisissant l'option _Afficher le contenu du paquet_. Ce répertoire contient deux sous-répertoires:

- source 
- styles 

Le répertoire _source_ contient texte du document sauvergadé sous un fichier _.md_ , et le répertoire styles contient tous les styles sous fomat CSS. 

## Interface 

L'interface se divise en trois sections, la section « Texte », la section « Styles » et la « Barre Latérale ». 

[Interface Stylo](http://www.stylowriter.com/fr/images/stylo-interface.png)

### Écriture sans distraction 

Stylo maximise l'espace occupé par le texte lui-même afin de créer un environnement d'écriture sans distractions, après tout le but d'un éditeur de texte est l'édition du texte, si l'onglet « Styles » n'est pas visible, les éléments accessoires de l'interface disparaîtront pour laisser place au texte uniquement. Pour voir un accessoir caché, il suffit de passer la souris à l'endroit où il se trouve et il se révélera. 

Note: le titre d'un document, en haut de la fenêtre, ne se révélera pas si l'onglet « Styles » est visible afin d'éviter que le titre chevauche le texte et les « Styles » et q'il soit, de ce fait, difficile à lire. Il suffira de femer l'onglet « Styles » () pour révéler le titre. 

### Section « Texte »

La section « Texte » permet d'éditer le texte et de visualiser le rendu en HTML. 

#### Éditeur 

[Éditeur Stylo](http://www.stylowriter.com/fr/images/stylo-editeur.png)

#### Apperçu HTML 

[Apperçu HTML Stylo](http://www.stylowriter.com/fr/images/stylo-appercu-html.png)

### Barre latérale 

La « Barre latérale » permet d'accéder à toutes les fonctionnalités de Stylo. Elle contient deux onglets: « Outils » et « Sélecteur de style » et l'on peut basculer de l'un à l'autre de ces onglets en utlisant le bouton «  » en haut de chacun des onglets.

#### Onglet « Outils »

L'onglet « Outils » de la barre latérale permet un accès rapide à l'ensemble des outils de Stylo. 

[Barre de sélection de style](http://www.stylowriter.com/fr/images/barre-laterale-outils.png)

Il contient, de haut en bas: 

1. button pour  basculer vers le « Sélecteur de style »

Le bouton de bascule vers le « Sélecteur de Style » est représenté par un symbole contenant trois images simplifées d'apperçu de style l'une au dessus de l'autre. En cliquant sur le bouton, on bascule vers l'onglet « Sélecteur de style » de la barre latérale.    

2. bouton pour montrer/cacher l'aperçu HTML

Le bouton « Aperçu » est représenté par le symbol  d'un oeil. En cliquant sur le bout

3. bouton pour montrer/cacher la liste des styles

Le bouton de bascule vers les « Styles » est représenté par un symbole contenant la pointe d'un crayon et la pointe d'un pinceau, le premier symbolisant l'acte d'écrire et le dernier, l'acte de manipuler un style. 

4. les outils de formattage Markdown. 

Les différents boutons permettent d'accéder aux fonctions de formattage Makrdown.

#### Onglet « Sélecteur de style »

[Onglet de sélection de style](http://www.stylowriter.com/fr/images/barre-laterale-selection-style.png)

L'onglet de sélection de style contient, de haut en bas: 

1. button pour  basculer vers l'onglet "Outils"

Le bouton montre une pointe de crayon et une pointe de pinceau l'un au dessus de l'autre. Il permet de retourner à l'onglet « Outils » de la barre latérale. 

2. liste des aperçus de style

[Liste des aperçus de style](http://www.stylowriter.com/fr/images/onglet-selection-style-list-apercus.png)

Un apreçu de style est une version en plus petit de l'aperçu d'un style dans la liste des styles, à gauche. Comme lui, il montre le 

3. un indicateur de positionnement (si la fenêtre est trop petite pout montrer tous les styles)

[Indicateur de position dans les styles](http://www.stylowriter.com/fr/images/barre-latérale-indicateur-de-position.png)

La longeur de l'indicateur est proportionnelle à la proportion des styles qui sont visibles. Si l'indicateur de positionnement se trouve à gauche, nous sommes au début de la liste des styles, et l'indicateur bouge vers la droite pour indiquer que nous trouvons plus vers la fin de la liste. 

Si l'indicateur se trouve à gauche, nous sommes au début de la liste des styles, et l'indicateur bouge vers la droite pour indiquer que nous trouvons plus vers la fin de la liste. La longeur de l'indicateur est proportionnelle à la proportion des styles qui sont visibles. 

### Liste des styles 

La liste des styles permet, comme l'onglet « Sélecteur de style », de choisir un style à appliquer au document courant, de plus, elle permet d'accèder aux différentes actions possible sur un style: éditer, ajouter ou supprimer.  

[Liste des styles](http://www.stylowriter.com/fr/images/liste-des-styles.png)

### Éditeur de style 

L'éditeur de style comprend une section titre, l'éditeur CSS lui-même et la liste des messages. 

[Éditeur de Style](http://www.stylowriter.com/fr/images/style.png)

La section titre comprend:
1. le nom du style
2. un indicateur indiquant le nombre de problèmes dans le fichier source
3. le bouton de retour vers la liste des styles 
4. le bouton « Appliquer » qui permet d'appliquer le style courant au document (incluant les changements non-appliqués)
5. le bouton « Problèmes » qui permet d'accéder à la liste des problèmes.  

La section messages comprend la liste des messages (avertissements, erreurs) s'appliquand au source CSS courant. 

## Themes 

Un thème s'applique aux fichiers sources CSS dans les trois modes: source, erreur et erreurs et à l'aperçu HTML et définit leur apparence.  

## Opérations 

### Document Stylo 

#### Créer un nouveau document 

Pour créer un nouveau document: 

- Depuis le menu, choisissez `Fichier` → `Nouveau`
- Utiliser le racourci clavier: ⌘N

#### Sauvegarder un document 

Stylo sauvergarde automatiquement vos documents au fur et à mesure que vous lui apporté des changements. Mais si vous désirez sauvegarder un document manuellement: 

- Depuis le menu, choisissez `Fichier` → `Sauvegarder`
- Utiliser le racourci clavier: ⌘S

#### Renommer un documnt 

Pour renommer un document: 

- Depuis le menu, choisissez `Fichier` → `Renommer...`

#### Exporter un document 

Stylo supporte 4 formats d'exportation: 

- HTML: Le document au format HTML  
- Word: Le document au format Word 
- Markdown: Le document tel quel (le texte de sans changement)
- PDF: Le document convertie en format PDF 

Pour exporter un document: 

- Depuis le menu, choisissez `Fichier` → `Exporter` et choisisser le format destination.

#### Imprimer un document 

Pour imprimer un document: 

- Depuis le menu, choisissez `Fichier` → `Imprimer...`

#### Appliquer un nouveau thème 

Pour appliquer un nouveau thème:

- Depuis le menu, choississez  `Stylo` → `Themes` et choisissez le thème

Note: Afin de voir le résultat de votre action, vous pouvez ouvrir l'éditeur CSS d'un style, ou afficher l'aperçu HTML d'un document  

### Barre latérale 

#### Révéler/Cacher la barre latérale 

La barre latérale se situe à la droite de la fenêtre et peut être soit invible, montrer la barre d'outils, ou montrer la barre de sélection de style. Quand la barre est visible on peut basculer entre les deux modes visibles en utilisant le bouton de bascule qui se trouve en haut.

##### Révéler la barre latérale 

Pour révéler la barre latérale (si elle n'est pas pas visible): 

1. Passer le curseur de la souris sur le côté droit de la fenêtre.

##### Cacher la barre latérale 

La barre latérale se cachera à l'édition du texte principale, si l'apperçu HTML, les outils d'éditions de styles ou la liste des styles ne sont pas ouverts. 

Utiliser l'une des deux options suivantes pour révéler un onglet spécifique de la barre latérale ou la cacher. 

#### Montrer/Cacher l'onglet « Outils » de la barre latérale d' (⌘⌥⇧S)

##### Révéler l'onglet « Outils » de la barre latérale 

Pour afficher la barre d'outils: 
Éffectuez l'une des actions suivantes:

- Depuis le menu, choississez `Présentation` → `Afficher barre d'outils`
- Passer le curseur de la souris sur le côté droit de la fenêtre, et si la barre de sélection de style est visible, cliquer sur le bouton de sélection de la barre de sélection de style, en haut. 
- Utiliser le racourcis clavier: ⌘⌥⇧S

Si la barre de sélection de style est visible, vous pouvez aussi éffectuez l'opération suivante: 

- Cliquer sur le bouton de sélection de la barre de sélection de style, en haut. 

##### Cacher l'onglet « Outils » de la barre latérale  

Pour cacher manuellement la barre latérale, si la barre d'outils est visible

Éffectuez l'une des actions suivantes:

- Depuis le menu, choississez `Présentation` → `Cacher barre d'outils`
- Utiliser le racourcis clavier: ⌘⌥⇧S

#### Montrer/Cacher l'onglet « Sélecteur de style » de la barre latérale  (⌘⌥S)

La barre de sélection de style permet un accès rapide à l'ensemble des styles disponibles pour un document et de sélectionner le style à lui appliquer. 

##### Montrer l'onglet « Sélecteur de style » de la barre latérale

Éffectuez l'une des actions suivantes:
- Depuis le menu, choississez `Présentation` → `Afficher la barre de sélection de style`
- Utiliser le racourcis clavier: ⌘⌥S

Si la barre latérale est visible, vous pouvez aussi éffectuez l'opération suivante: 
- Cliquer sur le bouton de sélection de la barre d'outils, en haut. 

##### Cacher l'onglet « Sélecteur de style » de la barre latérale

Pour cacher manuellement la barre latérale, si la barre de sélection de style est visible

Éffectuez l'une des actions suivantes:

- Depuis le menu, choississez `Présentation` → `Cacher la barre de sélection de style`
- Utiliser le racourcis clavier: ⌘⌥S

### Liste des Styles 

#### Montrer/Cacher la liste des styles  (⇧⌘S)

##### Afficher la liste des styles

Éffectuez l'une des actions suivantes:

- Depuis la barre d'outils (voir « Afficher la barre d'outils »), cliquer sur le bouton « Style » qui est représenté par le symbole de l'extrémité d'un pinceau. 
- Depuis le menu, choississez `Présentation` → `Styles` → `Afficher les styles`
- Depuis le paneau d'édition d'un style, cliquer sur le bouton « Styles »
- Utiliser le racourci clavier: ⇧⌘S

##### Cacher la liste des styles 

Éffectuez l'une des actions suivantes:

- Sur la barre d'outils, cliquer sur le bouton « Style »
- Depuis le menu, choississez `Présentation` → `Styles` → `Cacher les styles`
- Utiliser le racourci clavier: ⇧⌘S

#### Sélectionner un style 

L'action de sélectionner un style appliquera le style sélectionné au texte principal, et ce style sera appliqué à tous les changements subséquents du texte. 

Pour sélectionner un style, éffectuez l'une des actions suivantes:

- Depuis la barre de sélection de style (voir « Afficher la barre de sélection de style », simplement cliquer sur l'un des icônes d'aperçu d'un style. 
- Depuis la liste des styles (voir « Afficher la liste des styles »), cliquer sur l'un des styles de la liste. 

#### Editer un style (⇧⌘E)

On ne peut éditer un style que s'il est sélectionné et que la liste des styles est visible (voir « Afficher la liste des styles »)

Pour éditer un style, éffectuez l'une des actions suivantes:

- Cliquer sur le bouton « Éditer » du style sélectionné
- Depuis le menu, choissisez: `Présentation` → `Styles` → `Éditer style`
- Utiliser le racourci clavier: ⇧⌘E

#### Ajouter un style (⇧⌘A)

Pour ajouter un style on la liste des styles doit ^tre visible (voir « Afficher la liste des styles »)

Pour ajouter un style, éffectuez l'une des actions suivantes:

- Cliquer sur le bouton "Ajouter" dans le paneau titre de la liste des styles. 
- Depuis le menu, choissisez: `Présentation` → `Styles` → `Ajouter un style`
- Utiliser le racourci clavier: ⇧⌘A

#### Supprimer un style (⇧⌘D)

Pour suprimer un style on la liste des styles doit être visible (voir « Afficher la liste des styles »)

Pour suprimer un style, éffectuez l'une des actions suivantes:

- Cliquer sur le bouton "Supprimer" du style sélectionné
- Depuis le menu, choissisez: `Présentation` → `Styles` → `Supprimer un style`
- Utiliser le racourci clavier: ⇧⌘D

#### Changer le nom d'un style 

Pour changer le nom d'un style, éffectuez l'une des actions suivantes:

- Depuis la fenêtre d'édition d'un style, cliquer sur le nom style, et éditer le nom.
- Depuis la liste des styles, cliquer sur le nom du style sélectionné, et éditer le nom.

### Éditeur de style 

#### Montrer/cacher le paneau des problèmes (⇧⌘I)

Le panneau des problèmes montre la liste des problèmes associés au source CSS édité. Il ne peut être montré s'il existe des problèmes dans le source CSS du style. Lorsque le panneau des problèmes devient visible, toutes les erreurs du source CSS sont mises en évidence. Lorsqu'il redevient invisible, le style du source CSS redevient normal. 

##### Montrer le panneau des problèmes

Pour montrer le panneau des problèmes, effectuez l'une des actions suivantes:

- Cliquer sur le bouton "Problèmes" en bas à droite du paneau titre du style.

##### Cacher le panneau des problèmes

Lorsque le panneau des problèmes est caché le style édité est 

Pour cacher le panneau des problèmes, effectuez l'action suivante:

- Cliquer sur le bouton "Problèmes" en bas à droite du paneau titre du style.

#### Mettre en évidence un problème

Lorsque le panneau des problèmes apparaît tous les problèmes du texte source CSS édité sont mis en évidence. 

Pour mettre une seule erreur en évidence, effectuer l'action suivante: 

- Cliquer sur l'erreur à mettre en évidence dans le panneau des problèmes. 

#### Révéler tous les problèmes 

Une fois que l'on a sélectionné un problème, celui-ci est mis en évidence dans le texte source CSS. 

Afin de mettre en évidences tous les problèmes, effectuez l'action suivante:

- Faire défiler les erreurs vers le haut ou vers le bas 

#### Appliquer les changements en attente (⇧⌘C)

Les changements effectués lors de l'édition d'un style ne sont pas appliqués automatiquement pour des raison des performances mais aussi en raison des états intermédiaires entre le style voulu et les étapes de l'édition menant au résultat qui ne seraient pas pertinents d'appliquer. au texte principale. Pour ces raisons, l'usager doit demander l'application des changements d'un style qu'il vient d'éditer. Le bouton "Appliquer" en haut à droit du panneau titre d'un style et à gauche du bouton "Problèmes" permet de d'appliquer les changements en attentes. Il ne sera actif que s'il des différences entre le style présentement appliqué et le style édité.

Pour appliquer les changements en attente, éffectuer l'une des actions suivantes:

- Depuis le panneau titre de l'éditeur d'un style, cliquer sur le bouton « Appliquer »
- Retourner à la liste des styles en cliquant sur "Styles" et le style sera automatiquement appliqué. 


### Éditeur Markdown 

#### Créer un titre de niveau 1 

Pour créer un titre de niveau 1:

- Textuellement (1), entrer `#`, un espace, et le titre lui-même
- Textuellement (2), entrer le titre lui-même puis sur la ligne suivante un ou plus `-`
- Depuis le menu, choissisez: `Format` → `Titre 1`
- Depuis l'onglet « Outils » de la barre latérale, cliquer sur le bouton `h1`

#### Créer un titre de niveau 2  

Pour créer un titre de niveau 2:

- Textuellement (1), entrer `##`, un espace, et le titre lui-même
- Textuellement (2), entrer le titre lui-même puis sur la ligne suivante un ou plus `=`
- Depuis le menu, choissisez: `Format` → `Titre 2`
- Depuis l'onglet « Outils » de la barre latérale, cliquer sur le bouton `h2`

#### Créer un titre de niveau 3

Pour créer un titre de niveau 3:

- Textuellement, entrer `###`, un espace, et le titre lui-même
- Depuis le menu, choissisez: `Format` → `Titre 3`
- Depuis l'onglet « Outils » de la barre latérale, cliquer sur le bouton `h3`

#### Créer un titre de niveau 4 

Pour créer un titre de niveau 4:

- Textuellement, entrer `####`, un espace, et le titre lui-même
- Depuis le menu, choissisez: `Format` → `Titre 4`
- Depuis l'onglet « Outils » de la barre latérale, cliquer sur le bouton `h4`

#### Créer un titre de niveau 5 

Pour créer un titre de niveau 5:

- Textuellement, entrer `#####`, un espace, et le titre lui-même
- Depuis le menu, choissisez: `Format` → `Titre 5`

#### Créer un titre de niveau 6 

Pour créer un titre de niveau 6:

- Textuellement, entrer `######`, un espace, et le titre lui-même
- Depuis le menu, choissisez: `Format` → `Titre 6`

#### Créer un bloc de citation 

Pour créer un bloc de citation :




#### Créer une liste non ordonnée 

#### Créer une liste ordonnée 

#### Convertir en gras 

#### Convertir en italique 

#### Make Strikethrough

#### Ajouter un lien 


## Racourcis clavier 

### General 

Previewing the HTML: ⌘R

### Actions 

#### Barre latérale 

- Révéler l'onglet "Outils" de la barre latérale: ⌘⌥S
- Révéler l'onglet "Sélecteur de Style" de la barre latérale: ⌘⌥⇧S

#### Styles 

- Révéler la liste des styles: ⌘⇧S
- Ajouter un style: ⌘⇧A
- Supprimer un style: ⌘⇧D
- Éditer un style: ⌘⇧E

#### Style 

- Révéler/Cacher la liste des problèmes: ⇧⌘I
- Appliquer les changement en attente: ⇧⌘C

#### Preview 

- Révéler/cacher le preview: ⌘R

### Édition 

- Undo: ⌘Z
- Redo: ⌘⇧Z
- Couper: ⌘Z
- Copier: ⌘C
- Copier Sélecteur: ⌥⌘C
- Coler: ⌘V
- Sélectionner tout: ⌘A

### Rechercher et remplacer 

- Chercher: ⌘F
- Chercher et remplacer: ⌥⌘F

### Mardown Editing  

- Heading 1: ⌘1
- Heading 2: ⌘2
- Heading 3: ⌘3
- Heading 4: ⌘4
- Heading 5: ⌘5
- Heading 6: ⌘6

- Indent Block: ⌘>

- Unordered list: ⌘L
- Ordered list: ⇧⌘L

- Bold: ⌘B
- Italic: ⌘I
- Strikethrough: ⌘-
- Add Link: ⌘K




