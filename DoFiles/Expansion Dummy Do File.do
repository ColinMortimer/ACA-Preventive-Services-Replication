generate expansion = 1

replace expansion = 2 if _state == 6
replace expansion = 2 if _state == 9
replace expansion = 2 if _state == 15
replace expansion = 2 if _state == 27
replace expansion = 2 if _state == 55

replace expansion = 3 if _state == 10
replace expansion = 3 if _state == 11
replace expansion = 3 if _state == 25
replace expansion = 3 if _state == 36
replace expansion = 3 if _state == 50

replace expansion = 4 if _state == 1
replace expansion = 4 if _state == 12
replace expansion = 4 if _state == 13
replace expansion = 4 if _state == 16
replace expansion = 4 if _state == 20
replace expansion = 4 if _state == 22
replace expansion = 4 if _state == 23
replace expansion = 4 if _state == 28
replace expansion = 4 if _state == 29
replace expansion = 4 if _state == 30
replace expansion = 4 if _state == 31
replace expansion = 4 if _state == 37
replace expansion = 4 if _state == 40
replace expansion = 4 if _state == 45
replace expansion = 4 if _state == 46
replace expansion = 4 if _state == 47
replace expansion = 4 if _state == 48
replace expansion = 4 if _state == 49
replace expansion = 4 if _state == 51
replace expansion = 4 if _state == 56

save, replace
