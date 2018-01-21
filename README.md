# Power of Numpy

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


![Pure python3 launch](/python500.png) Pure python

![Pre compiled Cython](/cython500.png) Cython

We can actually see that Numpy definetely explodes other implementations of the matrix product. As I said earlier, I think this is because of severals reasons:

- Obviously Numpy is a couple of years old. It has been developped by scientists for scientists ( see SciPy) and performs basically any type of computation that we would need in a scientific computing application. 

- It has been written to run fast, and has been opimized and revised over the time

- It is partly based on ctypes library, a C wrap interface. And C is fast.

- It is optimized to detect and take into account some parameters on matrices. For example I noticed that it seems that numpy detects when one of the argument is empty, or the zero matrix, and immediately returns 0.

- Many more reasons why Numpy rocks

## Disclaimer

Nevertheless, I should not throw my project out of the window. Indeed I restricted the tests at kind of "small" dimensions (up to 1000x1000, then my laptop melted) and I think the graphs would be more different with big matrices (without taking their emptiness into account in numpy routines). This thought is mainly supported by the fact that I am using a basic implementation of OpenMP, and Numpy seems to work (at least by default) on a single thread (looks like it does, on htop).

![First region of Cython tests](/cython200.png) First region of Cython

Here we can see that the exotic implementation of the matrix product sometimes beats Numpy at some points that I hope are not peaks due to some random excitation of my pentium..

## What to do next ?

Optimize even more the code, at the numpy and the C implementation sides.
Moreover, adding a MPI version could be interesting, and testing on a more serious machine would surely show the advantage of using multithreading.

Now, for algebraic operations at that scale, Python seems to perform well and its ability to be easy to code and easy to read makes it well suited for small applications.

Note: I realised that I didn't that I don't use CBLAS (C implementation of BLAS Fortran library) because I found out that Numpy also uses some routines from ATLAS, an implementation of BLAS/LAPACK.



