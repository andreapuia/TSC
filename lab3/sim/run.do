<<<<<<< HEAD
#---------------------------------------------------------------------------------------
# Script description: compiles the project sources &
#                     starts the simulation
#---------------------------------------------------------------------------------------

# Set transcript file name
## transcript file ../reports/regression_transcript/transcript_$1

# Check if the sources must be re-compiled
if {[file isdirectory work]} {
  set compile_on 0
} else {
  set compile_on 1
}

# In [GUI_mode]: always compile sources / [regress_mode]: compile sources only once
if {$compile_on || [batch_mode] == 0} {
  vlib work
  vlog -sv -timescale "1ps/1ps" -work work       -f sources.txt
}

# Load project
  eval vsim -novopt -quiet -nocoverage +notimingchecks +nowarnTSCALE -sva top
# eval vsim -novopt -quiet -coverage -notogglevlogints +notimingchecks +nowarnTSCALE +TESTNAME=$1 -sva top

# Run log/wave commands
# Batch_mode = 0 [GUI_mode]; Batch_mode = 1 [regress_mode]
if {[batch_mode] == 0} {
  eval log -r /*
  eval do wave.do
}

# On brake:
onbreak {
  # save coverage report file (when loading project with coverage)
    #eval coverage save "../reports/regression_coverage/coverage_$1.ucdb"
    
  # if [regress_mode]: continue script excution
  if [batch_mode > 0] {
    resume
  }
}

# Run/exit simulation
run -all
quit -sim
=======
#---------------------------------------------------------------------------------------
# Script description: compiles the project sources &
#                     starts the simulation
#---------------------------------------------------------------------------------------

# Set transcript file name
## transcript file ../reports/regression_transcript/transcript_$1

# Check if the sources must be re-compiled
if {[file isdirectory work]} {
  set compile_on 0
} else {
  set compile_on 1
}

# In [GUI_mode]: always compile sources / [regress_mode]: compile sources only once
if {$compile_on || [batch_mode] == 0} {
  vlib work
  vlog -sv -timescale "1ps/1ps" -work work       -f sources.txt
}

# Load project
  eval vsim -novopt -quiet -nocoverage +notimingchecks +nowarnTSCALE -sva top
# eval vsim -novopt -quiet -coverage -notogglevlogints +notimingchecks +nowarnTSCALE +TESTNAME=$1 -sva top

# Run log/wave commands
# Batch_mode = 0 [GUI_mode]; Batch_mode = 1 [regress_mode]
if {[batch_mode] == 0} {
  eval log -r /*
  eval do wave.do
}

# On brake:
onbreak {
  # save coverage report file (when loading project with coverage)
    #eval coverage save "../reports/regression_coverage/coverage_$1.ucdb"
    
  # if [regress_mode]: continue script excution
  if [batch_mode > 0] {
    resume
  }
}

# Run/exit simulation
run -all
quit -sim
>>>>>>> 16a76deebae846478504aa4b655a725816ea89ec
