# Introduction

Author: Paul Nong-Laolam <pnong-laolam@espec.com> 
Title: Software Engineer
Company: ESPEC North America
Copyright(c) 2018-2022
update: March 2022; July 2022; November 2022
--------------------------------------------
Updated: 
4/2019,  Web Controller V2.4
6/2021,  Web Controller V3.0
8/2021,  Web Controller V3.0
3/2022,  Web Controller V3.1
7/2022,  Web Controller V3.2.x (on Debian 11) 
11/2022, Web Controller V3.2.3
--------------------------------------------

Our Web Controller Version 3.0 is available in two different formats:

(1) Online Web via wiki @ https://bitbucket.org
    Its URL is: https://bitbucket.org/especnorthamerica/especweb/wiki/

    This manual is available online 24 hours a day. The available version 
    is specific to each controller; each link points to the specific
    chamber/controller. 

(2) Physical Document: PDF
    The PDF version is available for purchase from our ESPEC North America, Inc. 
    This printed PDF version consists of all the versions on the wiki page 
    Web Controller V3 Home at https://bitbucket.org

CONVERTING online wiki manual to PDF
====================================
The online manual was produced using the Bitbucket markdown language.
This source file can be converted to PDF using Pandoc convert utility. 

# Pandoc Installation and Application

*******************
PANDOC INSTALLATION
*******************
Pandoc version 1.17.2 will be used to produce the PDF version of the manual. 
Since this is now old, it must be installed manually from the source.

Obtain the source at here:
wget https://hackage.haskell.org/package/pandoc-1.17.2/pandoc-1.17.2.tar.gz

Next: 

1. extract the gz package & change directory to pandoc:
   
   $ tar -xzvf pandoc-1.17.2.tar.gz
   $ cd pandoc-1.17.2

2. Use stack to install pandoc from its source. But first, install stack.
   But stack requires curl, and thus, curl needs to be install first:
  
   $ sudo apt update
   $ sudo apt install curl -y

   Next, run curl to fetch stack:

   $ curl -sSL https://get.haskellstack.org | sh

3. Once curl is installed and stack is downloaded, run:

   $ stack setup
   $ stack install 

   This will take quite awhile...so be patient. 
   
*************************
PANDOC INSTALLATION ENDED
*************************

Pandoc can convert markdown to LaTeX source file. From the LaTeX source,
a PDF version can be generated using the LaTeX utility. However, Pandoc
converted markdown files to LaTeX in the most general format which is
impractical for our purpose. Thus, additional LaTeX format directives
and preambles must be manually inserted. 

The following is a procedure we applied to convert the wiki online manual to the PDF manual. 

1. To convert the markdown file to the LaTeX source file:

   pandoc -f markdown infile.txt -so outfile.tex

   The problem with LaTeX is that it will not fetch the content of a link (i.e., images).
   Images must be downloaded by hand. Here is an example code that extracts all the links
   from the target file and output it to a new file that contains only the links that point
   to the images stored on the website: 

   grep -E -o 'https:.*)' ewc-v3_0.md | sed 's/)//' > figures/image-file

   The wget command is used to read the file that contains those links:

   wget $(cat image-file) 

   NOTE: grep is used to extract a matched pattern that ends with );
         sed is used to remove the last ) from the matched pattern.
         wget is used to download the image files from bitbucket.org   

   The links (that is, https://...) must be replaced with proper
   syntax unique to LaTeX; i.e., \includegraphics. The quickest way to accomplish this 
   is to use sed to help render them. 

   sed -i 's/\\includegraphics{https:\/\/bitbucket.org\/repo\/kMrjrgg\/images\//\\includegraphics{/g' outfile.tex

2. To control the layout of the manual in PDF, a page break was added 
   to each section, so that a new section begins on a new page. The quickest 
   and reliable way to accomplish this is to utilize the sed utility. 

   sed -i '/\\Section/i\\\newpage' outfile.tex

3. The manual has too deeply nested items and LaTeX will give an error message.
   To resolve this issue, we need to download the enumitem.sty file and 
   store it in the project folder; then include the following in the preemble of 
   our LaTeX source file: 

%%%%%%% BEGIN fix too deeply nested items 
\usepackage{enumitem}
\setlistdepth{9}

\setlist[itemize,1]{label=$\bullet$}
\setlist[itemize,2]{label=$\bullet$}
\setlist[itemize,3]{label=$\bullet$}
\setlist[itemize,4]{label=$\bullet$}
\setlist[itemize,5]{label=$\bullet$}
\setlist[itemize,6]{label=$\bullet$}
\setlist[itemize,7]{label=$\bullet$}
\setlist[itemize,8]{label=$\bullet$}
\setlist[itemize,9]{label=$\bullet$}

\renewlist{itemize}{itemize}{9}
%%%%%%% END fix too deeply nested items 
   
   A quick way to accomplish this is to insert the content (of a file) into
   the main.tex file:

   NOTE: To resolve this issue in pandoc, we must include a text document that
         contains the following contents: 

\usepackage{enumitem}
\setlistdepth{9}

\setlist[itemize,1]{label=$\bullet$}
\setlist[itemize,2]{label=$\bullet$}
\setlist[itemize,3]{label=$\bullet$}
\setlist[itemize,4]{label=$\bullet$}
\setlist[itemize,5]{label=$\bullet$}
\setlist[itemize,6]{label=$\bullet$}
\setlist[itemize,7]{label=$\bullet$}
\setlist[itemize,8]{label=$\bullet$}
\setlist[itemize,9]{label=$\bullet$}
\renewlist{itemize}{itemize}{9}

\setlist[enumerate,1]{label=$\arabic*.$}
\setlist[enumerate,2]{label=$\alph*.$}
\setlist[enumerate,3]{label=$\roman*.$}
\setlist[enumerate,4]{label=$\arabic*.$}
\setlist[enumerate,5]{label=$\alpha*$}
\setlist[enumerate,6]{label=$\roman*.$}
\setlist[enumerate,7]{label=$\arabic*.$}
\setlist[enumerate,8]{label=$\alph*.$}
\setlist[enumerate,9]{label=$\roman*.$}
\renewlist{enumerate}{enumerate}{9}

   We call that file: deeplists.tex. Then we instruct pandoc to compile the file as follows: 

   $ pandoc -H deeplists.tex -o web-manual.pdf web-mkanual.txt

4. Once page layout is fixed, the LaTeX source file can be processed (or compiled)
   into PDF via

   pdflatex outfile.tex -o outfile.pdf 

5. We may also need to include preemble to render table of contents. Insert this line 
   immediately following \begin{document}; that is;

   \begin{document}
   \tableofcontents

   which we can use sed to do it:

   sed -i '/\\begin{document}/a\\\tableofcontents' outfile.tex

   The title page and credentials preemble may need to be included as well. 

   \maketitle 

6. A separate file containing the copyright note of ESPEC corp, INC, must be created. 
   A shell script command will then be called on to inject the file into the LaTeX
   source file. 

7. The page control version of the manual must also be created and injected into the 
   last section of the LaTeX main source file. 

8. The entire task for converting the markdown to LaTeX source file, with all the 
   necessary preembles, images, page layout controls, etc, will be manipulated
   by a shell script program: make-web24-pdf.sh

# Layout Format: File Processing 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NEW LAYOUT AND FORMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Each part (originally as book) needs to be mearge into a big book/manual, which now
will consist of parts. 

General layout is as follows:
============================

% begin structures
\documentclass[11pt,twoside]{book}
\input{structure}

% begin documents
\begin{document}

% title page and setup preambles

\include{copyright-notice}
\include{preface}

% main body
%
%%%%%%%%%%
% PART ONE
\part{Part One}    

% introduction to part one, what it contains
\include{chap01} % Introduction
\include{chap02} % Initial Setup and First-Time Use
\include{chap03} % User and User Accounts
\include{about}  % About menu, end-users policy and info

%%%%%%%%%%
% PART TWO
\part{Part Two} % Typhoon

% introduction
\include{typhoon}
% include all the chapters related to Typhoon discussion

%%%%%%%%%%%%
% PART THREE
\part{Part Three} % F4T
\include{f4t}
% include all the chapters related to F4T discussion

%%%%%%%%%%%%
% PART 4-6
% include the rest of chambers and controllers

%%%%%%%%%%%%
% PART VII
% include Administration menu (page)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREPARATION AND EXTRACTION OF MARKDOWN FILES TO LATEX
%
% Strategy
%
0. Copy markdown (.md) files from bitbucket.

1. Convert markdown (.md) files to LaTex files (.tex)
  
2. Extract the preamble from one of them (.tex) and output it to structure.tex
   F4T document will be used to extract the LaTeX preamble into the 'structure.tex' file.

3. Extract the preamble from the rest and output to null

4. Extract each .tex file starting with \chapter{Overview} to \chaptert{Start Stop}
   and output to a new file named based on its controller name, 
   e.g., f4t.tex, p300.tex, typhoon.tex, etc.

5. Create a new LaTeX file to include:
   a. input{structure}
   b. add additional LaTeX preamble instructions
   c. create part sections as outlined above

6. compile the file to render and generate the final PDF document. 

# PDF File Processing 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START PROCESS
% -------------
The following script programs perform the complete Markdown to LaTeX 
file process. 

0. rc-starter.sh 
   Driver file to start the entire process autonomously, providing 
   options to convert, xtract, split and process documents.

1. rc-pandoc-2-latex.sh
   First: convert markdown to LaTeX

2. rc-doc-xtraction.sh
   Extract and split TeX documents into specific parts.

3. rc-wget-xtract-img.sh
   Extract images from bitbucket for LaTeX processing.

4. process-pdf.sh 
   Compile and process LaTeX files into PDF. 
