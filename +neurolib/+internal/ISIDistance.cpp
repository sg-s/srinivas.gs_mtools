
// ISIDistance.cpp
// measures the distance between two sets of ISIs
// that are entered here as sorted vectors (NaN padded)
// The file allows for different variants
// of the distance function:
//
// 1. L2 cost, normalized by X
// 2. L1 cost, normalized by X
// 3. L2 cost, normalized by X + Y
// 4. L1 cost, normalized by X + Y
// 5. L1 cost, normalized by X + Y, but only the biggest value


#include <cmath>
#include <limits>
#include "mex.h"
#include <algorithm>    // std::lower_bound, std::upper_bound, std::sort
#include <vector>       // std::vector



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {


    // define helper functions
    double findClosestSpikeCost(double, double*, int, int);
    int findPositionInSortedArray(double*, int, double);
    int findIndexOfFirstNaNValue(double*, int);

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


    lA = findIndexOfFirstNaNValue(AA,NA);
    lB = findIndexOfFirstNaNValue(BB,NB);


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


    // special case for Variant == 5

    if (Variant == 5) {
        double this_cost = 0;
        for (int i = 0; i < lA; i ++) {
            this_cost = findClosestSpikeCost(AA[i],BB, lB, 4);
            mexPrintf("this_cost = %f\n",this_cost);
            if (this_cost > DA) {
                DA = this_cost;
            }
        }


        // now the same deal for B
        for (int i = 0; i < lB; i ++) {
            this_cost = findClosestSpikeCost(BB[i],AA, lA, 4);
            mexPrintf("this_cost = %f\n",this_cost);
            if (this_cost > DB) {
                DB = this_cost;
            }
        }  

        D[0] = DA + DB;
        return;
    }

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




int findIndexOfFirstNaNValue(double* A, int lA) {

    for (int idx = 0; idx < lA; idx++ ) {
        if (isnan(A[idx])) {
            return idx;
        }

    }

    return lA;




}



// uses a binary search to find the index of the first element
// in an array A that is greater than X
int findPositionInSortedArray(double* A, int lA, double X) {


    int a = 0;
    int z  = lA - 1; // the last non-NaN value position in A is lA-1
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
            // L2 cost, normalized by X 
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return (X - Y[idx])*(X - Y[idx])/X;


                } else {
                    // some other element, so need to determine the
                    // closest element b/w idx and idx - 1
                    double cost1 = (X - Y[idx])*(X - Y[idx]);
                    double cost2 = (X - Y[idx-1])*(X - Y[idx-1]);

                    if (cost1 < cost2) {
                        return cost1/X;
                    } else {
                        return cost2/X;
                    }

                }
            }
            break;

        case 2:
            // L1 cost, normalized by X 
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return abs(X - Y[idx])/(X);


                } else {
                    // some other element, so need to determine the
                    // closest elemenb b/w idx and idx - 1
                    double cost1 = abs(X - Y[idx]);
                    double cost2 = abs(X - Y[idx-1]);

                    if (cost1 < cost2) {
                        return cost1/X;
                    } else {
                        return cost2/X;
                    }

                }
            }
            break;
        case 3:
            // L2 cost, normalized by X and Y
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return (X - Y[idx])*(X - Y[idx])/(X + Y[idx]);


                } else {
                    // some other element, so need to determine the
                    // closest elemenb b/w idx and idx - 1
                    double cost1 = (X - Y[idx])*(X - Y[idx]);
                    double cost2 = (X - Y[idx-1])*(X - Y[idx-1]);

                    if (cost1 < cost2) {
                        return cost1/(X + Y[idx]);
                    } else {
                        return cost2/(X + Y[idx-1]);
                    }

                }
            }
            break;
        case 4:
            // L1 cost, normalzied by X + Y
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return abs(X - Y[idx])/(X + Y[idx]);


                } else {
                    // some other element, so need to determine the
                    // closest element b/w idx and idx - 1
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

        case 5:
            // L1 cost, not normalized by anything
            {
                int idx = findPositionInSortedArray(Y, lY, X);

                if (idx == 0) {
                    // first element
                    return abs(X - Y[idx]);


                } else {
                    // some other element, so need to determine the
                    // closest element b/w idx and idx - 1
                    double cost1 = abs(X - Y[idx]);
                    double cost2 = abs(X - Y[idx-1]);

                    if (cost1 < cost2) {
                        return cost1;
                    } else {
                        return cost2;
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