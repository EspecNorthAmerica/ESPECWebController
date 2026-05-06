#!/bin/bash
# 
# filename: rc-pandoc-2-latex.sh
#########################################################################
# Author: Paul Nong-Laolam, Software Engineer
#         ESPEC North America, Inc
#         4141 Central Parkway
#         Hudsonville, MI 49426
#         pnong-laolam@espec.com
# All rights reserved. Copyright(c): ESPEC North America, INC 
# August 18, 2021
# update: March 2022
#         July 2022: Added ES102 block 
#########################################################################
# This script converts our ESPEC Web Controller wiki manual
# in markdown language to LaTeX, then from LaTeX to PDF file for
# hardcopy distribution to customers for the operation of the ESPEC Web 
# Controller Software. The copy is also distributed as an embedded
# manual on the Web Controller Software itself. 
#
# A direct conversion of the manual from markdown to LaTeX performed 
# by Pandoc is not practical since the conversion was done in the
# simplest and generalist form. Our PDF manual requires a format
# that conforms to the standards of ESPEC corporate manual. To that
# end, necessary LaTeX preamble commands must be manually injected 
# into the LaTeX source file after it was converted from Pandoc. 
#
# We must also clean up some unnecessary mess left behind by Pandoc 
# during the markdown-to-LaTeX conversion. The following script 
# basically accomplishes this objective very effectively. 
#
# After all the necessary conversion & inclusion of LaTeX commands,
# PDF process is run through twice to render the format properly. 
#
# LaTeX does not download and process images (originally included 
# in the markdown file) to be included in the manual. Therefore, 
# all the directives (that include links) in the document:
#    \includegraphics{} 
# must be handled separately. Images must be made available locally
# and the \includegraphics{} must be modified to call these images
# from the local dirtectory. The grep utility was used to handle the 
# extraction of images links, download them and reprocess 
# the PDF rendering. 
#
# The only thing that requires manual manipulation is to download or
# repair an image with the appropriate ID number assigned by github.org 
# and store it in the figures directory so that the LaTeX file can 
# process and integrate those images in the PDF layout. 
#########################################################################

# Function call for each markdwon to latex conversion.
process() { 
printf ">> Converting ${1} from markdown to LaTeX: ${2}..."
#
# convert markdown file to LaTeX source file
# this command translates markdown contents to .tex file 
pandoc -f markdown $1 -so $2

#
# make a duplicate as a backup for safe keeping
# obtain original copy before injecting all LaTeX preambles
#cp $2 original/$2.orig

#
# remove the Table of Contents directive of markdown, incompatible with LaTeX
# we essentially replace a matched pattern with an null space here 
sed -i 's/\\textbf{Table of Contents}//g' $2
sed -i 's/{\[}TOC{\]}//g' $2

#
# modify document class for the correct font size required by ESPEC
# we simply insert a 12pt marker into the \documentclass 
#sed -i 's/\\documentclass\[\]/\\documentclass\[12pt\]/g' $sourcefile 
# replace report class with book class
sed -i 's/^\\documentclass\[\]{article}/\\documentclass\[11pt,twoside\]{book}/' $2

#
# replace https:// links with standard LaTeX style for \includegraphics
# we incorporate LaTeX figuration styles; markdown uses its own styles
# to link an image from wihtin its database; we essentially remove the link
# and include only the LaTeX commands to render a figure placement 
#sed -i 's/\\includegraphics{https:\/\/bitbucket.org\/repo\/kMrjrgg\/images\//\\includegraphics{/g' $sourcefile 
sed -i 's/\\includegraphics{https:\/\/bitbucket\.org\/repo\/kMrjrgg\/images\//\n\\includegraphics{figures\//g' $2
sed -i 's/\\includegraphics{https:\/\/bitbucket\.org\/repo\/87eopek\/images\//\n\\includegraphics{figures\//g' $2
#
# scale all figures to 95% of textwidth
sed -i 's/\\includegraphics/\\includegraphics\[width=0\.95\\textwidth\]/g' $2
# with the exception of Figure 1.5 (Overview page on a handheld device).
# This one will be 90% rendition to fit the page with the following 
# sed script:
sed -i 's/^\\includegraphics.*300869538.*/\\includegraphics\[width=0.90\\textwidth\]{figures\/300869538\-overview\-page\-handheld\-000a\.PNG}/' $2


#########################################################################
# control floating figures to place them exactly where their text is
# we need to control figure floatation thereby enforcing the figure placement
# at the corresponding text
# NOTE: The \FloatBarrier command requires the use of: 
#                     \usepackage{placeins}
#       which must be inserted in the preamble. 
#  
#sed -i '/\\end{figure}/a\\\FloatBarrier' $sourcefile
sed -i 's/\\end{figure}/\\end{figure}\\FloatBarrier/g' $2
# all images are located in one folder, called figures. 

#
# insert LaTeX preamble statements following \documentclass
# we insert a block of LaTeX preambles to control text & body structure
# that include header and footer commands
sed -i '/\\documentclass/r textwidth-header-footer.tex' $2

#
# include usepackage{placeins} to control figure floating
# we add the required packages to generate the desired layout 
sed -i '/\\usepackage{graphicx,grffile}/a\\\usepackage{placeins}' $2
# this will be placed after the usepackage{graphicx...}

#
# insert call statements following \begin{document}
# we include the copyright notice and title page block 
#sed -i '/\\begin{document}/a\\\include{copyright-title-page}' $sourcefile
sed -i '/\\begin{document}/a\\\input{cpright-title-page}' $2
# we use a LaTeX call (include) statement to place the content of a file
# right after the \begin{document} directive

#
# insert page number style to arabic, place it before a match pattern (first chapter)
#sed -i '/\\chapter{Introduction}/i\\\pagenumbering{arabic}' $sourcefile
sed -i '/\\include{cpright-title-page}/a\\\pagenumbering{arabic}' $2
#
# include text for last page; this is a very complicated process.
# we first create a place for insertion, using %version-release as a marker
# then locate the %version-release string literal to insert text from a file
#
# insert a marker
# note: This action will be taken on the final preamble file
#sed -i '/\\end{document}/i\%version-release' $sourcefile
# search for a marker and replace it with the desired string 
#sed -i '/%version-release/r version-note.tex' $sourcefile

#
# Remove section numbering produced by Pandoc.
sed -i 's/^\\section{[0-9]\+\s\+/\\chapter{/g' $2
sed -i 's/^\\subsection{[0-9]\+\.[0-9]\+\s\+/\\section{/g' $2
sed -i 's/^\\subsubsection{[0-9]\+\.[0-9]\+\.[0-9]\+\s\+/\\subsection{/g' $2

# remove all section labels produced by Pandoc in the LaTeX file
# they will be replaced with a better control structure and format
# fix and modify the following format:
#     from  \section{...} \label{...}
#     to    \section{...} 
sed -i 's/\\label{.*//g' $2

#
# include tcolorbox package... replace {amssymb,amsmath} with {amssymb,amsmath,tcolorbox}
sed -i 's/\\usepackage{amssymb,amsmath}/\\usepackage{amssymb,amsmath,tcolorbox}/g' $2
# we simply include an additional package in the curely braces

#
# add newpage break to these subsections (required by ESPEC standard format) 
# insert this section from the original file back in here...

#
# fix the last reference section that did get rendered properly by Pandoc
# with regards to Section 15.0 on the Section reference
sed -i 's/(\\#markdown-header-139-external-sources)//g' $2

#########################################################################
#
# Modify report class to book class
#
#########################################################################
# comment out the numbering created by Pandoc
sed -i 's/^\\setcounter.*/%\\setcounter{secnumdepth}{0}/' $2

#
# insert chapter title preamble and setup via a file insertion
# insert this block from the file before a match pattern called 
# (date{})
#sed -i '/\\date{}/i\\\include{chapter-title-display}' $sourcefile
sed -i '/\\date{}/i\\\input{chapter-title-display-2}' $2

echo "Done!"
}

# echo "Converting Typhoon markdown file to LaTeX."
MFILE="ewc-typhoon-man-v3.md"; LATEXSRC="ewc-typhoon-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting F4T markdown file to LaTeX."
MFILE="ewc-f4t-man-v3.md"; LATEXSRC="ewc-f4t-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting P300 markdown file to LaTeX."
MFILE="ewc-p300-man-v3.md"; LATEXSRC="ewc-p300-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting SCP220 markdown file to LaTeX."
MFILE="ewc-scp220-man-v3.md"; LATEXSRC="ewc-scp220-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting F4 markdown file to LaTeX."
MFILE="ewc-f4-man-v3.md"; LATEXSRC="ewc-f4-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting F4 markdown file to LaTeX."
MFILE="ewc-es102-man-v3.md"; LATEXSRC="ewc-es102-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE

# echo "Converting F4 markdown file to LaTeX."
MFILE="ewc-f4tmimo-man-v3.md"; LATEXSRC="ewc-f4tmimo-man-v3.tex"
process ${MFILE} ${LATEXSRC}
#doneit $MFILE
