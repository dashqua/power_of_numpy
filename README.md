#Power of Numpy

This show that indeed, the numpy library is well coded :-)

## Getting Started

Make sure to update your python runtime to the latest, same thing for C libraries. And make sur you run the program on a graphical environment.
### Installing

No installation needed, no dark make to run, it is ready to launch since all requirements all fulfilled ( pigar call don't work on my computer, so look at the source code of each .py and do

```
sudo apt update ; apt upgrade -y
```

## What to see

Not too much to see. I proposed an implementation of a regular matrix matrix product (DGEMM in BLAS).
The main interests of the code:

- implementation of Cython, a C based accelerated compiling thing to run faster .py scripts. Need pre compilation. (I know there is another simpler way to use cython with library import but I tend to trust more compiled programs )

- methods of time/memory optimization. Based on that webpage : https://www.ibm.com/developerworks/community/blogs/jfp/entry/A_Comparison_Of_C_Julia_Python_Numba_Cython_Scipy_and_BLAS_on_LU_Factorization?lang=en

I did useful things like using actual numpy arrays and not regular py lists, avoiding appending and pre build whole random matrices, limit the number of variables... Visit the webpage for a more echaustive list of advices.

- C/python interface. Using ctypes library, here is a working example of the use of C wrappers in Python. C equivalent structures are instanced for any python object, why not using it ?! The power of Numpy get its roots from that.

- Basic Parallelization of C methods. I consider OpenMP to be the best tool to dive into the parallel computing. Simple to use, it still produces a reasonnable speedup as we can see on the graphs. An implementation of MPI has been considered but the author has some trouble with non blocking message parsing paradigm... Moreover, there has to be a mpi library for python but it may not suit our need since python remains a scripting language, and because such library would be based on a ctypes casting like in this code for sure.


![(/python500.png)


