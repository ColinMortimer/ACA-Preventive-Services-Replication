clear
drop _all
global home "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
global output "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
global data "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data"
*set up

use "$data\2015.dta"
*opens initial dataset

generate lastden3 = .
*I am not too sure why I have this here, but at this point I am too scared to move it

keep(_llcpwt lastden3 hhadult qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2014.dta", keep(_llcpwt lastden3 hhadult qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2013.dta", keep(_llcpwt qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2012.dta", keep(_llcpwt lastden3 qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2011.dta", keep(_llcpwt qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2010.dta", keep(_llcpwt lastden3 qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)
append using "$data\2009.dta", keep(_llcpwt qstver hlthpln1 checkup1 _race _age80 income2 educa sex marital employ1 persdoc2 medcost _smoker3 _rfdrhv5 _totinda _bmi5 _rfbmi5 imonth _state expansion year children numadult)

*appends 2010-2015 data together

destring imonth, replace
*floats imonth

generate fips = _state
*generates identical variable

generate bmi = (_bmi5/100)
drop if bmi > 50
drop if bmi < 14
drop if _state >= 60
*dropping invalid observations

generate bmi_bad = 1 if bmi >= 25
replace bmi_bad = 0 if bmi < 25
*bmi dummy

generate years_educ = 1 if educa == 1
replace years_educ = 8 if educa == 2
replace years_educ = 11 if educa == 3
replace years_educ = 12 if educa == 4
replace years_educ = 15 if educa == 5
replace years_educ = 16 if educa == 6
drop educa
*education dummies

replace numadult = hhadult if numadult == . & qstver >= 20 & year >= 2014
replace numadult = 1 if numadult == . & qstver >= 20 & year <= 2013
*I hate how this data is coded

generate married = 1 if marital == 1
replace married = 0 if marital <= 9 & marital != 1
*Married Dummy

replace children = 0 if children == 88
*cleans children variable

generate employed = 1 if employ1 == 1 | employ1 == 2
replace employed = 0 if employ1 <= 7 & employ1 >= 3
*Employment Dummy

generate insurance = 1 if hlthpln1 == 1
replace insurance = 0 if hlthpln1 == 2
*insurance dummy

generate male = 1 if sex == 1
replace male = 0 if sex == 2
*Male Dummy

generate female = 1 if sex == 2
replace female = 0 if sex == 1
*Female Dummy

generate lowincome = 1 if income2 <= 2
replace lowincome = 0 if income2 <= 8 & income2 >= 3
*Low income Dummy

generate elderly = 1 if _age80 >= 65
replace elderly = 0 if _age80 < 65
*Elderly Dummy

generate expansion_dummy = 1 if expansion <= 3
replace expansion_dummy  = 0 if expansion == 4
*Indicates if a state ever expanded Medicare

generate white = 1 if _race == 1
replace white = 0 if _race <= 8 & _race != 1
*White Dummy

generate black = 1 if _race == 2
replace black = 0 if _race <= 8 & _race != 2
*Black Dummy

generate native_american = 1 if _race == 3
replace native_american = 0 if _race <= 8 & _race != 3
*Native American Dummy

generate asian = 1 if _race == 4
replace asian = 0 if _race <= 8 & _race != 4
*Asian Dummy

generate hawaiian = 1 if _race == 5
replace hawaiian = 0 if _race <= 8 & _race != 5
*Hawaiian Dummy

generate other = 1 if _race == 6
replace other = 0 if _race <= 8 & _race != 6
*Other race Dummy

generate multiracial = 1 if _race == 7
replace multiracial = 0 if _race <= 8 & _race != 7
*Multiracial Dummy

generate hispanic = 1 if _race == 3
replace native_american = 0 if _race <= 7 
*Hispanic Dummy

generate checkup = 1 if checkup1 == 1
replace checkup = 0 if checkup1 <= 8 & checkup1 != 1
*Check up Dummy

generate dental = 1 if lastden3 == 1
replace dental = 0 if lastden3 <= 4 & lastden3 != 1
*dental dummy

generate physactivity = 1 if _totinda == 1
replace physactivity = 0 if _totinda == 2
*physical activity dummy

generate binge = 1 if _rfdrhv5 == 2
replace binge = 0 if _rfdrhv5 == 1
*heavy drnking dummy

generate smoker = 1 if _smoker3 <= 2
replace smoker == 0 if _smoker3 >= 3 & _smoker3 <= 4
*smoking dummy

generate cellphone = .
replace cellphone = 1 if qstver >= 20
replace cellphone = 0 if qstver < 20

generate householdsize = numadult + children
*generates householdsize

generate FPLDummy = .
replace FPLDummy = 10000 if income2 == 1
replace FPLDummy = 15000 if income2 == 2
replace FPLDummy = 20000 if income2 == 3
replace FPLDummy = 25000 if income2 == 4
replace FPLDummy = 35000 if income2 == 5
replace FPLDummy = 50000 if income2 == 6
replace FPLDummy = 75000 if income2 == 7
generate FPLIncome = .
replace FPLIncome = 10830 + (3740 * (householdsize - 1)) if year == 2010
replace FPLIncome = 10890 + (3820 * (householdsize - 1)) if year == 2011
replace FPLIncome = 11170 + (3960 * (householdsize - 1)) if year == 2012
replace FPLIncome = 11490 + (4020 * (householdsize - 1)) if year == 2013
replace FPLIncome = 11670 + (4060 * (householdsize - 1)) if year == 2014
replace FPLIncome = 11770 + (4160 * (householdsize - 1)) if year == 2015
generate FPL = FPLDummy/FPLIncome
generate below_150FPL = 1 if FPL < 1.5
replace below_150FPL = 0 if FPL >= 1.5
*FPL Dummies

gen month = 0
replace month = 1 if imonth== 1
replace month = 2 if imonth== 2
replace month = 3 if imonth== 3
replace month = 4 if imonth== 4
replace month = 5 if imonth== 5
replace month = 6 if imonth== 6
replace month = 7 if imonth== 7
replace month = 8 if imonth== 8
replace month = 9 if imonth== 9
replace month = 10 if imonth== 10
replace month = 11 if imonth== 11
replace month = 12 if imonth== 12
*generating mont variable

gen quarter = 0
replace quarter = 1 if month>=1 & month<=3
replace quarter = 2 if month>=4 & month<=6
replace quarter = 3 if month>=7 & month<=9
replace quarter = 4 if month>=10 & month<=12
*create quarter variable

gen period = quarter + 4*(year-2010)
*unique period identifier 

tab _state, gen(state_dummy)
*state fixed effects

tab year, gen(year_dummy)
*year fixed effects

tab FPLDummy, gen(FPL_dummy)
*income fixed effects

merge m:1 fips year using "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data\Controls.dta"
drop _merge
*merges data with unemployment rates by year

save "C:\Users\colin\OneDrive\Documents\UConn\Fourth Semester\Graduate Health Economics\Replication\Data\Master.dta", replace
*I have no idea why I didn't put this line in earlier
