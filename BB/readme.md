# Source code related to interval B&B
The [`IbexOpt`](http://www.ibex-lib.org/doc/optim.html#optim) solver was used. This solver accepts an optimization problem written its own [*Minibex*](http://www.ibex-lib.org/doc/minibex.html) language. We provide the *Minibex* files for the four case studies in this folder. Additionally, since `IbexOpt` will take a very long time  (quite a few hours) to get each result, we also provide the results we have obtained here that correspond to Table 2 and Table 3 in the paper.

## Source files and results of *ibexopt*
### SDM
- RTC France
	+ Source: RTCFrance-SDM.txt
	+ Result: RTCFrance-SDM.result 
- Photowatt-PWP201
	+ Source: Photowatt-SDM.txt
	+ Result: Photowatt-SDM.result
### DDM
- RTC France
	+ Source: RTCFrance-DDM.txt
	+ Result: RTCFrance-DDM.result
- Photowatt-PWP201
	+ Source: Photowatt-DDM.txt
	+ Result: Photowatt-DDM.result

## Other files
- ./**visualization interval BB.ipynb**: used to generate the estimated curves using the parameters optimized by BB. The curves are placed in the [./img](./img) subfolder as follows.
  - ./img/**BB_PW.pdf**: curve for PW
  - ./img/**BB_RT.pdf**: curve for RT
  
## Note
+ The direct objective for optimization is the sum of squared error (SSE), while the RMSE is computed manually after optimization finishes.
+ To set up similar scales among these model parameters, the unit for `Rp` in optimization is `100 Ω`.
## How to run
1. First install `ibex` following the official [instructions](http://www.ibex-lib.org/doc/install.html)
2. In the terminal, run the `ibexopt` command with proper options. For example, to optimize the "SDM + RTC France" case with custom relative precision (`-r`) and absolute precision (`-a`) as well as given timeout (`-t`),  we can type 
```
	ibexopt -t15000 RTCFrance-SDM.txt -r1e-9 -a1e-13
```

3. To run ./**visualization interval BB.ipynb**, please follow the instructions in the [DE](../DE) folder. 
   
## Additional notes
+ The extension of the *Minibex* file is arbitrary. The *Minibex* file as well as the *result* file are just raw text files and can be opened with any text editor.
+ `ibexopt` can be warm started with the `-i` option, as we have done in our study. That is, we can first execute `ibexopt` for a short time, say, one hour, and see whether the result is satisfactory. If not, then we can continue right from where it stopped by specifying the COV file generated in the previous run as the input COV file into the current run.
