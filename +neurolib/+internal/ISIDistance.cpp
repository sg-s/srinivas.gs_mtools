
// ISIDistance.cpp
// measures the distance between two sets of ISIs
// that are entered here as vectors (NaN padded)
// The file allows for four different variants
// of the distance function:
//
// 1. L2 cost, normalized by X
// 2. L1 cost, normalized by X
// 3. L2 cost, normalized by X + Y
// 4. L1 cost, normalzied by X + Y


#include <cmath>
#include <limits>
#include "mex.h"
#include <algorithm>    // std::lower_bound, std::upper_bound, std::sort
#include <vector>       // std::vector



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {


    // define helper functions
    double findClosestSpikeCost(double, double*, int, int);
    int findPositionInSortedArray(double*, int, double);
    int findNumberOfNonNaNElements(double*, int);

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *D;
    D = mxGetPr(plhs[0]);
    D[0] = 0;


    double * AA = mxGetPr(prhs[0]);
    double * BB = mxGetPr(prhs[1]);

    double * Variant_in = mxGetPr(prhs[2]);
    int Variant = (int) Variant_in[0]; 

    const mwSize *ASize, *BSize;
    ASize = mxGetDimensions(prhs[0]);
    BSize = mxGetDimensions(prhs[1]);

    int NA = ASize[0];
    int NB = BSize[0];



    // measure the length of the two vectors
    // since these vectors are NaN padded, we need
    // to figure out how many elements there actually are
    int lA = 0;
    int lB = 0;


    // for (int i = 0; i < NA; i++) {

    //     if (std::isnan(AA[i])) {
    //         lA = i;
    //         break;
    //     }
    // }

    // for (int i = 0; i < NB; i++) {

    //     if (std::isnan(BB[i])) {
    //         lB = i;
    //         break;
    //     }
    // }

    lA = findNumberOfNonNaNElements(AA,NA);
    lB = findNumberOfNonNaNElements(BB,NB);

    

    // mexPrintf("lA=%i\n",lA);
    // mexPrintf("lB=%i\n",lB);

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
        DA += findClosestSpikeCost(AA[i],BB, lB, Variant);
    }


    // now the same deal for B
    for (int i = 0; i < lB; i ++) {
        DB += findClosestSpikeCost(BB[i],AA, lA, Variant);
    }    

    // normalize and return
    D[0] = DA/lA + DB/lB;



}




int findNumberOfNonNaNElements(double* A, int lA) {

    int a = 0;
    int z  = lA - 1; 
    while (a != z) {
        int idx = (a + z) / 2; // Or a fancy way to avoid int overflow
        if (!isnan(A[idx])) {
            a = idx + 1;
        }
        else {
            z = idx;
        }
    }

    return z;

}



// uses a binary search to find the index of the first element
// in an array A that is greater than X
int findPositionInSortedArray(double* A, int lA, double X) {


    int a = 0;
    int z  = lA - 1; 
    while (a != z) {
        int idx = (a + z) / 2; // Or a fancy way to avoid int overflow
        if (A[idx] <= X) {

            a = idx + 1;
        }
        else {
            z = idx;
        }
    }

    return z;

}



double findClosestSpikeCost(double X, double *Y, int lY, int Variant) {
    double val = std::numeric_limits<double>::infinity();
    int idx = 0;


    switch (Variant) {
        case 1:
            {
                for (int i = 0; i < lY; i++) {
                    if ((X - Y[i])*(X - Y[i]) < val) {
                        val = (X - Y[i])*(X - Y[i]);
                    }
                }
                return val/X;
            }
            break;

        case 2:
            {
                for (int i = 0; i < lY; i++) {
                    if (abs(X - Y[i]) < val) {
                        val = abs(X - Y[i]);
                    }
                }
                return val/X;
            }
            break;
        case 3:
            {
                for (int i = 0; i < lY; i++) {
                    if ((X - Y[i])*(X - Y[i]) < val) {
                        val = (X - Y[i])*(X - Y[i]);
                        idx = i;
                    }
                }
                return val/(X + Y[idx]);
            }
            break;
        case 4:
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return abs(X - Y[idx])/(X + Y[idx]);


                } else {
                    // some other element, so need to determine the
                    // closest elemenb b/w idx and idx + 1
                    double cost1 = abs(X - Y[idx]);
                    double cost2 = abs(X - Y[idx-1]);

                    if (cost1 < cost2) {
                        return cost1/(X + Y[idx]);
                    } else {
                        return cost2/(X + Y[idx-1]);
                    }

                }
                
            }
            break;
            
        default: 
            {
                return 0;
                break;
            }
            

    }





}