********************************************************************************
* SP6015 
* Do-file Demo Mgg#6
* - Instrumental Variable
* By Adenantera Dwicaksono, PhD.
********************************************************************************

********** SETUP **********
clear all
set more off
version 12


use "D:\Documents\OneDrive - Institut Teknologi Bandung\Documents\Teaching\SP6015\Mgg#6\card.dta", clear


*****************************  
* 1. Run the Naive OLS regression
*****************************

regress lwage educ, robust

*****************************  
* 2. Run 2SLS regression
*****************************

//1. Run first stage of regression and obtain the predicted values
regress educ nearc4, robust

predict educhat, xb

//2. Run second stage of regression
regress lwage educhat, robust


//Use ivreg
ivregress 2sls lwage (educ = nearc4), robust

//Use ivreg
ivregress liml lwage (educ = nearc4), robust

//Testing relevance assumption of IV

regress educ nearc4, robust

test nearc4


*****************************  
* 3. Run 2SLS with 1 instrument and control variables
*****************************
gen age2 = age^2

//Run first stage regression
regress educ nearc4 age age2 south smsa, robust

//Run F-test for joint significant to test if coefficient IV = 0
test nearc4

//Run IV estiamtes with control variables

ivregress 2sls lwage (educ = nearc4) age age2 south smsa, robust

*****************************  
* 4. Run 2SLS with more than 1 instrument and control variables
*****************************

//Run first stage regression
regress educ nearc4 nearc2 age age2 south smsa, robust

//Run F-test for joint significant to test if coefficient IV = 0
test nearc4=nearc2=0

// Overidentification restriction test Sargan test, J-test

//Run IV regression with IV and control variables
ivregress 2sls lwage (educ = nearc4 nearc2) age age2 south smsa, robust

//Obtain residual
predict res, resid


//Regression res on IV and control variables
regress res nearc4 nearc2 age age2 south smsa, robust

//Run F-test for joint significant to test if coefficient IV = 0
test nearc4=nearc2=0

//Compute J=mF
disp 2*1.24 // 2 =  number of instruments

//Run IV regression with IV and control variables
ivregress 2sls lwage (educ = nearc4 nearc2) age age2 south smsa, robust

// Run Sargan's J-test
estat overid

*****************************  
* 4. Run 2SLS with more than 1 instrument and control variables
*****************************

//Comparison

regress lwage educ, robust
outreg2 using tabel1.xls, excel replace ctitle(OLS)

regress lwage educ age age2 south smsa, robust
outreg2 using tabel1.xls, excel append ctitle(OLS + Controls)

ivregress 2sls lwage (educ = nearc4), robust
outreg2 using tabel1.xls, excel append ctitle(2SLS 1 IV no Controls)

ivregress 2sls lwage (educ = nearc4) age age2 south smsa, robust
outreg2 using tabel1.xls, excel append ctitle(2SLS 1 IV + Controls)

ivregress 2sls lwage (educ = nearc4 nearc2) age age2 south smsa, robust
outreg2 using tabel1.xls, excel append ctitle(2SLS 2 IVs + Controls)

//First Stage results


ivregress 2sls lwage (educ = nearc4), robust  first
outreg2 using tabel1.xls, excel append ctitle(2SLS 1 IV no Controls)

ivregress 2sls lwage (educ = nearc4) age age2 south smsa, robust first
outreg2 using tabel1.xls, excel append ctitle(2SLS 1 IV + Controls)

ivregress 2sls lwage (educ = nearc4 nearc2) age age2 south smsa, robust  first
outreg2 using tabel1.xls, excel append ctitle(2SLS 2 IVs + Controls)
