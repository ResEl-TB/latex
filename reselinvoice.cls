%%% ResEl Invoice class
%
% Copyright (c) 2019-2021 Benjamin Somers, All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%     Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%     Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%     Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%%%---

%%% Prelude
\NeedsTeXFormat{LaTeX2e}

% Define ResEl Invoice class
\ProvidesClass{reselinvoice}[ResEl invoice class]

% Use a 11pt a4paper article base
\LoadClass[a4paper, 11pt]{article}

% Use a sans serif font
\renewcommand*{\familydefault}{\sfdefault}

% Redefine paragraph spacings
\setlength{\textwidth}{136mm}
\setlength{\parindent}{0mm}
\setlength{\leftmargini}{6.5mm}
\setlength{\parskip}{0.7em}

% Requirements
\RequirePackage[absolute]{textpos} % to position the header elements
\RequirePackage[dvipsnames, table]{xcolor} % use gray color for default values and labels
\RequirePackage{graphicx} % for logo
\RequirePackage{calc} % calculate lengths
\RequirePackage{geometry} % redefine margins
\RequirePackage{ifthen}
\RequirePackage{pst-barcode} % for side reference barcode
\RequirePackage{ocr} % for address font
\RequirePackage{eurosym} % for the euro symbol
\RequirePackage{numprint} % to display decimal numbers
\RequirePackage{fp} % for floating point operations
\RequirePackage{etoolbox}
\RequirePackage{tikz} % for invoice formatting
\RequirePackage{tabularx} % for the invoice table
\RequirePackage{multirow}
\RequirePackage{xstring}
\RequirePackage{resel}
\RequirePackage[T1]{fontenc}
\RequirePackage[french]{babel} % default language
\RequirePackage{times} % default font
%%%---

%%% Definition of user fields and default values
% Font color for default values (values not defined in LaTeX file)
\newcommand{\ridefault}[1]{\textcolor{Gray}{#1}}

% Reference top left
\renewcommand\date[1]{\def\ridate{#1}} % date
\date{\ridefault{\today}} % today by default
\newcommand\intref[1]{\def\riintref{#1}} % internal reference
\intref{\ridefault{}} % <empty> by default
\newcommand\email[1]{\def\riemail{#1}} % contact e-mail
\email{\ridefault{}} % <empty> by default

% Recipient right under logo
\newcommand\toname[1]{\def\ritoname{#1}} % recipient name
\toname{\ridefault{Recipient name}}
\newcommand\toaddress[1]{\def\ritoaddress{#1}} % recipient address
\toaddress{\ridefault{Recipient address}}

% Sender left under reference
\newcommand\fromname[1]{\def\rifromname{#1}} % sender name
\fromname{\ridefault{Sender name}}
\newcommand\fromaddress[1]{\def\rifromaddress{#1}} % sender address
\fromaddress{\ridefault{Sender address}}

% Bank info
\newcommand\iban[1]{\def\riiban{#1}} % IBAN
\iban{\ridefault{}} % <empty> by default
\newcommand\bic[1]{\def\ribic{#1}} % BIC
\bic{\ridefault{}} % <empty> by default
\newcommand\branch[1]{\def\ribranch{#1}} % Bank branch
\branch{\ridefault{}} % <empty> by default
%%%---

%%% Header layout
% Page dimensions
\newcommand{\rimarginleft}{37mm} % page margin left
\newcommand{\rimarginbottom}{20mm} % page margin bottom
\geometry{left=\rimarginleft, bottom=\rimarginbottom} % page geometry

% Reference margins
\newcommand{\rimarginleftref}{15mm} % reference margin left
\newcommand{\rimargintopref}{13mm} % reference margin top

% Label margins
\newcommand{\rimargintoplabel}{36mm} % label top margin
\newcommand{\rimarginleftlabel}{20mm} % label left margin

% Logo dimensions
\newcommand{\rimargintoplogo}{10mm} % logo top margin
\newcommand{\rimarginleftlogo}{\rimarginleftref + 11cm} % logo left margin
\newcommand{\riheightlogo}{25mm} % logo height

% Recipient margins
\newcommand{\rimargintoprecip}{41.5mm} % recipient top margin
\newcommand{\rimarginleftrecip}{120mm} % recipient left margin

% Sender margins
\newcommand{\rimargintopsender}{50.8mm} % sender top margin
\newcommand{\rimarginleftsender}{37mm} % sender left margin
\newcommand{\rimargininnersender}{5mm} % sender inner margin
%%%---

%%% Labels
% Reference
\newcommand{\rirefval}[1]{\small{#1}} % values font size
\newcommand{\rireflab}[1]{\textcolor{Gray}{\scriptsize{#1}}} % labels font color and size

% Sender
\newcommand{\risen}[1]{\normalsize{#1}} % font size

% Texts
\newcommand\ridatename{Date} % date
\newcommand\riintrefname{Réf. interne} % internal reference
\newcommand\riemailname{Contact} % contact e-mail
%%%---

\pagenumbering{gobble} % remove page numbering

%%% This is the actual header of the letter
\newcommand{\makeheader}{%
\textblockorigin{0mm}{0mm} % set origin for textblock

%% Fold marks
% on half
\begin{textblock*}{4mm}(4mm,148mm)
\rule{\hsize}{0.1pt}
\end{textblock*}
% on one third
\begin{textblock*}{2mm}(4mm,98.3mm)
\rule{\hsize}{0.1pt}
\end{textblock*}
% on two thirds
\begin{textblock*}{2mm}(4mm,196.7mm)
\rule{\hsize}{0.1pt}
\end{textblock*}

% Header horizontal rule
\begin{textblock*}{187mm}(10mm,40mm)
{\color{gray}\rule{\hsize}{0.25mm}}
\end{textblock*}

% Reference block
\begin{textblock*}{100mm}(\rimarginleftref, \rimargintopref)
\begin{tabular}{r@{ }l}
  \rireflab{\ridatename} & \rirefval{\ridate} \\
  \rireflab{\riintrefname} & \rirefval{\riintref} \\
  \rireflab{\riemailname} & \rirefval{\riemail} \\
\end{tabular}
\end{textblock*}

% Invoice label
\begin{textblock*}{100mm}(\rimarginleftlabel, \rimargintoplabel)
\fontfamily{ugq}\bfseries\slshape\huge Facture
\end{textblock*}

% Barcode
\hbox{\hspace*{-33mm}\smash{\raisebox{35mm}{%
   \psbarcode[rotate=270]{\riintref}{includecheck height=0.1}{code93}%
}}}%

% Logo
\begin{textblock*}{8cm}(\rimarginleftlogo, \rimargintoplogo)
\includegraphics[height=\riheightlogo]{logo.eps}
\end{textblock*}

% Sender block
\begin{textblock*}{70mm}(\rimarginleftsender, \rimargintopsender)
\risen{{\bf\rifromname}\\[\rimargininnersender]\rifromaddress}
\end{textblock*}

% Recipient block
\begin{textblock*}{70mm}(\rimarginleftrecip, \rimargintoprecip)
\begin{minipage}[c][40mm]{\textwidth}
\ocrfamily{\MakeUppercase{\ritoname}\\
\MakeUppercase{\ritoaddress}}

\end{minipage}
\end{textblock*}
\vspace*{60mm}
}

\AtBeginDocument{\makeheader}
%%%---

%%% Invoice table definition
% Define number display options
\npdecimalsign{,}
\nprounddigits{2}
\npthousandsep{~}

% Pretty formatter
\def\addtablerow#1|#2x#3!{%
  \FPeval{\invoicetotal}{clip(\invoicetotal+#2*#3)}%
  \xdef\invoicetotal{\invoicetotal}%
  \ifthenelse{\equal{\trim{#2}}{1}}%
  {#1 & \multicolumn{1}{c}{} & \hfill\numprint{#3}\\}%
  {#1 & #2 & \numprint{#3}\\}%
}

% Main table generation loop
\newcommand{\invoice}[1]{%
\begin{bluetable}
  \renewcommand*\do[1]{\addtablerow##1!}%
    \begin{tabularx}{\textwidth}{p{0.55\textwidth}!{\color{gray!40}\vrule}>{\hfill\ttfamily\bfseries}p{0.09\textwidth}<{$\times$}>{\hfill\ttfamily\bfseries}X<{ \euro}}%
      \hiderowcolors%
      \multicolumn{3}{c}{} \\[-6mm]
      \multicolumn{3}{c}{\textbf{Détails de la facture (TTC)}} \\[0.5mm]
      \showrowcolors%
      \def\invoicetotal{0}%
      \xdef\invoicetotal{\invoicetotal}%
      \docsvlist{#1}
      \arrayrulecolor{gray!40}\hline
      \hiderowcolors
      \multicolumn{3}{c}{} \\[-6mm]
      \multicolumn{1}{l}{\textbf{Montant total}} & \multicolumn{2}{r}{ \textbf{\texttt{\numprint{\invoicetotal} \euro}}} \\[0.5mm]
      \showrowcolors
    \end{tabularx}
\end{bluetable}
\centerline{\tiny Les montants unitaires sont arrondis au centième le plus proche. Leur somme peut différer du montant total.}
}
%%%---

%%% Payment options
% Bank transfer
\newif\ifallowbanktransfer
\allowbanktransfertrue
\newcommand{\bybanktransfer}{%
\StrSubstitute{\riiban}{ }{}[\rirawiban]%
\StrGobbleLeft{\rirawiban}{4}[\rirawibanbankcode]%
\StrGobbleLeft{\rirawiban}{9}[\rirawibanbranchcode]%
\StrGobbleLeft{\rirawiban}{14}[\rirawibanaccountnumber]%
\StrGobbleLeft{\rirawiban}{25}[\rirawibanribkey]%
\begin{bluetable}%
  \begin{tabularx}{0.9\textwidth}{>{\centering}X|>{\small}c|>{\small}c|>{\small}c|>{\small}c|>{\small}c}%
    \multicolumn{6}{c}{} \\[-6mm]
    \multicolumn{6}{c}{\textbf{Par virement bancaire}} \\[0.5mm]
    \arrayrulecolor{gray!40}\hline
IBAN & \multicolumn{5}{c}{\texttt{\riiban}}\\
\hline
BIC & \multicolumn{5}{c}{\texttt{\ribic}} \\
\hline
\multirow{2}{*}{RIB} & \textbf{\scriptsize Code banque} & \textbf{\scriptsize Code agence} & \textbf{\scriptsize N\textsuperscript{o} de compte} & \textbf{\scriptsize Clé RIB} & \textbf{\scriptsize Agence} \\
    & \texttt{\StrLeft{\rirawibanbankcode}{5}} & \texttt{\StrLeft{\rirawibanbranchcode}{5}} & \texttt{\StrLeft{\rirawibanaccountnumber}{11}} & \texttt{\StrLeft{\rirawibanribkey}{2}} & BREST (00243) \\
  \end{tabularx}
\end{bluetable}}

% Check
\newif\ifallowcheck
\allowchecktrue
\newcommand{\bycheck}{%
\begin{bluetable}%
  \begin{tabularx}{0.9\textwidth}{cX}%
  \multicolumn{2}{c}{} \\[-6mm]
  \multicolumn{2}{c}{\textbf{Par chèque}} \\[0.5mm]
  \arrayrulecolor{gray!40}\hline
  À l'ordre suivant~: & \centering\arraybackslash\og{}\rifromname~\fg{}\\
  \end{tabularx}
\end{bluetable}
}

% Display the payment options
\newcommand{\unpaid}{%
\par%
\textbf{Payable}\\[-3mm]
\newlength{\paywidth}
\setlength{\paywidth}{\widthof{\textbf{Payable}}}
{\color{gray!60}\rule{\paywidth}{.4pt}}\\[-.4mm]
\begin{tabularx}{\textwidth}{p{.5\paywidth}!{\hspace{-4.3mm}\color{gray!60}\vrule\hspace{1.5mm}}c}%
&\\
\ifallowbanktransfer&\bybanktransfer\\[3mm]\fi
\ifallowcheck&\bycheck\\[3mm]\fi
\end{tabularx}
}
%%%---