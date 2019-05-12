
// ISIDistance.cpp
// measures the distance between rows of a ISI matrix,
// assuming that each row corresponds to a different observation
// data is assumed to be NaN padded
// and all ISIs should be +ve 
// this version uses threads to run on as many cores as possible


#include <cmath>
#include <limits>
#include <thread>
#include <vector>
#include <chrono> 
#include "mex.h"


// define some global variables
int AX = 0;
int AY = 0;
double * A;
double * NA_out;
double * D;
int * NA;
int n_threads;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {


    // define sub functions
    double findClosestSpikeCost(double, int);
    double measureISICost(int, int);
    void countISIsInRows();
    bool isvalid(double);
    void parallelWorker(int);
    void computeRowCost(int);



    // figure out the size of the input
    A = mxGetPr(prhs[0]);
    const mwSize *ASize;
    ASize = mxGetDimensions(prhs[0]);
    AX = ASize[0];
    AY = ASize[1];


    // create output. this will be a NxN matrix
    plhs[0] = mxCreateDoubleMatrix(AY, AY, mxREAL);
    D = mxGetPr(plhs[0]);


    // figure out how many threads we have
    n_threads = std::thread::hardware_concurrency();
    // mexPrintf("n_threads = %i\n",n_threads);


    // count the # of ISIs in every row
    // since data is NaN padded, we need to do this
    NA = new int[AY];
    countISIsInRows();




    // compute costs in parallel across threads
    std::vector<std::thread> all_threads;
    for (int i = 0; i < n_threads; i++) {
        // all_threads.push_back(std::thread (computeRowCost, i));
        all_threads.push_back(std::thread (parallelWorker, i));
    }
    // wait for threads to finish
    for (int i = 0; i < n_threads; i++) {
        all_threads[i].join();
    }



    // compute costs on a single thread
    // for (int i = 0; i < AY; i++) {computeRowCost(i);}




}

bool isvalid(double X) {
    if (isnan(X)) {return false;}
    if (isinf(X)) {return false;}
    if (X <= 0) {return false;}
    return true;
}


void countISIsInRows() {
    // go over every row
    for (int j = 0; j < AY; j++ ) {
        NA[j] = 0;
        // go over every spike
        for (int i = 0; i < AX; i++) {
            if (isvalid(A[i + AX*j])) {
                NA[j]++;
            }
        }
    }
}


// finds the closest spike cost b/w one value (X)
// which is an ISI, and the row in the ISI matrix specified by b
double findClosestSpikeCost(double X, int b) {
    double val = std::numeric_limits<double>::infinity();
    int idx = 0;

    for (int i = 0; i < AX; i++) {
        double other_isi = A[AX*b + i];

        if (!isvalid(other_isi)) {continue;}

        if (abs(X - other_isi) < val) {
            val = abs(X - other_isi);
            idx = i;
        }
    }
    return val/(X +A[AX*b + idx]);

}

// this function measure the distance b/w two rows of
// the ISI matrix 
// it pulls the actual ISIs from the matrix
// which is a global variable
double measureISICost(int a, int b) {

    double this_cost = 0;
    double DA = 0;
    double DB = 0;
    double this_spike;

    // early exits
    if (NA[a] == 0 && NA[b] == 0){
        // no ISIs in either set
        return 2.0;
    } else if (NA[a] == 0) {
        // one set has only one spike
        return 2.0;
    } else if (NA[b] == 0) {
        // one set has only one spike
        return 2.0;

    }



    // find closest spike to each spike in row A
    for (int i = 0; i < AX; i ++) {
        this_spike = A[AX*a + i];
        if (!isvalid(this_spike)) {continue;}
        DA += findClosestSpikeCost(this_spike, b);
    }

    this_cost += DA/NA[a];


    // find closest spike to each spike in row B
    for (int i = 0; i < AX; i ++) {
        this_spike = A[AX*b + i];
        if (!isvalid(this_spike)) {continue;}
        DB += findClosestSpikeCost(this_spike, a);
    }

    this_cost += DB/NA[b];


    return this_cost;
}



void computeRowCost(int i) {
    // we're working on row i. This means that we
    // need to find the distances between row i
    // and all other rows 


    for (int j = i+1; j < AY; j++) {
        D[i + AY*j] = measureISICost(i,j);
    }

}

// this is started by every thread. 
// this allows us to partition the tasks equally between
// cores 
void parallelWorker(int i) {

    for (int j = 0; j < AY; j++){
        if (j % (n_threads) == i) {
            // mexPrintf("Will do: %i\n",j);
            computeRowCost(j);
        }
    }

}
