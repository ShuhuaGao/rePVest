# Source code for simple differential evolution (DE)
The DE algorithm is implemented with the  [Julia](https://julialang.org/) language (version 1.5.0 or higher). We write the code in Jupyter notebook for enhanced readability. Some technical details are also explained in the notebook.
## Overview of files in the *src* directory
- models.jl: 
Julia code in a text file that defines the single- and double- diode models as well as functions to compute the SSE and RMSE. These functions are used in the notebook below.
- DE.ipynb
Julia code written with Jupyter notebook that produces all DE results and figures in our paper.
- The *data* subfolder contains the two benchmark datasets.

## How to view the 