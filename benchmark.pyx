import numpy as np
import ctypes as ct
import matplotlib.pyplot as plt
from numba import jit

from time import time
module = ct.CDLL("./module.so")
module.test_printf('Multiply matrices'.encode('utf-8'))

DOUBLE = ct.c_double
DOUBLE_P = ct.POINTER(DOUBLE)
DOUBLE_P_P = ct.POINTER(DOUBLE_P)

F64 = np.float64
F32 = np.float32
FD  = np.double
FORMAT = F64

def DoubleArray(m):
    #Ap = DoubleArray(4)(1,2,3,4)
    #module.print_tab(Ap,4)
    return DOUBLE * m

#def DoubleArray_P(m,n):
#    return (m * DOUBLE_P) ( * n * DOUBLE_P)

def DOUBLE_MATRIX(x):
    #    return ( DOUBLE_P * m)(*[row.ctypes.data_as( DOUBLE_P ) for row in x.astype(dtype=FORMAT)] )
    Zp = (DOUBLE_P*m)()
    for i in range(m):
        Zp[i]= (DOUBLE*n)()
        for j in range(n):
            Zp[i][j] = x[i,j]
    return Zp


itermin=2
itermax=500


m = 2
o = 2
n = 2

A = np.array([ [2,0] , [0,2] ]).astype(dtype=FORMAT)
B = np.array([ [1,2] , [3,4] ]).astype(dtype=FORMAT)
C = np.array([ [0,0] , [0,0] ]).astype(dtype=FORMAT)
D = np.array([ [0,0] , [0,0] ]).astype(dtype=FORMAT)

start = time()
C = np.matmul(A,B)
end = time()
print('Numpy product :', end-start)
print(C)

print('')


Ap = DOUBLE_MATRIX( A )
Bp = DOUBLE_MATRIX( B )
Dp = DOUBLE_MATRIX( D )

start = time()
module.regular_mat_prod(Ap,Bp,Dp,m,o,n)
end = time()
print('Ctypes product:', end-start)
module.print_mat(Dp,m,n)


nptime = np.empty([itermax-itermin])
ctime = np.empty([itermax-itermin])
omp_static_time = np.empty([itermax-itermin])
omp_dynamic_time = np.empty([itermax-itermin])

print('###########################################')
#PREPS
A = np.array( np.random.rand(itermax,itermax) ).astype(dtype=FORMAT)
B = np.array( np.random.rand(itermax,itermax) ).astype(dtype=FORMAT)
C = np.array( np.random.rand(itermax,itermax) ).astype(dtype=FORMAT)


for dim in range(itermin,itermax):
    #print(100*(dim-itermin)/(itermax-itermin)," ",sep="")
    m = dim
    o = dim
    n = dim
    #A[:m,:o]
    #B[:o,:n]
    #C[:m,:n]
    #
    start = time()
    C[:m,:n] = A[:m,:o] @ B[:o,:n] 
    end = time()
    nptime[dim-itermin] =  end-start
    #
    #
    Ap = DOUBLE_MATRIX( A[:m,:o] )
    Bp = DOUBLE_MATRIX( B[:o,:n] )
    Cp = DOUBLE_MATRIX( C[:m,:n] )
    start = time()
    module.regular_mat_prod(Ap,Bp,Cp,m,o,n)
    end = time()
    ctime[dim-itermin] =  end-start
    #
    #
    start = time()
    module.omp_mat_prod(Ap,Bp,Cp,m,o,n,"static")
    end = time()
    omp_static_time[dim-itermin] =  end-start
    #
    #
    start = time()
    module.omp_mat_prod(Ap,Bp,Cp,m,o,n,"dynamic")
    end = time()
    omp_dynamic_time[dim-itermin] = end-start
print('###########################################')

plt.plot(nptime, label="Numpy ")
plt.plot(ctime , label="C Wrap ")
plt.plot(omp_static_time,label="C Wrap w OMP Static")
plt.plot(omp_dynamic_time,label="C Wrap w OMP Dynamic")
plt.legend(loc=2)

#FOR GRID5000 comment
plt.show()
plt.savefig('plt.png')

