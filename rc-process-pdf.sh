#!/bin/bash
#
############################################################
# author: Paul Nong-Laolam
# title: software engineer
# company:
#   ESPEC North America, Inc.
#   4141 Central Parkway
#   Hudsonville, MI 49426
############################################################
# filename: process-pdf.sh
# update: March 2022
# July 2022: Added section on ES102 in the manual 

############################################################
# function call to PDF documentation 
process() {
# need to process LaTeX file twice in order
# to render the frontmatter contents

# preprocessing: first document processing
pdflatex ewc-man-v3_3.tex


# post-processing: second document processing ...
# to render correct format and Table of Contents   
pdflatex ewc-man-v3_3.tex
} 

############################################################
# file name declaration
F4T="./f4t.tex"
TYPHOON="./typhoon.tex"
F4="./f4.tex"
P300="./p300.tex"
SCP220="./scp220.tex"
ES102="./es102.tex"

############################################################
# archive the TeX files
TEX_FILE="file/chktexfile"
while IFS= read -r line; do
    cp ./$line ./texfiles/.
done < "$TEX_FILE"

SRC_FILE="file/chksrcfile"
while IFS= read -r line; do
    cp ./$line ./srcfiles/.
done < "$SRC_FILE"

############################################################
# Preliminary check for DPF processing requirements
# To ensure all files are ready for processing , the 
# conditions must be met. 
#
if [ ! -f "$F4T" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for F4T. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

elif [ ! -f "$TYPHOON" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for Typhoon. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

elif [ ! -f "$F4" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for F4. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

elif [ ! -f "$P300" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for P300. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

elif [ ! -f "$SCP220" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for SCP220. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

elif [ ! -f "$ES102" ]; then
   printf "\nError!\n"
   printf "LaTeX file extraction has not be done for ES102. \nPerform that task first.\n"
   read -p "Press ENTER to return to main option. " opt
   bash rc-starter.sh 

else
   process
fi
