" Maven POM file type auto-detect.
" Author: Rubin Simons <rubin@raaf.tech>
" Version: 1.0
" Last Modified: 2018-07-04

au BufRead,BufNewFile pom.xml set filetype=pom
au BufRead,BufNewFile pom.xml set syntax=xml

