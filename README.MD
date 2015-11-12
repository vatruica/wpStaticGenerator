Wordpress static website generator 

## Main idea
Run your Wordpress based website in a VM, modify it's contents and only upload the statically generated files to your webhost.

## How it's done

Static files are being generated using Really-static 
Static files are then copied to a different location along with included wordpress content (what's needed from the wp-content and wp-includes folders )
Bash parses the files in order to rewrite urls
Bash uploads files to host
Bash is being handled by a custom Wordpress plugin so that the user doesn't need to use the command line

## How should be done
 
A single Wordpress custom plugin handling static file generating, parsing and uploading to a webhost.


