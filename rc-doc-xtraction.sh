#!/bin/bash
#
# author: Paul Nong-Laolam
# title: software engineer
# company: 
#    ESPEC North America, Inc.
#    4141 Central Parkway
#    Hudsoneville, MI 49426
############################################################
# filename: rc-doc-xtraction.sh
# update: March 2022
#         July 2022: added ES102 parts 
############################################################
# This short script splits each LaTeX document from 
# markdown into unique chapter to be included in the PARTS 
# of the main User's Manual.
#
# This process allows the important parts of each manual 
# to be included separately and in its own Part to provide 
# ease of use for end-users. 
#
printf "\n\n"

f4t() {
############################################################
# F4T document prepartion
f4t0="ewc-f4t-man-v3.tex"

# extract preamble and save content in: header.tex
# everything before the match: \input{chapter-title-display2}
# will be extracted and saved. 
sed '/^\\input{chapter.*}/,$d' ${f4t0} > structure.tex
sed -i 's/^\\documentclass.*$//g' structure.tex

# remove preamble contents and save remaining
# in: body.tex for F4T
sed '/\\chapter{Intro.*}/,$!d' ${f4t0} > f4t-body.tex

# extract first three chapters: Chapter 1-3 
# and save it as part file: part1.tex
# NOTE: ch1-3 is anything before \chapter{Overview}
sed '/\\chapter{Overview}/,$d' f4t-body.tex > part1.tex

# remove last line in first section that starts with:
# 'This manual focuses on...'
sed -i '/^This manual focuses on/d' part1.tex

# Modify section title on "How to Use the Online..."
sed -i 's/^\\section{How to Use the Online/\\section{How to Use this Manual}/' part1.tex

# remove body of section "How to Use this Manual"
sed -i '/^Manual}/,+9d' part1.tex

# insert new body into section "How to Use this Manual"
# insert a .tex file (containing this body) after the
# \section{How to Use...}
sed -i '/^\\section{How to Use this Manual}/r how-2-use-manual.tex' part1.tex

# To merge the section of T-series/F4T with part1.tex,
# 1. add a marker
# add a marker above \chapter{User}
sed -i '/^\\chapter{User}/i add-typ-ch2' part1.tex
# 2. insert a file (typ-ch2.tex) after a marker
sed -i '/add-typ-ch2/r typ-ch2.tex' part1.tex
# 3. delete a marker
sed -i 's/^add-typ-ch2//' part1.tex 


############################
### NEW CODE TESTING
#
# NO LONGER NEED....
#
# FIXED the chapter 2 title
#sed 's/\\chapter{Initial.*/\\chapter{Initial Setup and First-Time Use}/' part1.tex > part1v1.tex
# remove Use} after the chapter 2 title
#sed 's/^Use}//' part1v1.tex > part1v2.tex


#insert T-series and Custom F4T Initial Setup file after Chapter 2 (Initial Setup...)
#sed -i '/^\\chapter{Initial Setup and First-Time Use}/r typ-ch2v1.tex' part1v2.tex

# rename part1v2.tex back to original file:
#mv part1v2.tex part1.tex
# 
### END NEW CODE TESTING
############################

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' f4t-body.tex > f4t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called f4t-main.tex 
# this is the f4t main chapters.
sed '/\\chapter{Settings}/,$d' f4t-main0.tex > f4t.tex

# remove everything before \chapter{Settings}
# and save the remaing as: f4t-main0
# so that it can be eliminated to extract just the 
# \chapter{Settings} to be as: settings.tex
#sed '/\\chapter{Settings}/,$!d' f4t-main0.tex > settings.tex

# extract last \chapter{About} and put it by itself. 
#sed '/\\chapter{About}/,$!d' settings.tex > about.tex
# remove last line: \end{document}
#sed -i 's/^\\end{docum.*$//g' about.tex

# extract just the contents of \chapter{Settings} and save
# it back into its own original file
# this will remove anything starting with \\chapter{About} 
#sed -i '/\\chapter{About}/,$d' settings.tex

###############################################################
# RESULT OF F4T FILES
###############################################################
<<COMMENT0
 1. structure.tex : the LaTeX preamble and instructions

 2. f4t.tex : the F4T main file

 3. part1.tex : the file or part that contains the first
                three chapters
 4. about.tex : the last chapter to be include in Part I

 5. settings.tex : the Settings menu to be discussed in
                   general for all the controllers.
COMMENT0

#
# The following extractions do not need to be retained; they
# can be removed and output to null. Thus, only the contents
# between
#   \chapter{Overview}
#
#   and
#
#   \chapter{Start Stop}
#
# need to be extracted and put in the final file called
#   typhoon-main.tex
#
cp ./structure.tex ./format/. 
rm {f4t-main0.tex,f4t-body.tex}
}  # END OF F4T FUNCTION


############################################################
# GOAL:
#    Need to extract chapter titles:
#    'Overview' through 'Start Stop'
#    These will be the main body for each chamber.
############################################################

typhoon() {
############################################################
# Typhoon document preparation
#
typ="ewc-typhoon-man-v3.tex"

####
# BEGIN NEW SECTION 
############################################################
# EXTRACTING JUST CHAPTER 2 ON INITIAL SETUP
# Remove everything from Chapter 2 and up;
# save the rest as "t-temp.tex"
sed '/\\section{Standalone System:\sT-Series.*/,$!d' ${typ} > t-temp.tex

# remove everything starting with Chapter 3 (User) 
# save the remaining as "typ-ch2.tex" 
sed '/\\chapter{User}/,$d' t-temp.tex > typ-ch2.tex

# remove the first two lines of "typ-ch2.tex":
# save the rest back in "typ-ch2v1.tex"
#sed '1,2d' typ-ch2.tex > typ-ch2v1.tex 
############################################################
# END NEW SECTION
####

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > typhoon.tex

# remove everything before \chapter{Settings}
# and save the remaing as: f4t-main0
# so that it can be eliminated to extract just the 
# \chapter{Settings} to be as: settings.tex
sed '/\\chapter{Settings}/,$!d' t-main0.tex > settings.tex

# extract last \chapter{About} and put it by itself. 
sed '/\\chapter{About}/,$!d' settings.tex > about.tex
# remove last line: \end{document}
sed -i 's/^\\end{docum.*$//g' about.tex

# extract just the contents of \chapter{Settings} and save
# it back into its own original file
# this will remove anything starting with \\chapter{About} 
sed -i '/\\chapter{About}/,$d' settings.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF TYPHOON FUNCTION

p300() {
############################################################
# P300 document preparation
#
typ="ewc-p300-man-v3.tex"

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > p300.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF P300 FUNCTION

f4() {
############################################################
# F4T document preparation
#
typ="ewc-f4-man-v3.tex"

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > f4.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF F4 FUNCTION

scp220() {
############################################################
# SCP220 document preparation
#
typ="ewc-scp220-man-v3.tex"

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > scp220.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF SCP220 FUNCTION

es102() {
############################################################
# ES102 document preparation
#
typ="ewc-es102-man-v3.tex"

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > es102.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF ES102 FUNCTION

f4tmimo() {
############################################################
# F4T Custom Chamber document preparation
#
typ="ewc-f4tmimo-man-v3.tex"

# remove first three chapters (Chapter 1-3)
# and save the rest in a new file 
sed '/\\chapter{Overview}/,$!d' ${typ} > t-main0.tex

# extract everything before \chapter{Settings} and output it
# to a new file, called typhoon.tex 
# this is the typhoon main chapters.
sed '/\\chapter{Settings}/,$d' t-main0.tex > f4tmimo.tex

rm t-main0.tex

echo ">> Done processing ${typ}."
} # END OF F4 FUNCTION

############################################################
# processing tex into parts in LaTeX 
# calling each function for processing
typhoon
f4t
p300
scp220
f4
es102
f4tmimo
