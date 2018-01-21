#include <stdio.h>
#include <omp.h>

#define MCW MPI_COMM_WORLD

void test_printf( char * phrase){
  printf("%s\n",phrase);
}
void print_tab( double *tab, int n){
  for (int i=0;i<n;i++){
    printf("%f\t",tab[i]);
  }
  putchar('\n');
  return;
}


void print_mat( double **tab, int m, int n){
  for (int i=0;i<m;i++){
    for (int j=0;j<n;j++){
      printf("%f\t",tab[i][j]);
    }
    putchar('\n');
  }
}

//matrix dimensions : mo x on = mn
void regular_mat_prod(double **A, double **B, double **C, int m, int o, int n){
  //print_mat(A,m,o);
  //print_mat(B,o,n);
  for (int i=0;i<m;i++){
    for (int j=0; j<n; j++){
      C[i][j] = 0.0;
      for (int k=0; k<o; k++){
	C[i][j] += A[i][k] * B[k][j];
      }
    }
  }
}



void omp_mat_prod(double **A, double **B, double **C, int m, int o, int n, char *runtime){
#pragma omp parallel for schedule(runtime) collapse(2)
  for (int i=0;i<m;i++){
    for (int j=0; j<n; j++){
      C[i][j] = 0.0;
      #pragma loop(no_vector)
      for (int k=0; k<o; k++){
	C[i][j] += A[i][k] * B[k][j];
      }
    }
  }
}

