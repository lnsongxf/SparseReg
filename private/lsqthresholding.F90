#include "fintrf.h"
!
	  SUBROUTINE MEXFUNCTION(NLHS, PLHS, NRHS, PRHS)
!
!     This is the gateway subroutine for LSQSPARSE mex function
!
	  USE SPARSEREG
	  IMPLICIT NONE
!
!     MEXFUNCTION ARGUMENTS
!
	  MWPOINTER :: PLHS(*), PRHS(*)
	  INTEGER :: NLHS, NRHS
!
!     FUNCTION DECLARATIONS
!
	  INTEGER :: MXISCHAR,MXISLOGICAL,MXISNUMERIC
	  INTEGER*4 :: MEXPRINTF
	  MWPOINTER :: MXCREATEDOUBLEMATRIX,MXGETPR,MXGETSTRING
	  MWSIZE :: MXGETM, MXGETN
!
!     SOME LOCAL VARIABLES
!		
      INTEGER :: MAXITERS,STATUS
      MWSIZE :: I,N,N1,N2,PENNAMELEN,PENPARAMS
      REAL(KIND=DBLE_PREC) :: LAMBDA
      CHARACTER(LEN=10) :: PENTYPE
      REAL(KIND=DBLE_PREC), ALLOCATABLE, DIMENSION(:) :: A,B,XMIN,PENPARAM
!
!     CHECK FOR INPUT/OUTPUT ARGUMENT TYPES
!
      IF (NRHS.NE.5) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:nInput','Five input requried.')
      ELSEIF (NLHS>1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:nOutput','At most one output requried.')
      ELSEIF (MXISNUMERIC(PRHS(1))/=1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:Input1','Input 1 must be a numerical array.')
      ELSEIF (MXISNUMERIC(PRHS(2))/=1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:Input2','Input 2 must be a scalar.')
      ELSEIF (MXISNUMERIC(PRHS(3))/=1.OR.MXGETM(PRHS(3))*MXGETN(PRHS(3))>1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:Input3','Input 3 must be a scalar.')
      ELSEIF (MXISCHAR(PRHS(4))/=1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:Input4','Input 4 must be a string.')
      ELSEIF (MXISNUMERIC(PRHS(5))/=1) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:Input5','Input 5 must be a numerical array.')
      END IF
!
!     PREPARE INPUTS FOR COMPUTATIONAL ROUTINE
!
      N1 = MXGETM(PRHS(1))
      N2 = MXGETN(PRHS(1)) 
      N = N1*N2
      ALLOCATE(A(N),B(N),XMIN(N))
      CALL MXCOPYPTRTOREAL8(MXGETPR(PRHS(1)),A,N)
      CALL MXCOPYPTRTOREAL8(MXGETPR(PRHS(2)),B,N)
      CALL MXCOPYPTRTOREAL8(MXGETPR(PRHS(3)),LAMBDA,1)
      PENNAMELEN = MXGETM(PRHS(4))*MXGETN(PRHS(4))
      STATUS = MXGETSTRING(PRHS(4), PENTYPE, PENNAMELEN)
      IF (STATUS/=0) THEN
         CALL MEXERRMSGIDANDTXT('MATLAB:lsqthresholding:readError','Error reading string.')
      END IF
      PENPARAMS = MXGETM(PRHS(5))*MXGETN(PRHS(5))
      ALLOCATE(PENPARAM(PENPARAMS))
      CALL MXCOPYPTRTOREAL8(MXGETPR(PRHS(5)),PENPARAM,PENPARAMS)      
!
!     CALL THE COMPUTATION ROUTINE AND COPY RESULT TO MATLAB ARRAYS
!
      DO I=1,N
         XMIN(I) = LSQ_THRESHOLDING(A(I),B(I),LAMBDA,PENPARAM(1),PENTYPE(1:PENNAMELEN))
      END DO
      PLHS(1) = MXCREATEDOUBLEMATRIX(N1,N2,0)
      CALL MXCOPYREAL8TOPTR(XMIN,MXGETPR(PLHS(1)),N)
!
!     FREE MEMORY
!
      DEALLOCATE (A,B,XMIN,PENPARAM)
      RETURN
	  END SUBROUTINE MEXFUNCTION

