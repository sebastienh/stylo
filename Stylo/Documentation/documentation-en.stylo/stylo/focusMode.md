# Focus Mode 

Focus mode allows to _focus_ on an edited text element. Nodio supports 3 focus mode, appart from disabled. 

- sentence 
- paragraph
- bloc 

In sentence mode, the text is focused on the surrounding sentence inside the text. In some context where the text is part of a bloc element like a `blockquote`, the sentence may be reduced to a line. 

In paragraph mode, the entire paragraph is focused. A paragraph is any continuous text not broken by a new line. 

Bloc mode allows to keep the focus at the bloc level, might it be a list or a quote for example. The focus will always be at the top level bloc, so if we have text like the following:

```markdown 
> first line 
> > second line 
> third line 

```

writing in the second line will still keep the focus on the entire first level blockquote. 


