::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim
::vsim -gui -do run.do 
:: script batch de wind
vsim -gui -do "do run.do %1" run.do 
