#############################################################
## ADJUSTABLE PARAMETERS                                   ##
#############################################################
# Input files
set inputname      prot_ligs_autopsf
set outputname     out_eq01
set restartfile    out_eq00

set ref_fix        fixed.pdb
set ref_smd        refsmd.pdb
set ref_umb        fixed.pdb

# Temperatures
set temperature	 300     ;# Temperature
set firsttimestep  0

# Simulation Flags
set npt            0       ;# Isothermal-Isobaric ensemble
set fix            1       ;# Fixed atoms
set cons           0       ;# Harmonic constraint
set smd            0       ;# Steered Molecular Dynamics
set Col            0       ;# Collective variable
set ext            0       ;# Extra Bonds
set tcl            0       ;# Funnel Potential

set min            1       ;# Minimize
set slowHeat       0       ;# Slow Heating
set slowRelease    0       ;# Slow Release
set MDRun          0       ;# Do Normal MD run
set restart        0       ;# Restart from previous file

# Other Options
set NStepsCycle    40      ;# Steps per cyle
set Dtime          2.0     ;# Integration time step (fs)
set out_step       100    ;# Output frequency
set minSteps       2000    ;# Minimize
set numSteps       200000  ;# 0.4 ns

#############################################################
## SIMULATION PARAMETERS                                   ##
#############################################################
# Input File
structure          $inputname.psf
coordinates        $inputname.pdb

# CHARMM Parameter files
paraTypeCharmm     on
GBIS on
sasa on 
surfaceTension 0.006
parameters        toppar/toppar_water_ions.str
parameters        toppar/par_all35_ethers.prm
parameters        toppar/par_all36_carb.prm
parameters        toppar/par_all36_cgenff.prm
parameters        toppar/par_all36_lipid.prm
parameters        toppar/par_all36m_prot.prm
parameters        toppar/par_all36_na.prm

# Restarting from previous run option(s)
if {$restart == 0} { 
  # Periodic Boundary Conditions
  # NOTE: Do not set the periodic cell basis if you have also 
  # specified an .xsc restart file!
 
#cellBasisVector1		89	0	0
#cellBasisVector2		0	111	0
#cellBasisVector3		0	0	234
#cellOrigin	 161.6516571044922 	 153.5530242919922 	 101.88494110107422


# NOTE: Do not set the initial velocity temperature if you 
  # have also specified a .vel restart file!
  temperature       $temperature
  firsttimestep     $firsttimestep

} else {
  # Restart file(s)
  binCoordinates    $restartfile.restart.coor
  binVelocities     $restartfile.restart.vel  ;# remove the "temperature" entry if you use this!
  extendedSystem    $restartfile.restart.xsc
 
  # Initial temperature
  firsttimestep     $firsttimestep
  #temperature       $temperature
}

# Force-Field Parameters
exclude             scaled1-4
1-4scaling          1.0
cutoff              16.
switching           on
switchdist          10.
pairlistdist        18.0

# Integrator Parameters
timestep            $Dtime
nonbondedFreq       2
fullElectFrequency  4
stepsPerCycle       $NStepsCycle

# PME (for full-system periodic electrostatics)
#PME                 yes
#PMEGridSpacing      1.0
#PMEGridSizeX        115
#PMEGridSizeY        115
#PMEGridSizeZ        85
#margin              1.0

#wrapWater           on
#wrapAll             on

# Shake Options
rigidBonds          all

# Constant Temperature Control
langevin            on          ;# do langevin dynamics
langevinDamping     1.0         ;# damping coefficient (gamma) of 1/ps
langevinTemp        $temperature
langevinHydrogen    off

# Constant Pressure Control (variable volume)
if {$npt == 1} {
  StrainRate            0.0 0.0 0.0
  useGroupPressure      yes    ;# needed for 2fs steps
  useFlexibleCell       no     ;# no for water box, yes for membrane
  useConstantArea       no     ;# no for water box, yes for membrane

  langevinPiston        yes
  langevinPistonTarget  1.01325 ;#  in bar -> 1 atm
  langevinPistonPeriod  200.
  langevinPistonDecay   50.
  langevinPistonTemp    $temperature
}

# Output Options
outputName         $outputname
restartfreq        $out_step   
dcdfreq            $out_step
xstFreq            $out_step
outputEnergies     $out_step
outputPressure     $out_step

#############################################################
## EXTRA PARAMETERS                                        ##
#############################################################
# Fixed-atoms
if {$fix == 1} {
  fixedAtoms         on
  fixedAtomsForces   on
  fixedAtomsFile     $ref_fix
  fixedAtomsCol      O
}

# Steered MD
if {$smd == 1} {
  SMD                on
  SMDFile            $ref_smd
  SMDDir             0 0 1
  SMDk               0.1
  SMDVel             0.0
  SMDOutputFreq      $out_step
}

# Harmonic Restraint
if {$cons == 1} {
  constraints        on
  consexp            10 
  consref            $ref_umb
  conskfile          $ref_umb
  conskcol           B
  selectConstraints  on
  selectConstrX      on
  selectConstrY      on
  selectConstrZ      on
}

# Collective Variables
if {$Col == 1} {
  colvars            on
  colvarsConfig      colvarsrot.tcl
}

# Extra Bonds
if {$ext == 1} {
  extraBonds         on
  extraBondsFile     extra1.bonds
}

#############################################################
## MD MINIMIZATION/EQUILIBRATION                           ##
#############################################################
# Minimize
if {$min == 1} {
  minimize       $minSteps
  reinitvels     $temperature
}

# Slow heating
if {$slowHeat == 1} {
  for {set i 0} {$i < $temperature} {incr i 20} {
    langevinTemp $i
    reinitvels   $i
    run          [expr $NStepsCycle*10]
  }
  firsttimestep  0
  reinitvels     $temperature
}

# Slow Release Equilibration of Protein
if {$slowRelease == 1} {
  set lambda {1.000 0.748 0.496 0.370 0.244 0.181 0.118 0.086 0.055 0.040 0.024 0.016 0.008 0.004 0.000}
  for {set i 0} {$i < [llength $lambda]} {incr i 1} {
    constraintScaling [lindex $lambda $i]
    reinitvels $temperature
    run  $numSteps
  }
}

# Normal MD run
if {$MDRun == 1} {
  run $numSteps
}
