# Readme 

This document contains all the documentation for both Stylo and Nodio. It is used to generate the stylo.help and nodio.help guides along with the web documentation. 

We should always keep in mind that we may eventually just use the website and the help would just link to the documentation there. But for now, we like the fact that both Stylo and Nodio are self contained apps with their own help. 


# How to use this document 

The basic usage is to use this document with its folders and markdown files "as is" for the website. This is beause we want as less operations as possible on the web and generate everything from the this document if possible. 

For the nodio.help and stylo.help, we need a manual operation to convert the md files to HTML and we need to extract the body to insert it at the proper location in the final HTML. This is why in this document, the links are expressed in terms of the website: we need a manual editing operation anyway in the help so we can convert the # anchors to the proper .html link in the html document. 
   
## Web 

Simply drop this document in the web and this documentation should be handled automatically. Of course, we need to handle the addition/removal of files and find them a proper place to go, but we should make sure that the web is handled as a drop-in. 

For proper linking there should be no reference from the _common_ directory to application specific documentation in _nodio_ or _stylo_.

## Stylo and Nodio help 

The stylo.help and nodio.help should be handled differently. First we need to export the source md file to the <md file name>-original.html file. And then we need to copy the body to the <md file name>.html file. After that we need to modify the links (which are based on the website structure, to the help structure. 



