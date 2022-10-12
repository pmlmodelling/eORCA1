#!/bin/bash
#SBATCH --job-name=arxv
#SBATCH --output=slurm-%x-%j.out
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=n01-pml
#SBATCH --partition=serial
#SBATCH --qos=serial

set -u
cd $RUNDIR

# submit as:
# sbatch --export=RUNDIR=$PWD,ARCHIVEDIR=$ARCHIVEDIR,folder=$fname archiveFolder.slurm

REBUILD=/work/n01/n01/gig/rebuild_nemo.exe

MONTH=${folder:5:2}

module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel

time_start=`date +%y%m%d%H%M%S`

cd $RUNDIR

if [ -d $folder ]
then
  cd $folder
  echo Archiving $folder
  #mkdir -p $ARCHIVEDIR/$folder
  #chmod g+rX $ARCHIVEDIR

  rm nam_rebuild
  rm nam_rebuild_trc
  rm nam_rebuild_ice
  ndom=$(ls -1 restart_????.nc | wc -l)
  echo -e "&nam_rebuild\nfilebase='restart'\nndomain=$ndom\n/" >> nam_rebuild
  echo -e "&nam_rebuild\nfilebase='restart_trc'\nndomain=$ndom\n/" >> nam_rebuild_trc
  echo -e "&nam_rebuild\nfilebase='restart_ice'\nndomain=$ndom\n/" >> nam_rebuild_ice

  $REBUILD nam_rebuild && nccopy -k 4 -d 9 restart.nc restart-C.nc && mv restart-C.nc restart.nc && rm restart_????.nc && echo "archived restart.nc" || echo "ERROR, restart.nc failed!!!"
  $REBUILD nam_rebuild_trc && nccopy -k 4 -d 9 restart_trc.nc restart_trc-C.nc && mv restart_trc-C.nc restart_trc.nc && rm restart_trc_????.nc && echo "archived restart_trc.nc" || echo "ERROR, restart_trc.nc failed!!!"
  $REBUILD nam_rebuild_ice && nccopy -k 4 -d 9 restart_ice.nc restart_ice-C.nc && mv restart_ice-C.nc restart_ice.nc && rm restart_ice_????.nc && echo "archived restart_ice.nc" || echo "ERROR, restart_ice.nc failed!!!"

  for file in eORCA1*.nc
  do
    nccopy -k 4 -d 9 $file $file-C && mv $file-C $file && echo "   " $file compressed || echo "   "ERROR, $file 'compression failed!!!'
  done

#  rsync -a ocean.output.bz2 $ARCHIVEDIR/$folder
#
#  for file in eORCA1*.nc
#  do
#     nccopy -k 4 -d 9 $file $ARCHIVEDIR/$folder/$file && rm $file && echo "   " $file || echo "   "ERROR, $file 'failed!!!'
#  done
#
#  chmod -R g+rX $ARCHIVEDIR/$folder/*
#
#  cd $ARCHIVEDIR
#  for file in $folder/*.nc
#  do
#    echo "Tagging" $file "..."
#    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#    #!INSERT FILE TAGGING SCRIPT HERE!
#    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#    chmod g+rX $folder
#    chmod -R g+rX $folder/..
#  done
fi

time_end=`date +%y%m%d%H%M%S`

echo "Done in $(( (time_end-time_start) /60  )) minutes."
