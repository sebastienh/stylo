# Pseudo CSS

## CSS for CSS

In Stylo Writer, we always wanted to rely as much as possible on open standards. That’s why CSS is used to style the source text. Another area where we wanted to use CSS, was to use it to style CSS itself. 

I resisted as long as I could before introducing any change not supported by the standard, but at one point it became obvious that it was’s not possible without some changes. But I have minimized those changes to the addition of pseudo-elements, and the addition of four selector combinators. 
Some slight changes have been brought to CSS in order to allow it to style itself. Those changes also allows CSS to style any language as long as it can can be represented internally as a tree structure. Most languages, if not all of them, support such representation which is the fondamental data structure of compiler theory : (abstract) syntax tree. 




 and some description of the work done to make it possible and the challenges faced while doing it are worth some words. 

## Back to basics 

The very thing that must be understood about CSS is that it is used to style three based languages that can be derived to some sort of Document Object Model (DOM) representation. HTML is the language traditionally styled by CSS. It has a natural tree structure as it derives from XML and exhibit it’s structure explicitly. 

<html> 
	<head>
		<title>Dummy HTML document.</title>
	</head>
	<body>
		<h1>	Really dummy HTML</h1>
		<p>
			This document is really a dummy document. 
		</p>
	</body>
</html>		

The DOM created from this simple HTML code would look like this : 

document
	html
		head
		body
			h1
			p

The document element, only child of the document, is html, which in turn has two children : head and body both being siblings. h1 and p are both child of body. 

We ca see that the code basically express more or less directly the tree structure derived from it.

In CSS there is no such structure. The language was never meant to be styled using itself anyway. 

Let’s take a simple CSS that specify the font-family for p element as being “Courrier”.

body p {
	font-family: Courrier;
} 




## Problems with CSS 

### No tree structure 

In the last CSS, there is no way of telling a hierarchy relation  between the element selectors “body” and “p”. So, we must create some rule to define such relation. 


### Dynamic names of properties 

In HTML the number of possible nodes is known. In CSS, there is so many modules that we need a way to handle dynamic naming of DOM elements. 

 



## DOM impacts 

On the DOM side, impacts on the core classes are inexistent. New  classes deriving from the standard ones have been created to cover the Pseudo CSS needs. 

One such new class is Mmi 

## Pseudo CSS Description 

### Rules of construction

#### [::css-style-sheet](https://drafts.csswg.org/cssom/#the-cssstylesheet-interface) 


								 						  css-style-sheet
												          		|
							         	 _______________________|________________________
	   						            /                       |                        \ 
	   						           / 						|		 				  \
	   				            css-style-rule				    *                   css-style-rule      

There could be also, at rules and some other kind of rules, but for the time being, we support only CSS Style Rule. 




#### [::css-style-rule](https://drafts.csswg.org/cssom/#the-cssstylerule-interface)


								 						  css-style-rule
												          		|
							             			____________|____________
	   						            		   /                         \                            
	   						           			  /						      \							
	   				        	           selector-list			     style-declaration



#### ::style-declaration


											         style-declaration-block 
												          		|
							    ________________________________|______________________________
	   						   /                                |                              \ 
	   						  / 								|					     		\
			   css-token.left-curly-brace		        style-declaration       css-token.right-curly-brace



#### ::selector-list


						 						           selector-list
												          		|
							    		 _______________________|_________________________
	   						   			/                       |         			      \
	   						  		   /						|						   \	
	   					     complex-selector			  [css-token.comma            complex-selector]*    



#### ::complex-selector


						 						          complex-selector
												          		|
							    		 _______________________|_________________________
	   						   			/                       |         			      \
	   						  		   /						|						   \	
	   					     compound-selector			        *                    compound-selector  


#### ::compound-selector	

compound_selector
  : type_selector [ id | class | attrib | pseudo ]*
    | [ id | class | attrib | pseudo ]+
  ;


						 						        complex-selector
												          		|
							         ___________________________|________________________________________________________________________
	   						   		/                           |         			     							|                    \
	   						  	   /				     		|						 							|                     \	
	   					 compound-selector        [  selector-combinator.<selector-combinator-type>          compound-selector ]           *			                      

#### <simple-selector> (it's a placeholder for the possible deffinitions below)

Note: We don't allow the 'is' relationaship, only contains, or, is child of relationship.

								  						<simple-selector>.simple-selector
								  								|
								  								+
One of: ::type-selector, ::class-selector, ::id-selector, ::universal-selector, ::pseudo-class-selector, ::pseudo-element-selector or ::attrib-selector 


##### ::type-selector.simple-selector

Note: ::type-selector will later include the namespace information to correspond to this grammar:

type_selector
  : wqname_prefix? element_name
  ;

element_name
  : IDENT | '*'
  ;


								 			      type-selector.simple-selector
								 						 		|
								 						 		|
								 						  element-name
												          		|
												          		|
	   				          				   css-token.ident-token.<element-name>    



OR


                            			 type-selector.simple-selector.universal-selector
                                            					|
                                            					|
                                    					 element-name
                                            					|
                                            					|
                                					css-token.delim-token.*


##### class-selector.simple-selector

								 				  class-selector.simple-selector
												          		|
							             			____________|____________
	   						            		   /                         \                            
	   						           			  /						      \							
	   				        	       css-token.delim-token			    css-token.ident-token.<raw-string-value>


##### id-selector.simple-selector

								 					 id-selector.simple-selector
												          		|
							             						|				
	   				        	       		 css-token.hash-token.<formatted-string-value>

##### universal-selector.simple-selector

								 		        universal-selector.simple-selector
												          		|
												          		|
	   				          			   css-token.ident-token.<raw-string-value>    

##### pseudo-class-selector.simple-selector

						 						pseudo-class-selector.simple-selector
												          		|
							         ___________________________|________________________
	   						   		/                           |         			     \
	   						  	   /				     		|						  \	
	   					css-token.colon-token         css-token.colon-token       css-token.ident-token.<raw-string-value>


##### ::pseudo-element-selector.simple-selector

								 			 pseudo-element-selector.simple-selector
												          		|
							             			____________|____________
	   						            		   /                         \                            
	   						           			  /						      \							
	   				        	       css-token.colon-token		css-token.ident-token.<raw-string-value>  


##### attrib-selector.simple-selector

Following the grammar: 

attrib
	:   '[' S* attrib_name ']'
	|   '[' S* attrib_name attrib_match [ IDENT | STRING ] S* attrib_flags? ']'

						 						 attribute-selector.simple-selector
												          		|
							   _________________________________|______________________________
	   						  /                                 |         			           \
	   						 /       				     		|						        \	
	   			  css-token.left-square-bracket-token     attribute-name    css-token.right-square-bracket-token


	   			  												or

						 						attribute-selector.simple-selector
												          		|
	____________________________________________________________|__________________________________________________________________________
   /                                        |         			|        				|				       |                           \
  /       				     		        |	 				|	        			|				       |                            \	
css-token.left-square-bracket-token  attribute-name       attribute-match	     attribute-value	 	: attribute-flags    css-token.right-square-bracket-token






###### attribute-name 

Note: ::attrib-name can only contains an ident but it will eventually also include support for wqname_prefix, 
that's why it is considered a pseudo element. 

attrib_name
  : wqname_prefix? IDENT S*

								 		           		  ::attribute-name
												          		|
												          		|
	   				          				  		  css-token.ident-token.<ident-string-value>    




###### attrib-match

attrib_match
  : [ '=' |
      PREFIX-MATCH |
      SUFFIX-MATCH |
      SUBSTRING-MATCH |
      INCLUDE-MATCH |
      DASH-MATCH
    ] S*

l. Exact Match 

								 		     			  attribute-match
												          		|
												          		|
	   				          				  	   css-token.exact-match-token   

l. Prefix Match 

								 		     			  attribute-match
												          		|
												          		|
	   				          				  	   css-token.prefix-match-token   

l. Suffix Match

								 		     			 attribute-match
												          		|
												          		|
	   				          				  	   css-token.sufix-match-token   

l. Substring Match 

								 		     			attribute-match
												          		|
												          		|
	   				          				  	   css-token.substring-match-token   

l. Include Match 

								 		     			  attribute-match
												          		|
												          		|
	   				          				  	   css-token.include-match-token   

l. Dash Match 

								 		     			  attribute-match
												          		|
												          		|
	   				          				  	    css-token.dash-match-token   


###### attribute-value


								 		     			  attribute-value
												          		|
												          		|
	   				          				  	css-token.string-token.<string-value>  

Or 

								 		     			 attribute-value
												          		|
												          		|
	   				          				  	css-token.ident-token.<ident-string-value>

###### attribute-flags

attrib_flags
  : IDENT S*


								 		     			  attribute-flags
												          		|
												          		|
	   				          				  	      css-token.ident-token  


#### selector-combinator.<selector-combinator-type>

We need to define a pseudo element type of type ::selector-combinator because this is the "recognisable structural element" defined by the language. We specify which type
of selector combinator it is by using classes since the tokens does not allow to ditinguish by themselves this, which is a shame since it is possible with "attrib-match" to 
distinguish only by using the tokens classes types, which are only the tokens passed to the parser. 

The reason why we don't want to define a diffenrent type for each type of combinator is that they are not different "recognisable structural element" of the language, 
meaning that they have not been defined as "elements of the language" as the combination of tokens are used to recognise each different types of selector-combinator. 

We should always have a mean to identify a particular part of the language and avoid giving more than one way to do it. When the language provides it we avoid though tokens
deffinition we avoid overlapping with the language deffinition.


								  		   selector-combinator.<selector-combinator-type>
								  								|
								  								|
One of: .descendant-combinator, .child-combinator, .next-sibling-combinator, .following-sibling-combinator, .pseudo-descendant-combinator, .pseudo-child-combinator, 
.pseudo-next-sibling-combinator, .pseudo-following-sibling-combinator


All selector combinator instances may have one or more delim-token : 


						 				               selector-combinator.<selector-combinator-type>
												          		            |
							    		 ___________________________________|_________________________________
	   						   			/                       			|         			              \
	   						  		   /						            |						           \	
	   					    css-token.delim-token			                *                          css-token.delim-token 


##### .descendant-combinator (" " or ">>")

Note: This is the only one which is constructed of delim-token... 

						 				               ::selector-combinator.descendant-combinator
												          		            |
																			|
															::css-token.whitespace-token

Or

						 				         ::selector-combinator.descendant-combinator
													          		|
							             	  ______________________|______________________
	   						                 /                                             \                            
	   						           	    /						                        \							
	   				        css-token.delim-token.greater-than-sign			    css-token.delim-token.greater-than-sign  




##### .child-combinator (">")

						 				         ::selector-combinator.child-combinator
													          		|
													          		|
							             	    css-token.delim-token.greater-than-sign  

##### .next-sibling-combinator ("+")


						 				         ::selector-combinator.next-sibling-combinator
													          		|
													          		|
							             	    css-token.delim-token.plus-sign  

##### .following-sibling-combinator


						 				         ::selector-combinator.following-sibling-combinator
													          		|
													          		|
							             	    css-token.delim-token.tilde  

##### .pseudo-descendant-combinator (">>|")

						 				               ::selector-combinator.pseudo-descendant-combinator
												          		            |
							    		 ___________________________________|_________________________________
	   						   			/                       			|         			              \
	   						  		   /						            |						           \	
	   		css-token.delim-token.greater-than-sign	     css-token.delim-token.greater-than-sign     css-token.delim-token.vertical-line 


##### .pseudo-child-combinator (">|")

						 				         ::selector-combinator.pseudo-child-combinator
													          		|
							             	  ______________________|______________________
	   						                 /                                             \                            
	   						           	    /						                        \							
	   				        css-token.delim-token.greater-than-sign			    css-token.delim-token.vertical-line  


##### .pseudo-next-sibling-combinator ("+|")


						 				         ::selector-combinator.pseudo-next-sibling-combinator
													          		|
							             	  ______________________|______________________
	   						                 /                                             \                            
	   						           	    /						                        \							
	   				        css-token.delim-token.plus-sign			    css-token.delim-token.vertical-line  


##### .pseudo-following-sibling-combinator ("~|")

						 				 ::selector-combinator.pseudo-following-sibling-combinator
													          		|
							             	  ______________________|______________________
	   						                 /                                             \                            
	   						           	    /						                        \							
	   				        css-token.delim-token.tilde			    css-token.delim-token.vertical-line  



#### [::style-declaration](https://drafts.csswg.org/cssom/#css-declaration-blocks)


						 						       ::style-declaration
												          		|
							    		 _______________________|_________________________
	   						   			/                       |         			      \
	   						  		   /						|						   \	
	   					    ::css-declaration   			        *                   ::css-declaration   


#### [::css-declaration](https://drafts.csswg.org/cssom/#css-declaration)


						 						        ::css-declaration
												          		|
							             			____________|____________
	   						            		   /                         \                            
	   						           			  /						      \							
	   				        	    	  ::property-name          		::property-value-block


#### ::property-name

								 			     		::property-name
												          		|
							             			            |
							             	  css-token.string-token.<string-value>



#### ::property-value 

											          ::property-value-block 
												          		|
							    ________________________________|___________________________
	   						   /                                |                           \ 
	   						  / 								|							 \
					  css-token.colon			  		::property-value         css-token.semi-colon


					  											OR

											          ::property-value-block 
												          		|
							    ________________________________|______________________________________________________
	   						   /                                |                           | 						   \ 
	   						  / 								|							|	 						\
					  css-token.colon			  		::property-value      ::important-declaration	    css-token.semi-colon




#### ::important-declaration


								 			     	::important-declaration
												          		|
							             	 ___________________|____________________
							             	/ 										 \
							               /	  									  \
							         css-token.delim-token 				   css-token.ident-token


### Property values declarations for each kind of property

1. Byy default all elements on following on the right of an element on the same  line are all children of the preceding element, recursively, unless an informal grouping is used using a group elements separator "," or ";" or ":" which indicates a sibling relationship or an implicit grouping is done through language definition, like style declarations which are all siblings of each other. It means that this:

##### font-family

font-family : arial;

would be represented as:


						 						         ::declaration
												          		|
							          __________________________|___________________________
	   						         /                                     				    \                            
	   						        /						                                 \							
	   				    ::property-name.font-family                               ::property-value-block
	   				        	   |                                                         |
	   				        	   |						 ________________________________|___________________________
	   					css-token.string-token              /                                |                           \ 
	   						                               /     						     |							  \
					  						css-token.colon.delimiter		     	::property-value         css-token.semi-colon.delimiter								          		         |
							                                                                 |
							                                                                 |
                            												    ::font-family-name.arial
                            												  				 |
                            												  				 |
																			   css-token.ident-token.arial


							   
The later means that a ::property-value element starts with a css-token.colon element and ends with a css-token.semi-colon element. The group in the preceeding example is the ::property-value element. 

Definition: A ::property-value is a pseudo element because it's value is not written, it is deduced from the syntax. It always starts with colon and
ends with a semi-colon.


An another example with multiple font-family values: 

font-family : arial, "Time New Roman";


::font-family-name.timenewroman the class name is always in lowercase letters. In fact, in general, all class names are in lowercase letters. 


						 						          ::declaration
												          		|
							          __________________________|___________________________
	   						         /                                     				    \                            
	   						        /						                                 \							
	   				    ::property-name.font-family                                ::property-value-block
	   				        	   |                                                          |
	   				        	   |						  ________________________________|___________________________
	   					css-token.string-token               /                                |                           \ 
	   						                                /     						      |							   \
					  					   css-token.colon.delimiter			  		::property-value         css-token.semi-colon.delimiter								          		       |
							          							    __________________________|___________________________
	   						                                       /                          |           				  \                       
	   						                                      /			  			      |                            \	
												   	  ::font-family-name.arial         css-token.coma       ::font-family-name.time-new-roman
												   				 |															|
												   				 |															|
												   	   css-token.ident-token  								css-token.string.time-new-roman


Or:

font-family : arial, Time New Roman;


						 						          ::declaration
												          		|
							          __________________________|___________________________
	   						         /                                     				    \                            
	   						        /						                                 \							
	   				    ::property-name.font-family                                ::property-value-block
	   				        	   |                                                          |
	   				        	   |						  ________________________________|___________________________
	   					css-token.ident-token                /                                |                           \ 
	   						                                /     						      |							   \
					  					   css-token.colon.delimiter			  		::property-value         css-token.semi-colon.delimiter								          		       |
							          							    __________________________|___________________________
	   						                                       /                          |           				  \                       
	   						                                      /			  			      |                            \	
												   	  ::font-family-name.arial         css-token.comma       ::font-family-name.time-new-roman
												   				 |															|
												   				 |								 ___________________________|___________________________
												   	   css-token.ident-token.arial  			/							|							\
												   	   										   /							|							 \
												   	   							css-token.ident-token.time       css-token.ident-token.new 	  css-token.ident-token.roman


With an unknown family name it would look like this:







							   
Now, if we had a function defined in the middle, it will look like this: 

color: rgb(124, 89, 12)

						 						          ::declaration
												          		|
							          __________________________|___________________________
	   						         /                                     				    \                            
	   						        /						                                 \							
	   				    ::property-name.color                                		::property-value-block
								   |  													    		|
								   |  											____________________|_____________________
						css-token.ident-token 								   /			   		|					  \
																	  		  /						|					   \
														css-token.colon.delimiter			::property-value      css-token.semi-colon.delimiter
																						  			|                  
							   														  				|
							   														  		::color-value
							   														  				|
							   										   		   		  				|
							   							 							 		 ::function.rgb
						     						   								 				|
     	  		 ___________________________________________________________________________________|_______________________________________________________________
   		 		/   				|                           |                  |                 |                |                     |                     	\
   			   /   					|							|				   |				 |				  |						|					     \ 
		::function-start	    ::function-param   		css-token.comma    ::function-param  	css-token.comma    ::function-param  	css-token.right-parenthesis
  	   		   |						|									|										|
       		   |						|									|										|
 css-token.function-token.rgb	 	css-token.number 					 css-token.number 						css-token.number			


color: blue;

								  ::color-value
										|	
										|
							   ::color-keyword.blue
										|
										|
							css-token.ident-token.blue



An unknown property would be represented as:


unknown: 123, 45;

								  						  ::declaration
								  								|
								  								|
						   				     unknown.property-name.unknown-property
								     							|
								     							|
														::property-value 
																|
		________________________________________________________|___________________________________________________________
	   |                                |                       |                         |                                 |
	   |								|						|						  |									|
css-token.colon       			css-token.number        css-token.coma             css-token.number                css-token.semi-colon




As we can observed a grouping element always becomes the head of a subtree. When we understand something we make it semantically clear and 
it is reflected in the three. For example, with the function, since we know what it is, we name it. 



#### Examples of complete derivations:

p {
	font-size : larger;
}
        
Derived tree:
                                                    ::css-style-sheet
                                                            |
                                                            |
                                                    ::css-style-rule
                                                            |
                            ________________________________|______________________________
                           /                                                               \
                          /                                                                 \
                ::selector-list                                                     ::style-declaration-block
                         |                                                                  |
                         |                                  ________________________________|______________________________
                ::complex-selector                         /                                |                              \
                         |                                / 								|					     		\
                         |                      css-token.left-curly-brace		  ::style-declaration       css-token.right-curly-brace
               ::compound-selector                                                          |
                         |                                                                  |
                         |                                                          ::css-declaration
                 ::type-selector                                                            |
                         |                                                      ____________|____________
                         |                                                     /                         \
              css-token.ident-token                                           /						      \
                                                            ::property-name.<name-of-property>       ::property-value
                                                                              |                             |
                                                                              |                             |
                                                                    css-token.string-token                  |
                                                                                                            |
                                                                                                            |
                                                                            ________________________________|___________________________
                                                                           /                                |                           \
                                                                          / 								|							 \
                                                                css-token.colon			     ::property-value-declaration         css-token.semi-colon
                                                                                                            |
                                                                                                            |
                                                                                            ::keyword.font-size-value.larger
                                                                                            				|	
                                                                                            				|
                                                                                            	 css-token.string-token




### Syntax Module impacts 

### Cascading and Inheritance Module impacts 

### Selector Module impacts 

### Pseudo-Elements Module impacts 


## Pseudo CSS DOM elements Description 

The choice of pseudo elements has been done in function of selectors features in CSS. 

### Property changes 
I
Properties in CSS DOM are all

### Declaration 

::declaration
I
—>	<property name>.property-name

—>	—>	::property-value


### Token 

Every token is passed all the way to the CSS DOM representation. Those tokens are defined in the [CSS Syntax Module standard](https://drafts.csswg.org/css-syntax/#tokenization) and comprise the followings: 

<ident-token>, <function-token>, <at-keyword-token>, <hash-token>, <string-token>, <bad-string-token>, <url-token>, <bad-url-token>, <delim-token>, <number-token>, <percentage-token>, <dimension-token>, <include-match-token>, <dash-match-token>, <prefix-match-token>, <suffix-match-token>, <substring-match-token>, <column-token>, <whitespace-token>, <CDO-token>, <CDC-token>, <colon-token>, <semicolon-token>, <comma-token>, <[-token>, <]-token>, <(-token>, <)-token>, <{-token>, and <}-token>.

When a token is encountered by the CSS DOM converter, it assigns to the token, a class value which name correspond to the previous 
e.g. <ident-token> would have a class of .ident-token. Obviously, a token is not an abstract value, it has a real presentation in the text, 
and as such is 


### Unsupported property 

Unsupported property are always represented using their tokens types coming out of the lexical analysis. Those tokens are defined in the CSS syntax module (see above). Here is an example of a DOM representation of an unsupported property:

unsupported-property-name: 12px

::declaration

—>	<unsupported-property-name>.property-name.unsupported-property

—>	—>	::property-value 

—>	—>	—>	css-token.number-token

—>	—>	—>	css-token.dimension-token



### Keyword 

<keyword name>

### String 

string.font-family-name

For example the following CSS :

font-family : Times New Roman, Arial;

would be represented as :

::declaration

—>	<font-family>.property-name

—>	—>	::property-value 

—>	—>	—>	string.font-family-name (Times New Roman)

—>	—>	—>	Arial.keyword.font-family-name (Arial)

### Quoted String 

quoted-string.font-family-name

For example the following CSS :

font-family : “Times New Roman”, Arial;

would be represented as :

::declaration

—>	<font-family>.property-name

—>	—>		::property-value 

—>	—>		—>		quoted-string.font-family-name (Times New Roman)

—>	—>		—>		Arial.keyword.font-family-name (Arial)

### Number 

number.real-number 	| number.integer-number 

### Length 

::length 

—>	number 

—>	—>		<unit name>.unit 


### Percentage 

::percentage

—>	number 

—> 	—>		percent-sign

### colorValue



### Font-Size property 

::declaration

-> 	<property name>.property-name

-> 	-> 	::property-value

->	->		->						<keyword>.absolute  
							| 	 	<keyword>.relative
							| 		::length	
							|			::percentage 
### Font-Family property 

::property-value

—>	(keyword|string)+ 



 


