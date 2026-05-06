#!/bin/bash
#
#
#cmd: pdftk
#A=cl19v2.pdf: filename assigned to A
#cat: concatenateion
#A36-72: Extract A from pages 36 to 72
#output: set output flag
#pages_36_72.pdf: output filename 
#
# pdftk A=cl19v2.pdf cat A36-74 output lab36-72.pdf  
#
# variable declaration
read -p "Input file name (example: cis275.pdf): " ifile
read -p "Output file name (example: lab9.pdf): " ofile
read -p "Begin page number: " ipage
read -p "End page number: " fpage

# extraction process
pdftk A=$ifile cat A$ipage-$fpage output $ofile
