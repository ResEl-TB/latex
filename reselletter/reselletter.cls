%%% ResEl Letter class
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
\ProvidesClass{reselletter}[ResEl letter class]

% Use a 11pt a4paper article base
\LoadClass[a4paper, 11pt]{article}

% Requirements
\RequirePackage{tabularx}    % bottom signatures in a tab
\RequirePackage{resellayout} % layout
%%%---


%%% Raw strings
\def\@rl@loc@before{À }
\def\@rl@date@before {le }
%%%---


%%% Fields and properties
% Header fields
\addproperty[\today]{date}{Date}\headerproperties
\addrawproperty[IN-YYMMDD-USERID]{intref}{Réf. interne}\headerproperties
\addproperty{contact}{Contact}\headerproperties
\addproperty{email}{E-mail}\headerproperties

% Letter fields
\addproperty{subject}{Objet}\headerproperties
\addunboundfield[City]{loc}

% Signature fields
\addunboundfield{signature}
\addunboundfield{signatory}
\addunboundfield{secsignature}
\addunboundfield{secsignatory}
%%%---


%%% Layout
\def\@rlay@letter@spacing{6cm}
\resellayout
\isaletter

% Spacing between closing and signature
\def\@rl@sigspace{3\parskip}
\def\collapsesigspace{\def\@rl@sigspace{0mm}} % collapse the spacing

\bput {locndate} at {14cm} {84.3mm} % location and date block position
%%%---


%%% Location and date
\AtBeginDocument{%
  \begin{textblock*}{70mm}(\@rlay@locndate@left,\@rlay@locndate@top)
    \noindent\@rl@loc@before\@val@loc,\\\@rl@date@before\@val@date
  \end{textblock*}
}
%%%---


%%% Opening of letter
\newcommand{\opening}[1]{\noindent #1\par\vspace{2\parskip}}
%%%---


%%% closing op letter
\newcommand{\closing}[1]{%
  \ifx\@val@secsignatory\empty%
    \let\@val@secsignatory\@val@signatory%
    \def\@val@signatory{}%
    \let\@val@secsignature\@val@signature%
    \def\@val@signature{}%
  \fi
  \vspace{2\parskip}
  #1\par\vspace{\@rl@sigspace}
  \noindent\begin{tabularx}{\textwidth}{X X}
    \def\tabcolsep{0mm}
    \unless\ifx\@val@signature\empty\includegraphics[width=0.5\textwidth,height=25mm,keepaspectratio]{\@val@signature}\fi
    &
    \unless\ifx\@val@secsignature\empty\includegraphics[width=0.5\textwidth,height=25mm,keepaspectratio]{\@val@secsignature}\fi\\
    \centering\@val@signatory & \centering\@val@secsignatory\\
  \end{tabularx}
}
%%%---
