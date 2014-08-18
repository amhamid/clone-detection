clone-detection
===============

Semantic code clone type-3 detection (using the CodeSurfer API) for C and C++ programs.

Abstract
========

Code duplication in a program can make understanding and maintenance difficult. This problem can be reduced by detecting duplicated code, refactoring it into a separate new procedure, and replacing all the occurrences by calls to the new procedure. This study is an evaluation and extension of the paper of Komondoor and Horwitz, titled “Using Slicing to Identify Duplication in Source Code”, which describes the approach and implementation of a tool, based on Program Dependence Graph (PDG) and Program Slicing. The tool can find non-contiguous (clones whose components do not occur as contiguous text in the program), reordered, intertwined, refactorable clones, and display them. PDG and Program Slicing provide an abstraction that ignores arbitrary sequencing choices made by programmer, and instead captures the most important dependencies (data and control flow) among program components.

[Read futher...](Hamid2014.pdf)