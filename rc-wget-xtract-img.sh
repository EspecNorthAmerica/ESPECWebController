#!/bin/bash
#############################################################
# author: Paul Nong-Laolam, Software Engineer
# company:
#   ESPEC North America, Inc.
#   4141 Central Parkway
#   Hudsonville, MI 49426
#
# date: August 2021
# update: March 2022
#         July 2022: Added ES102 block 
#############################################################
# This short script performs the following:
#   1. extract all the image links in Markdown document,
#      compile them and store as file (img-2-extract-file)
#      under the figures/ directory
#   2. download those images using the wget command
#      and place them in the figures/ directory.
#############################################################

xtract() {
# create dir "figures" if it does not yet exist
[ ! -d "./figures" ] && mkdir ./figures

# extract image links from the main document
#grep -E -o 'https:.*)' ewc-f4t-man-v3.md | sed 's/)//' > figures/img-2-extract-file
grep -E -o 'https:.*)' $1 | sed 's/)//' > figures/img-2-extract-file

# change over to figures directory
cd figures

# apply wget to download the image files from bitbuket
# they will be placed in the figures directory
# where LaTeX will fetch to inject into the PDF 
# document during compiling and porcessing 
wget -nc $(cat img-2-extract-file)

# change directory back to parent directory for next file...
cd .. 

# notification for each file image processing
echo ">> Image extraction and download for ${1}...completed." 
}

cont() {
   read -p "Press <Enter>"
}


# processing img fetching for typhoon md file
fn="ewc-typhoon-man-v3.md"
printf "Proceed to extract images for ${fn}..."
cont
xtract ${fn}

# processing img fetching for f4t md file
fn="ewc-f4t-man-v3.md"
xtract ${fn}

# processing img fetching for p300 md file
printf "Proceed to extract images for ${fn}..."
cont
fn="ewc-p300-man-v3.md"
xtract ${fn}

# processing img fetching for scp220 md file
fn="ewc-scp220-man-v3.md"
printf "Proceed to extract images for ${fn}..."
cont
xtract ${fn}

# processing img fetching for f4 md file
fn="ewc-f4-man-v3.md"
printf "Proceed to extract images for ${fn}..."
cont
xtract ${fn}

# processing img fetching for es102 md file
fn="ewc-es102-man-v3.md"
printf "\nProceed to extract images for ${fn}..."
cont
xtract ${fn}

# processing img fetching for f4t-mimo md file
fn="ewc-f4tmimo-man-v3.md"
printf "\nProceed to extract images for ${fn}..."
cont
xtract ${fn}

