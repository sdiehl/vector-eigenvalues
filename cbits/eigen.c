// clang -o eigen eigs.c -llapack -lblas -lgfortran -lm
#include <stdlib.h>
#include <stdio.h>

extern void dgeev_( char *jobvl, char *jobvr, int *n, double *a,
                    int *lda, double *wr, double *wi, double *vl, int *ldvl,
                    double *vr, int *ldvr, double *work, int *lwork, int *info );

double POS_INF = 1.0 / 0.0;

/* Compute eignevalues for linear matrix */
int eigenvalues(int n, double *a, double *out)
{
    int j;
    int info, lwork;
    double wkopt;
    double *work;
    double wr[n], wi[n], vl[n * n], vr[n * n];

    lwork = -1;
    dgeev_( "Vectors", "Vectors", &n, a, &n, wr, wi, vl, &n, vr, &n, &wkopt, &lwork, &info );
    lwork = (int)wkopt;
    work = (double *)malloc( lwork * sizeof(double) );
    dgeev_( "Vectors", "Vectors", &n, a, &n, wr, wi, vl, &n, vr, &n, work, &lwork, &info );
    free( (void *)work );

    for ( j = 0; j < n; j++ ) {
        if ( wi[j] == (double)0.0 ) {
            out[j] = wr[j];
        } else {
            // Complex value
            out[j] = POS_INF;
        }
    }

    if ( info > 0 ) {
        return 1;
    } else {
        return 0;
    }
}
