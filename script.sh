rm -Rf *.so
export OMP_NUM_THREAD=4
mpicc -fopenmp -funroll-loops -shared -O3 -Wl,-soname,module -o module.so -fPIC module.c
python3 setup.py build_ext --inplace
python3 script_cython.py
