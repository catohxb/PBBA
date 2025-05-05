PBBA matlab code - X. Huang
These are Matlab scripts used to set up and execute parallel beam-based alignment (PBBA) measurements for a storage ring. Example of using it for NSLS-II is included. 
(1) For the set up, edit and run 'setup_PBBA.m'. In this script, for a selected group of quadrupole magnets, you choose the H/V correctors and calculate the response matrix of the induced orbit shift (IOS) 
by the quadrupole group with respect to the correctors, using the function 'calcInducedOrbitRespMat.m'. The result of the calculate is saved to file and used for the experimental codes.
(2) To do the measurement, edit and run the script 'test_PBBA.m', it calls the function 'correctInducedOrbitShift_Exp.m' to correct the IOS using the response matrix calculated during the setup.
(3) You can measure IOS with 'meas_IOS' or 'meas_IOS_mult' (for a scan) and view the results with 'view_measIOS'. 
