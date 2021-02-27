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

% Requirements
\RequirePackage{calc}        % calculate lengths
\RequirePackage{eurosym}     % euro symbol
\RequirePackage{fp}          % floating point operations
\RequirePackage{multirow}    % multi-row cells
\RequirePackage{numprint}    % decimal numbers printer
\RequirePackage{tabularx}    % special tables
\RequirePackage{times}       % default font
\RequirePackage{xstring}     % string operations
\RequirePackage{resellayout} % layout
%%%---


%%% Texts
\setlength{\parindent}{0mm} % remove parindents

% Raw strings
\def\@ri@invoice            {Facture}                        % invoice label
\def\@ri@tobepaid           {À payer}                        % to-be-paid label
\def\@ri@totallabel         {Montant total}                  % total amount label
\def\@ri@bybanktransferlabel{Par virement bancaire}          % bank transfer label
\def\@ri@bychecklabel       {Par chèque}                     % check label
\def\@ri@detailsheader      {Détails de la facture (TTC)}    % invoice table header
\def\@ri@disclaimer         {Les montants unitaires sont arrondis au centième le plus proche. Leur somme peut différer du montant total.}
                                                             % disclaimer invoice below
\def\@ri@checktolabel       {À l'ordre suivant~}             % check recipient
\def\@ri@bankcode           {Code banque}                    % bank code label
\def\@ri@branchcode         {Code agence}                    % branch code label
\def\@ri@accountnumber      {N\textsuperscript{o} de compte} % account number label
\def\@ri@ribkey             {Clé RIB}                        % rib key label
\def\@ri@branch             {Agence}                         % branch label
%%%---


%%% Fields and properties
% Header fields
\addproperty[\today]{date}{Date}\headerproperties
\addrawproperty[IN-YYMMDD-USERID]{intref}{Réf. interne}\headerproperties
\addproperty{email}{Contact}\headerproperties

% Bank fields
\addrawproperty[XX00 0000 0000 0000 0000 0000 000]{iban}{IBAN}\banktransferproperties
\addproperty   [XXXXXXXXXXX]{bic}           {BIC}             \banktransferproperties
\addrawproperty[XXXXX]      {@bankcode}     \@ri@bankcode     \ribproperties
\addrawproperty[XXXXX]      {@branchcode}   \@ri@branchcode   \ribproperties
\addrawproperty[XXXXXXXXXXX]{@accountnumber}\@ri@accountnumber\ribproperties
\addrawproperty[XX]         {@ribkey}       \@ri@ribkey       \ribproperties
\addproperty   [Agence]     {branch}        \@ri@branch       \ribproperties
%%%---


%%% Layout
\def\@rlay@letter@spacing{6.5cm}
\resellayout[\@ri@invoice]
\isaletter
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
  \begin{bluetable}%
    \renewcommand*\do[1]{\addtablerow##1!}%
    \begin{tabularx}{\textwidth}{p{0.55\textwidth}!{\color{gray!40}\vrule}>{\hfill\ttfamily\bfseries}p{0.09\textwidth}<{$\times$}  >{\hfill\ttfamily\bfseries}X<{ \euro}}%
      \hiderowcolors%
      \multicolumn{3}{c}{} \\[-6mm]
      \multicolumn{3}{c}{\textbf{\@ri@detailsheader}} \\[0.5mm]
      \showrowcolors%
      \def\invoicetotal{0}%
      \xdef\invoicetotal{\invoicetotal}%
      \docsvlist{#1}
      \arrayrulecolor{gray!40}\hline
      \hiderowcolors
      \multicolumn{3}{c}{} \\[-6mm]
      \multicolumn{1}{l}{\textbf{\@ri@totallabel}} & \multicolumn{2}{r}{ \textbf{\texttt{\numprint{\invoicetotal} \euro}}} \\[0.5mm]
      \showrowcolors
    \end{tabularx}%
  \end{bluetable}
  \centerline{\tiny\@ri@disclaimer}
}
%%%---

%%% Payment options
% Bank transfer
\newif\ifallowbanktransfer
\allowbanktransfertrue
\def\bybanktransfer{%
  \StrSubstitute{\@val@iban}{ }{}[\@rawiban]%
  \StrGobbleLeft{\@rawiban}{4}[\@rawiban@bankcode]%
  \StrGobbleLeft{\@rawiban}{9}[\@rawiban@branchcode]%
  \StrGobbleLeft{\@rawiban}{14}[\@rawiban@accountnumber]%
  \StrGobbleLeft{\@rawiban}{25}[\@rawiban@ribkey]%
  \StrLeft{\@rawiban@bankcode}{5}[\@val@@bankcode]%
  \StrLeft{\@rawiban@branchcode}{5}[\@val@@branchcode]%
  \StrLeft{\@rawiban@accountnumber}{11}[\@val@@accountnumber]%
  \StrLeft{\@rawiban@ribkey}{2}[\@val@@ribkey]%
  \def\@ribline{}%
  \foreach\x in\ribproperties{\protected@xappto\@ribline{&\textbf{\scriptsize\csname @prop@\x\endcsname}}}%
  \appto\@ribline\\%
  \foreach\x [count=\i] in\ribproperties{\protected@xappto\@ribline{&\ifnum\i=5\sf\else\tt\fi\csname @val@\x\endcsname}}%
  \begin{bluetable}%
    \begin{tabularx}{0.9\textwidth}{>{\centering}X|>{\small}c|>{\small}c|>{\small}c|>{\small}c|>{\small}c}%
      \multicolumn{6}{c}{} \\[-6mm]
      \multicolumn{6}{c}{\textbf{\@ri@bybanktransferlabel}} \\[0.5mm]
      \arrayrulecolor{gray!40}\hline
      \@prop@iban & \multicolumn{5}{c}{\texttt{\@val@iban}} \\\hline
      \@prop@bic & \multicolumn{5}{c}{\texttt{\@val@bic}} \\\hline
      \multirow{2}{*}{RIB} \@ribline
    \end{tabularx}%
  \end{bluetable}%
}

% Check
\newif\ifallowcheck
\allowchecktrue
\newcommand{\bycheck}{%
  \begin{bluetable}%
    \begin{tabularx}{0.9\textwidth}{cX}%
    \multicolumn{2}{c}{} \\[-6mm]
    \multicolumn{2}{c}{\textbf{\@ri@bychecklabel}} \\[0.5mm]
    \arrayrulecolor{gray!40}\hline
    \@ri@checktolabel: & \centering\arraybackslash\og{}\@val@sender~\fg{}\\
    \end{tabularx}%
  \end{bluetable}%
}

% Display the payment options
\newcommand{\unpaid}{%
  \par%
  \textbf{\@ri@tobepaid}\\[-3mm]
  \newlength{\paywidth}
  \setlength{\paywidth}{\widthof{\textbf{\@ri@tobepaid}}}
  {\color{gray!60}\rule{\paywidth}{.4pt}}\\[-.4mm]
  \begin{tabularx}{\textwidth}{p{.5\paywidth}!{\hspace{-4.3mm}\color{gray!60}\vrule\hspace{1.5mm}}c}%
    &\\
    \ifallowbanktransfer&\bybanktransfer\\[3mm]\fi
    \ifallowcheck&\bycheck\\[3mm]\fi
  \end{tabularx}
}
%%%---
