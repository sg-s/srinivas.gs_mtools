
// uniformSample2D
// This C++ function is meant to compiled using mex and run from
// within MATLAB
//
// PURPOSE
//
// This function accepts two vectors, and uniformly samples them
// in both dimensions 
//
// EXAMPLE
//
// X = randn(1e3,1);
// Y = randn(1e3,1);
// [x,y] = uniformSample2D(X,Y,100);

#include <cmath>
#include "mex.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {


 
    double * input_X = mxGetPr(prhs[0]);
    double * input_Y = mxGetPr(prhs[1]);

    const mwSize *XSize, *YSize;
    YSize = mxGetDimensions(prhs[1]);
    XSize = mxGetDimensions(prhs[0]);

    int NX = XSize[0];
    int NY = YSize[0];


    if (NX != NY){
        mexErrMsgTxt("Both vectors have to be the same length\n");
    }
    

    double * input_N = mxGetPr(prhs[2]);
    int N = (int) input_N[0];

    plhs[0] = mxCreateDoubleMatrix(2*N, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(2*N, 1, mxREAL);

    double *output_X;
    double *output_Y;
    output_X = mxGetPr(plhs[0]);
    output_Y = mxGetPr(plhs[1]);

    // initialize them with NaN
    for (int i = 0; i < 2*N; i++){
        output_X[i] = std::numeric_limits<double>::quiet_NaN();
        output_Y[i] = std::numeric_limits<double>::quiet_NaN();
    }

    // find min and max of vectors
    double x_max = 0;
    double x_min = 0;

    for (int i = 0; i < NX; i ++) {
        if (input_X[i] > x_max) {
            x_max = input_X[i];
        }

        if (input_X[i] < x_min) {
            x_min = input_X[i];
        }
    }

    double y_max = 0;
    double y_min = 0;

    for (int i = 0; i < NY; i ++) {
        if (input_Y[i] > y_max) {
            y_max = input_Y[i];
        }

        if (input_Y[i] < y_min) {
            y_min = input_Y[i];
        }
    }


   


    // uniform sample across X
    double x_step = (x_max - x_min)/N;
    for (int i = 1; i < N; i++ ) {
        for (int j = 0; j < NX; j++) {
            if (input_X[j] > x_min + x_step*(i-1) & input_X[j] < x_min + x_step*i) {
                output_X[i-1] = input_X[j];
                output_Y[i-1] = input_Y[j];
                break;
            } 
        }
    }

    // uniform sample across Y
    double y_step = (y_max - y_min)/N;
    for (int i = 1; i < N; i++ ) {
        for (int j = 0; j < NY; j++) {
            if (input_Y[j] > y_min + y_step*(i-1) & input_Y[j] < y_min + y_step*i) {
                output_X[i-2+N] = input_X[j];
                output_Y[i-2+N] = input_Y[j];
                break; 
            } 
        }
    }


}



