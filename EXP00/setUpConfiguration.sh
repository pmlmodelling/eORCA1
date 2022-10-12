#!/bin/bash

INDIR_GIG=/work/n01/shared/gig/MA_PML_INPUTS
INDIR_GIG_DUMMY=/work/n01/shared/gig/MA_dummy_inputs
INDIR_GIG_RESTARTS=/work/n01/n01/gig/eORCA1/INPUTS/RESTARTS
INDIR_JDHA=/work/n01/n01/jdha/scratch/eORCA1/nemo/cfgs/eORCA1/EXP01
INDIR_JDHA_JRA=/work/n01/n01/jdha/scratch/eORCA1/nemo/cfgs/eORCA1/EXP01/INPUTS/JRA/JRA_v1.5.0_rechunk
RUNPATH=$PWD

##prepare folders for annual forcings:
#mkdir -p $RUNPATH/ATM/
#rm -rf $RUNPATH/ATM/*
#mkdir -p $RUNPATH/ATM_BGC/
#rm -rf $RUNPATH/ATM_BGC/*
#mkdir -p $RUNPATH/TIDE/
#rm -rf $RUNPATH/TIDE/*
#mkdir -p $RUNPATH/WEIGHTS/
#rm -rf $RUNPATH/WEIGHTS/*
#mkdir -p $RUNPATH/IC/
#rm -rf $RUNPATH/IC/*

# NB: FILL IN * WITH CORRECT FILE NAMES

# 1969 Restarts
mkdir -p $RUNPATH/1969/12
rsync -aP $INDIR_GIG/restart_trc_v15.nc $RUNPATH/1969/12/restart_trc.nc
#rsync -aP $INDIR_GIG/restart_trc_v13.nc $RUNPATH/1969/12/restart_trc.nc
rsync -aP $INDIR_GIG_RESTARTS/restart_jdha.nc $RUNPATH/1969/12/restart.nc
rsync -aP $INDIR_GIG_RESTARTS/eORCA1_00140160_restart_ice.nc $RUNPATH/1969/12/restart_ice.nc

# eddy viscosity file
rsync -aP $INDIR_JDHA/eddy_viscosity_3D.nc $RUNPATH/

# light ady climatology
rsync -aP $INDIR_GIG/eORCA1-CCI-ady-broadband-climatology-1997-2020.nc $RUNPATH/INPUTS

# iron deposition climatology
#rsync -aP $INDIR_GIG/dust_orca_nM_eORCA1_v2.nc $RUNPATH/INPUTS
rsync -aP $INDIR_GIG/eORCA1_Fe_dep_GESAMP.nc $RUNPATH/INPUTS

# pCO2 climatology
rsync -aP $INDIR_GIG_DUMMY/pCO2a.nc $RUNPATH/INPUTS

# river nutrient loads
rsync -aP $INDIR_GIG/dummy_river_load.nc $RUNPATH/INPUTS

# weights
rsync -aP $INDIR_JDHA/INPUTS/weights_JRA_bicubic.nc $RUNPATH/INPUTS
rsync -aP $INDIR_JDHA/INPUTS/weights_JRA_bilinear.nc $RUNPATH/INPUTS

## initial condition for physics
#ln -sf $INPUT_PATH/IC/*.nc $RUNPATH/IC/
#
## Light
#ln -sf $INPUT_PATH/eORCA1-ADY-broadband.nc $RUNPATH/ATM_BGC/
#
## Penetrative Solar Radiation
#ln -sf $INPUT_PATH/eORCA1-*.nc $RUNPATH/ATM_BGC/
#
## Interpolation weigths for surface flux forcing (if needed)
#ls -sf $INPUT_PATH/WEIGHTS/* $RUNPATH/WEIGHTS/*
#
## TIDES
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K1_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K1_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K1_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_K2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_L2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_L2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_L2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M4_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M4_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_M4_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_MU2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_MU2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_MU2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_2N2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_2N2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_2N2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_N2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_N2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_N2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_NU2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_NU2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_NU2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_O1_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_O1_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_O1_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_P1_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_P1_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_P1_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_Q1_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_Q1_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_Q1_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S1_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S1_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S1_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_S2_grid_V.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_T2_grid_T.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_T2_grid_U.nc "$RUNPATH"/TIDE/
#ln -sf "$INPUT_PATH"/TIDE/rc_eORCA1_bdytide_T2_grid_V.nc "$RUNPATH"/TIDE/
