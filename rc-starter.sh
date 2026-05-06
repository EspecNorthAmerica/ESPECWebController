#!/bin/bash
#####################################################################
# author: Paul Nong-Laolam <pnong-laolam@espec.com>
# company:
#    ESPEC North America, Inc.
#    4141 Central Parkway
#    Hudsoneville, MI 49426
#####################################################################
# filename: rc-starter.sh
# update: March 2022,
#         March 2023, April 2023 : Edited for Pandoc 2.5
#
# OBJECTIVE:
# ---------
# This short script program starts the PDF process of
# ESPEC Web Controller User's Manual.  This process
# requires several steps taken in sequential:
# 1. Perform Markdown to LaTeX conversion (md-files --> TeX-files)
# 2. Extract and download images from Bitbucket
# 3. Build LaTeX structures, place doc files from Step 1 into parts
# 4. Compile and process LaTeX source files (.tex) into PDF
#####################################################################

clear

# if markdown files not found, program is terminated
MD_FILE="file/chkmdfile"
while IFS= read -r line; do
    if [[ ! -f ./$line ]]; then
        if [[ ! -f ./mdfiles/$line ]]; then
            echo "Markdown file {$line} not found; program terminated."
            exit 1
        else
            cp ./mdfiles/$line ./.
        fi
    fi
done < "$MD_FILE"


FM_FILE="file/chkfmfile"
while IFS= read -r line; do
    if [[ ! -f ./$line ]]; then
        cp ./format/$line ./.
        cp ./texsource/ewc-man-v3_3.tex ./.
    fi
done < "$FM_FILE"

# modify the .tex file to meet Pandoc V2.5+ requirements
pandocMOD() {
# STARTING
# removing the \hyperref{} tag from these files
sed -i '/^\\hyper.*/d' ./about.tex
sed -i '/^\\hyper.*/d' ./part1.tex
sed -i '/^\\hyper.*/d' ./settings.tex
sed -i '/^\\hyper.*/d' ./es102.tex
sed -i '/^\\hyper.*/d' ./scp220.tex
sed -i '/^\\hyper.*/d' ./f4.tex
sed -i '/^\\hyper.*/d' ./f4t.tex
sed -i '/^\\hyper.*/d' ./typhoon.tex
sed -i '/^\\hyper.*/d' ./p300.tex
sed -i '/^\\hyper.*/d' ./f4tmimo.tex 

# comment out the first four lines of structure.tex with a %
#sed -i '1,4 s/./%&/' ./structure.tex

# another approach is to delete top two lines of structure.tex
#sed -i '1,2d' ./structure.tex

# remove the stupid strey of s**t from Pandoc conversion...
#sed -i '/^\\]{article}/d' .structure.tex 

# correct Pandoc V2.5+ error on LaTeX \usepackage{}{} 
# replace and add usepackage of hyperref and setup
#sed -i 's/^\\usepackage{hyperref}/\\usepackage\[unicode=true\]{hyperref}/' ./structure.tex

# upload the master configuration instead to avoid other misconfig tags 
cp ./texsource/structure.tex ./

printf ">> Done!\n"
} # END pandocMOD

cont() {
   read -p "Press <Enter>"
}

######################################################################
printf "(1). Proceed to convert Markdown files to LaTeX with Pandoc..."
cont
# call Pandoc process script
bash ./rc-pandoc-2-latex.sh

printf "\n(2). Proceed to process image extraction for LaTeX files..."
cont
# call wget xtract script to extract and fetch images
bash ./rc-wget-xtract-img.sh

printf "\n(3). Proceed to process insertions of LaTeX files into specific parts..."
cont
# call doc xtraction script
bash ./rc-doc-xtraction.sh

# call LaTeX process script
# but first call pandocMOD correction to render
# minor changes for Pandoc V2.5 or higher
printf "\n(3a). Proceed to modify and fix Pandoc error on LaTeX tags with sed..."
cont
pandocMOD

printf "\n(4). Proceed to process LaTeX files into PDF..."
cont
bash ./rc-process-pdf.sh

# comment out the rm-cmd to debug LaTeX errors (log-file)
rm ./{ewc*.md,*.log,*.aux,*.out,*.toc}

# delete all .tex files, except ewc-man-v3_3.tex 
find . -type f -name "*.tex" ! -name "ewc-man-v3_3.tex" -delete
######################################################################

echo ">> PDF has been created. "
