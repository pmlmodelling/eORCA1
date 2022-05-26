#!/bin/bash

RUNDIR=$1

echo "Cleaning month " $RUNDIR "..."
rm -f $RUNDIR/eORCA1_?d_*_grid_*.nc $RUNDIR/eORCA1_1m_*_grid*.nc $RUNDIR/eORCA1_1y_*_grid*.nc
rm -f $RUNDIR/eORCA1_?d_*_ptrc_*.nc $RUNDIR/eORCA1_1m_*_ptrc*.nc $RUNDIR/eORCA1_1y_*_ptrc*.nc
rm -f $RUNDIR/eORCA1_?d_*_icemod.nc $RUNDIR/eORCA1_1m_*_icemod.nc $RUNDIR/eORCA1_1y_*_icemod.nc
rm -rf $RUNDIR/restart.nc $RUNDIR/restart_ice.nc $RUNDIR/restart_trc.nc
echo "Done."
