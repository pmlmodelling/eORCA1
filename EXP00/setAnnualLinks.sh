#!/bin/bash
# Command line arguments:
#   $1: rundir
#   $2: simulation year

#INPUT_PATH=/work/n01/n01/...
INDIR_GIG=/work/n01/shared/gig/MA_PML_INPUTS
INDIR_JDHA=/work/n01/n01/jdha/scratch/eORCA1/nemo/cfgs/eORCA1/EXP01
INDIR_JDHA_JRA=/work/n01/n01/jdha/scratch/eORCA1/nemo/cfgs/eORCA1/EXP01/INPUTS/JRA/JRA_v1.5.0_rechunk
RUNPATH=$1

yn=$2             # curr year
yb=$(( $yn-1 ))   # previous year
ya=$(( $yn+1 ))   # next year

# SBC
mkdir -p $RUNPATH/SBC
rm -rf $RUNPATH/SBC/*

ln -sf $INDIR_JDHA_JRA/huss_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/huss_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/huss_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/ptot_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/ptot_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/ptot_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/rlds_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/rlds_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/rlds_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/rsds_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/rsds_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/rsds_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/prsn_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/prsn_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/prsn_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/psl_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/psl_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/psl_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/tas_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/tas_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/tas_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/uas_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/uas_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/uas_y$ya.nc $RUNPATH/SBC

ln -sf $INDIR_JDHA_JRA/vas_y$yn.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/vas_y$yb.nc $RUNPATH/SBC
ln -sf $INDIR_JDHA_JRA/vas_y$ya.nc $RUNPATH/SBC

#NB MISSING taudif_core

ln -sf $INDIR_GIG/ndep-noy_histsoc_monthly_atmosgrid_y$yn.nc $RUNPATH/INPUTS
ln -sf $INDIR_GIG/ndep-noy_histsoc_monthly_atmosgrid_y$yb.nc $RUNPATH/INPUTS
ln -sf $INDIR_GIG/ndep-noy_histsoc_monthly_atmosgrid_y$ya.nc $RUNPATH/INPUTS

ln -sf $INDIR_GIG/ndep-nhx_histsoc_monthly_atmosgrid_y$yn.nc $RUNPATH/INPUTS
ln -sf $INDIR_GIG/ndep-nhx_histsoc_monthly_atmosgrid_y$yb.nc $RUNPATH/INPUTS
ln -sf $INDIR_GIG/ndep-nhx_histsoc_monthly_atmosgrid_y$ya.nc $RUNPATH/INPUTS



#FILL IN WITH REAL FILE NAMES WHARE * ARE !!!!!!!!!!!!!!!!!!!!!

## rivers:
#rm -rf RIV/*
#ln -sf $INPUT_PATH/RIV/... $RUNPATH/RIV/rivers_y$yn.nc
#
#ln -sf $INPUT_PATH/ATM_BGC/... $RUNPATH/ATM_BGC/*ndep*$yn.nc
#ln -sf $INPUT_PATH/ATM_BGC/... $RUNPATH/ATM_BGC/*dust*$yn.nc
#ln -sf $INPUT_PATH/ATM_BGC/pCO2a_y${yn}.nc $RUNPATH/ATM_BGC/
#
## physics atmospheric forcing:
#mkdir -p $RUNPATH/ATM
#
#rm -rf $RUNPATH/ATM/huss*.nc
#rm -rf $RUNPATH/ATM/pr*.nc
#rm -rf $RUNPATH/ATM/rlds*.nc
#rm -rf $RUNPATH/ATM/rsds*.nc
#rm -rf $RUNPATH/ATM/prsn*.nc
#rm -rf $RUNPATH/ATM/tas*.nc
#rm -rf $RUNPATH/ATM/vas*.nc
#rm -rf $RUNPATH/ATM/uas*.nc
#rm -rf $RUNPATH/ATM/psl*.nc
#
#ln -sf $INPUT_PATH/ATM/huss*${yn}.nc $RUNPATH/ATM/huss*.nc
#ln -sf $INPUT_PATH/ATM/pr*${yn}.nc   $RUNPATH/ATM/pr*.nc
#ln -sf $INPUT_PATH/ATM/rlds*${yn}.nc $RUNPATH/ATM/rlds*.nc
#ln -sf $INPUT_PATH/ATM/rsds*${yn}.nc $RUNPATH/ATM/rsds*.nc
#ln -sf $INPUT_PATH/ATM/prsn*${yn}.nc $RUNPATH/ATM/prsn*.nc
#ln -sf $INPUT_PATH/ATM/tas*${yn}.nc  $RUNPATH/ATM/tas*.nc
#ln -sf $INPUT_PATH/ATM/vas*${yn}.nc  $RUNPATH/ATM/vas*.nc
#ln -sf $INPUT_PATH/ATM/uas*${yn}.nc  $RUNPATH/ATM/uas*.nc
#ln -sf $INPUT_PATH/ATM/psl*${yn}.nc  $RUNPATH/ATM/psl*.nc
#
#ln -sf $INPUT_PATH/ATM/huss*${yb}.nc $RUNPATH/ATM/huss*.nc
#ln -sf $INPUT_PATH/ATM/pr*${yb}.nc   $RUNPATH/ATM/pr*.nc
#ln -sf $INPUT_PATH/ATM/rlds*${yb}.nc $RUNPATH/ATM/rlds*.nc
#ln -sf $INPUT_PATH/ATM/rsds*${yb}.nc $RUNPATH/ATM/rsds*.nc
#ln -sf $INPUT_PATH/ATM/prsn*${yb}.nc $RUNPATH/ATM/prsn*.nc
#ln -sf $INPUT_PATH/ATM/tas*${yb}.nc  $RUNPATH/ATM/tas*.nc
#ln -sf $INPUT_PATH/ATM/vas*${yb}.nc  $RUNPATH/ATM/vas*.nc
#ln -sf $INPUT_PATH/ATM/uas*${yb}.nc  $RUNPATH/ATM/uas*.nc
#ln -sf $INPUT_PATH/ATM/psl*${yb}.nc  $RUNPATH/ATM/psl*.nc
#
#ln -sf $INPUT_PATH/ATM/huss*${ya}.nc $RUNPATH/ATM/huss*.nc
#ln -sf $INPUT_PATH/ATM/pr*${ya}.nc   $RUNPATH/ATM/pr*.nc
#ln -sf $INPUT_PATH/ATM/rlds*${ya}.nc $RUNPATH/ATM/rlds*.nc
#ln -sf $INPUT_PATH/ATM/rsds*${ya}.nc $RUNPATH/ATM/rsds*.nc
#ln -sf $INPUT_PATH/ATM/prsn*${ya}.nc $RUNPATH/ATM/prsn*.nc
#ln -sf $INPUT_PATH/ATM/tas*${ya}.nc  $RUNPATH/ATM/tas*.nc
#ln -sf $INPUT_PATH/ATM/vas*${ya}.nc  $RUNPATH/ATM/vas*.nc
#ln -sf $INPUT_PATH/ATM/uas*${ya}.nc  $RUNPATH/ATM/uas*.nc
#ln -sf $INPUT_PATH/ATM/psl*${ya}.nc  $RUNPATH/ATM/psl*.nc


