# ESPEC Web Controller V3.3 Manual

Author: Paul Nong-Laolam  
Company: ESPEC North America , 4141 Central Parkway, Hudsonville, MI 49426
Date: March 2022; May 2026 
Created and maintained by Paul Nong-Laolam. 

## Changes made in EWC V3.3

EWC V3 User's Manual in plain text files was originally implemented using jinja to handle and prepare the documentation.
An engine then is applied to convert the documentation to MarkDown in order to
publish individual documents each dedicated to a specific type of chamber as online manuals under ESPEC wiki page (on bitbucket). 

These files in jinja format were intended to be applied as embedded documentations to be available natively in 
ESPEC Web Controller software.  

Jinja document implementation no longer applies since the whole concept was 
moved from implementing an embedded manual inside ESPEC Web Controller to embedded PDF file, loadable and rendered in the UI. The issue was the complication of handling 
480+ images and counting (to be embedded and made available within the software); 
a move that proved impractical for storage requirement. 
Embedded PDF stored in a separate folder in turn proved more practical. 
Embedment of ESPEC Web Controller V3 User's Manual is now based on MarkDown conversion into PDF; this PDF is then embedded inside the Web Controller software. 

This process alleviates the complication of handling embedded images 
and figures in the Web Controller (to reduce the file size); hence, the purpose of this repository.

See NOTES.md for details

# Setup
Required packages and tools are: latex and tex-live, default installed of pandoc, v2.5+, currently v2.9.

Due to specific format requirements for the manual in PDF, current version of pandoc does not convert markdown files to LaTeX correctly. 
Current pandoc will break the process and render the converted text unusuable to produce the required PDF output in LaTeX. Thus, a new
format file containing modified LaTeX tags and preambles are created. It is inserted into the LaTeX file prior to processing. 

## Debian 11
Install the following packages: LaTeX, pandoc and Tex-live Tool

1. apt update
2. apt install -y texmaker texlive texlive-latex-base texlive-latex-extra 
3. apt install -y pandoc 

# Processing the PDF file

Individual markdown files in folder **mdfiles** are first converted to standard (roughly general) LaTeX files and are stored in folder **texfiles**. 
These files go through text manipulation into invidual parts and are then recombined with custom format files in folder **format**. 
These files and their individual parts will be incorporated into a new source textfile in folder **texsource**; the custom format in structure.tex is brought in from which a PDF 
processing and rendering using the LaTeX utility is taking place. 

Processing and rednering these files into PDF requires four separate stages through ``rc-executed-files``: 

1. Convert Markdown to (general) LaTeX files via pandoc. 
2. Fetch images from Bitbucket Wiki page
    - [x] remove all the https hyperlinks from the text
    - [x] fetch the image files and place them in appropriate figure with LaTeX tags
    - [x] rename and fix image files whose filename contain white spaces.
3. Fix LaTeX format produced by pandoc; extract sections into required components and parts.
    - [x] remove general LaTeX format produced by pandoc
    - [x] insert in specific sections the required format to produce proper LaTeX reamples.
    - [x] split .tex into specific document required by ESPEC Web Controller Manual format
4. Inject the general structure and process all the .tex files into the final PDF output. 

Four separate execution files (in .sh) are resposible for these four stages:

    1. rc-starter.sh : a file that starts the whole process
    2. rc-pandoc-2-latex.sh: a file that handles markdown conversion
    3. rc-wget-xtract-img.sh: a file that handles image fetching and hyperlink corrections/removal
    4. rc-doc-xtraction.sh: a file that fixes pandoc-to-latex errors (lots of errors produced by pandoc) and finalizes the correct format for the LaTeX
    5. rc-process-pdf.sh: a file that handles the PDF rendering and processing. 

The rc-starter.sh file calls in the other files to perform the tasks in these four stages. 

See NOTES.md for details. 

# How to Produce PDF file

To process a new manual, start by: 

- [X] Ensure that the MD files in mdfiles folder are most current.
- [X] Copy figures folder (containing image files) from archive to speed up the image fetching process. 
- [X] execute the rc-starter.sh file

# Final Output File
The final output file in PDF is placed in the main directory with filename: 

ewc-man-v3_3.pdf 

