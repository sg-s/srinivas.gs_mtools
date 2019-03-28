
#include "mex.h"

/* Input Arguments */

#define	STIME	prhs[0]
#define	SSTART	prhs[1]
#define SEND	prhs[2]
#define COST	prhs[3]


/* Output Arguments */

#define	D	plhs[0]

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

#define PI 3.14159265
#define MAXCOST 10000
#define EPS 0.000001
#define NR_END 1
#define FREE_ARG char*

void nrerror(char error_text[])
/* Numerical Recipes standard error handler */
{
	fprintf(stderr,"Numerical Recipes run-time error...\n");
	fprintf(stderr,"%s\n",error_text);
	fprintf(stderr,"...now exiting to system...\n");
	exit(1);
}

double *dvector(long nl, long nh)
/* allocate a double vector with subscript range v[nl..nh] */
{
	double *v;

	v=(double *)malloc((size_t) ((nh-nl+1+NR_END)*sizeof(double)));
	if (!v) nrerror("allocation failure in dvector()");
	return v-nl+NR_END;
}

double **dmatrix(long nrl, long nrh, long ncl, long nch)
/* allocate a double matrix with subscript range m[nrl..nrh][ncl..nch] */
{
	long i, nrow=nrh-nrl+1,ncol=nch-ncl+1;
	double **m;

	/* allocate pointers to rows */
	m=(double **) malloc((size_t)((nrow+NR_END)*sizeof(double*)));
	if (!m) nrerror("allocation failure 1 in matrix()");
	m += NR_END;
	m -= nrl;

	/* allocate rows and set pointers to them */
	m[nrl]=(double *) malloc((size_t)((nrow*ncol+NR_END)*sizeof(double)));
	if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
	m[nrl] += NR_END;
	m[nrl] -= ncl;

	for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;

	/* return pointer to array of pointers to rows */
	return m;
}

void free_dvector(double *v, long nl, long nh)
/* free a double vector allocated with dvector() */
{
	free((FREE_ARG) (v+nl-NR_END));
}

void free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch)
/* free a double matrix allocated by dmatrix() */
{
	free((FREE_ARG) (m[nrl]+ncl-NR_END));
	free((FREE_ARG) (m+nrl-NR_END));
}

double dabs(double x)
{
	if (x<0) return -x;
	else return x;
}

static void getdist(
		   double	*d,
		   unsigned int	nspi,
		   double	tli[],
		   unsigned int	nspj,
 		   double	tlj[],
		   double	cost
		   )
{
	double **scr;
	unsigned int i,j;
	     
	if (cost<EPS) {
   		*d=dabs((double)nspi-(double)nspj);
		/*printf("\n%d %d %f %f",nspi,nspj,dabs((double)nspi-(double)nspj),*d);*/
	}
	else if (cost>=MAXCOST)
		*d=nspi+nspj;
	else {
		/*     INITIALIZE MARGINS WITH COST OF ADDING A SPIKE	*/
		scr=dmatrix(0,nspi,0,nspj);
		for (i=0; i<=nspi; i++)
			scr[i][0]=i;
		for (j=0; j<=nspj; j++)
			scr[0][j]=j;
		if (nspi!=0 && nspj!=0) {
			/*     THE HEART OF THE ALGORITHM	*/
			for (i=1; i<=nspi; i++)
				for (j=1; j<=nspj; j++)
					scr[i][j]=MIN(MIN(scr[i-1][j]+1,scr[i][j-1]+1),scr[i-1][j-1]+cost*dabs(tli[i-1]-tlj[j-1]));
		}
		*d=scr[nspi][nspj];
		free_dmatrix(scr,0,nspi,0,nspj);
	}
	return;
}		   

static void getdistl(
		   double *d,
		   unsigned int	nstart,
		   double	stime[],
		   double sstart[],
		   double send[],
		   double	cost
		   )
{
	double *tli, *tlj;
	double dist;
	unsigned int i,j,itli,itlj;
	unsigned int nspi,nspj;
	double junk;

	for (i=0; i<nstart; i++) {
		nspi=(int)(send[i]-sstart[i]+1);
		if (nspi>0) {
			tli=dvector(0,nspi-1);
			for (itli=0; itli<nspi; itli++) {
				tli[itli]=stime[itli+(int)sstart[i]-1];
				/*printf("\n%d %f",itli,tli[itli]);*/
			}
		}
		for (j=i+1; j<nstart; j++) {
			nspj=(int)(send[j]-sstart[j]+1);
			/*printf("\nnspi=%d\tnspj=%d",nspi,nspj);*/
			if (nspi>0 && nspj>0) {
				tlj=dvector(0,nspj-1);
				for (itlj=0; itlj<nspj; itlj++) {
					tlj[itlj]=stime[itlj+(int)sstart[j]-1];
					/*printf("\n%d %f",itlj,tlj[itlj]);*/
				}
				getdist(&dist,nspi,tli,nspj,tlj,cost);
				/*printf("\t%f",dist);*/
				free_dvector(tlj,0,nspj-1);
			}
			if (nspi==0 && nspj>0) dist=nspj;
			else if (nspj==0 && nspi>0) dist=nspi;
			else if (nspj==0 && nspi==0) dist=0;
			/*printf("\n%d %d %d %f",i,j,i*nstart+j,dist);*/
			d[i*nstart+j]=d[j*nstart+i]=dist;
		}
		if (nspi>0) free_dvector(tli,0,nspi-1);
	}
	return;
}

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
    double *stime, cost; 
	double *sstart, *send;
    double *d; 
    unsigned int nspikes,nstart,nend,junk; 
    
    /* Check for proper number of arguments */
    
    if (nrhs != 4) { 
	mexErrMsgTxt("Four input arguments required."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
    
    /* Check the dimensions of STIME.  STIME can be n X 1 or 1 X n. */ 
    
    nspikes = mxGetM(STIME); 
    junk = mxGetN(STIME);
    if (!mxIsDouble(STIME) || (MIN(nspikes,junk) > 1)) { 
	mexErrMsgTxt("SPKDL requires that STIME be a row or column vector."); 
    } 
	nspikes=MAX(nspikes,junk);
	
    nstart = mxGetM(SSTART); 
    junk = mxGetN(SSTART);
	nstart = MAX(nstart,junk);
    nend = mxGetM(SEND); 
    junk = mxGetN(SEND);
	nend= MAX(nend,junk); 
    
    if (nstart != nend) { 
	mexErrMsgTxt("SPKDL requires that SSTART and SEND have the same dimensions."); 
    } 

    cost = mxGetM(COST); 
    junk = mxGetN(COST);
    if (!mxIsDouble(COST) || (MAX(cost,junk) != 1) || (MIN(cost,junk) != 1)) { 
	mexErrMsgTxt("SPKD requires that COST be a scalar."); 
    } 

    /* Create a matrix for the return argument */ 
    D = mxCreateDoubleMatrix(nstart*nstart, 1, mxREAL); 
    
    /* Assign pointers to the various parameters */ 
    d = mxGetPr(D);
    
    stime = mxGetPr(STIME); 
    sstart = mxGetPr(SSTART);
	send = mxGetPr(SEND);
	cost = mxGetScalar(COST);
        
    /* Do the actual computations in a subroutine */
	getdistl(d,nstart,stime,sstart,send,cost);
	
    return;
}
