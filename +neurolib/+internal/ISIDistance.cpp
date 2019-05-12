
// ISIDistance.cpp
// measures the distance between two sets of ISIs
// that are entered here as vectors (NaN padded)

#include <cmath>
#include <limits>
#include "mex.h"



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {


    // define helper functions
    double findClosestSpikeCost(double, double*, int);


    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *D;
    D = mxGetPr(plhs[0]);
    D[0] = 0;


    double * AA = mxGetPr(prhs[0]);
    double * BB = mxGetPr(prhs[1]);

    const mwSize *ASize, *BSize;
    ASize = mxGetDimensions(prhs[0]);
    BSize = mxGetDimensions(prhs[1]);

    int NA = ASize[0];
    int NB = BSize[0];


    // create arrays to store the clean ones
    double A[NA];
    double B[NA];

    // measure the length of the two vectors
    int lA = 0;
    int lB = 0;



    for (int i = 0; i < NA; i++) {
        if (isinf(AA[i])) {
            continue;
        } else if (isnan(AA[i])) {
            continue;
        } else if (AA[i] > 0) {
            A[lA] = AA[i];
            lA++;
        }
    }



    for (int i = 0; i < NB; i++) {
        if (isinf(BB[i])) {
            continue;
        } else if (isnan(BB[i])) {
            continue;
        } else if (BB[i] > 0) {
            B[lB] = BB[i];
            lB++;
        }
    }


    // early exits
    if (lA == 0 && lB == 0){
        // no ISIs in either set
        return;
    } else if (lA == 0) {
        // one set has only one spike
        D[0] = 2;
        return;
    } else if (lB == 0) {
        // one set has only one spike
        D[0] = 2;
        return;
    }


    double DA = 0;
    double DB = 0;

    // find closest spike to each spike in A
    for (int i = 0; i < lA; i ++) {
        DA += findClosestSpikeCost(A[i],B, lB);
    }


    // now the same deal for B
    for (int i = 0; i < lB; i ++) {
        DB += findClosestSpikeCost(B[i],A, lA);
    }    

    // normalize and return
    D[0] = DA/lA + DB/lB;



}



double findClosestSpikeCost(double X, double *Y, int lY) {
    double val = std::numeric_limits<double>::infinity();
    int idx = 0;
    for (int i = 0; i < lY; i++) {
        if (abs(X - Y[i]) < val) {
            val = abs(X - Y[i]);
            idx = i;
        }
    }
    return val/(X +Y[idx]);

}