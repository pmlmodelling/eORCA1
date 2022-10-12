#!/bin/bash
#SBATCH --job-name=nemo_test
#SBATCH --time=05:00:00
##SBATCH --time=00:10:00
#SBATCH --nodes=11
#SBATCH --ntasks=572
#SBATCH --account=n01-pml
#SBATCH --partition=standard
#SBATCH --qos=standard
##SBATCH --reservation=shortqos
##SBATCH --qos=short
# Created by: mkslurm -S 11 -s 16 -m 1 -C  561 -c  2 -t 00:10:00 -a n01-pml -j nemo_test

# SUBMIT WITH:
# "sbatch --export=y0=1970,m0=1 MultiMonthRunscript-Perpetual-11nodes.slurm"

module -s restore /work/n01/shared/acc/n01_modules/ucx_env
module restore /etc/cray-pe.d/PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module unload craype-network-ofi
module unload cray-mpich
module load craype-network-ucx
module load cray-mpich-ucx
module load libfabric
module load gcc
module swap gcc/10.1.0 gcc/9.3.0

export OMP_NUM_THREADS=1

echo y0/m0: $y0/$m0

SECONDS=0
#time_start=`date +%y%m%d%H%M%S`

NNODES=$SLURM_NODES
NCORES=$SLURM_NTASKS

#number of months to launch:
#nmmax=12
nmmax=6
#nmmax=3
#nmmax=1

echo "Submitting year" $y0 "month" $m0 "..."

#ystart=1958
ystart=1970
#yend=1973
#yend=1975
#yend=1990
yend=2010
#yend=2099
yscenario=0

RUNDIR=$PWD
#INPUTS=/work/n01/n01/gig/eORCA1/INPUTS
#RESTARTS=/work/n01/n01/gig/eORCA1/RESTARTS

cd $RUNDIR

echo "$SLURM_JOB_ID Submitting year/month" $y0/$m0 >> jobs.log

stopflag=0

# general time setting:
# NB, dt MUST MATCH the value in namelist.template
#dt=2700 
#dt=1350
dt=900
nsstart=$(date -d "$ystart-01-01 00:00:00 GMT" +%s) #seconds since EPOCH for total simulation start

#cleanup:
./annualclean.sh $RUNDIR #TO DO!!!!!!!!!!!!!!!!!!

#link annual forcing files:
./setAnnualLinks.sh $RUNDIR $y0 #TO DO!!!!!!!!!!!!!!

# nm: currnet month (now), mp: next month (plus 1),  mm: previous month (minus 1)
nm=1 #initialise month counter

while [ $nm -le $nmmax ]
do
 #Compute previous and next month:
 mp=$(( $m0 + 1 ))
 if [ $mp -eq 13 ]
 then
    mp=1
    yp=$(( y0 + 1 ))
 else
    yp=$y0
 fi
 mm=$(( $m0 - 1 ))
 if [ $mm -eq 0 ]
 then
    mm=12
    ym=$(( y0 - 1 ))
 else
    ym=$y0
 fi
 if [ $y0 -le $yend ]
 then
   echo "Preparing $y0 $m0 ..."
   ./monthlyclean.sh $RUNDIR   #TO DO!!!!!!!!!!!!!!

   m0str=$(printf %02d $m0)
   mpstr=$(printf %02d $mp)
   mmstr=$(printf %02d $mm)

   ARCHIVEDIR=$RUNDIR/$y0/$m0str

   #restarts:
   rm -rf restart.nc restart_ice.nc restart_trc.nc restart_[0-9]???.nc restart_trc_[0-9]???.nc restart_ice_[0-9]???.nc
   if [ $y0 -eq $ystart ] && [ $m0 -eq 1 ]
   then
      #ln -sf $RESTARTS/restart.nc restart.nc
      #ln -sf $RESTARTS/restart_ice.nc restart_ice.nc
      #ln -sf $RESTARTS/restart_trc.nc restart_trc.nc
      #ln -sf /work/n01/n01/gig/eORCA1/INPUTS/RESTARTS/restart_jdha.nc restart.nc
      #ln -sf /work/n01/n01/gig/eORCA1/INPUTS/RESTARTS/restart_trc_v12.nc restart_trc.nc
      ln -sf $RUNDIR/$ym/$mmstr/restart.nc .
      ln -sf $RUNDIR/$ym/$mmstr/restart_trc.nc .
      ln -sf $RUNDIR/$ym/$mmstr/restart_ice.nc .
      lnrst=.true.
      lnrsttrc=.true.
      lntsd=.false.
      rst=0
      euler=0
   else
      if [ $y0 -eq $yscenario ] && [ $m0 -eq 1 ]   #THIS PART PROBAB USELESS!!!!!!!!!!!!!!!!
      then                                         #THIS PART PROBAB USELESS!!!!!!!!!!!!!!!!
        ln -sf restart.$tagscenario.nc restart.nc  #WHAT IS $tagscenario????????????????????
        ln -sf restart_trc.$tagscenario.nc restart_trc.nc
      else
        if [ -s $RUNDIR/$ym/$mmstr/restart_0000.nc ]
        then
           ln -sf $RUNDIR/$ym/$mmstr/restart_????.nc .
        elif [ -s $RUNDIR/$ym/$mmstr/restart.nc ]
        then
           ln -sf $RUNDIR/$ym/$mmstr/restart.nc .
        else
          stopflag=1
        fi
        if [ -s $RUNDIR/$ym/$mmstr/restart_trc_0000.nc ]
        then
          ln -sf $RUNDIR/$ym/$mmstr/restart_trc_????.nc .
        elif [ -s $RUNDIR/$ym/$mmstr/restart_trc.nc ]
        then
          ln -sf $RUNDIR/$ym/$mmstr/restart_trc.nc .
        else
          stopflag=2
        fi
        if [ -s $RUNDIR/$ym/$mmstr/restart_ice_0000.nc ]
        then
          ln -sf $RUNDIR/$ym/$mmstr/restart_ice_????.nc .
        elif [ -s $RUNDIR/$ym/$mmstr/restart_ice.nc ]
        then
          ln -sf $RUNDIR/$ym/$mmstr/restart_ice.nc .
        else
          stopflag=3
        fi
      fi
      lnrst=.true.
      lnrsttrc=.true.
      lntsd=.false.
      rst=2
      #rst=0
      euler=0
      #euler=1
   fi

   #compute run-time:
   case $m0 in
      4|6|9|11) nit=$(( 86400*30/dt )) ;;
      2) if [ $(( y0 % 4 )) -ne 0 -o $(( y0 % 100)) -eq 0 -a $(( $y0 % 400 )) -ne 0 ]; then nit=$(( 86400*28/dt )); else nit=$(( 86400*29/dt )); fi ;;
      *) nit=$(( 86400*31/dt )) ;;
   esac
   #force 30d month instead
   #nit=$(( 86400*30/dt ))
   #nit=96 # 1d with dt=900s
   #nit=15
   #nit=25
   #nit=950 #30d - 10steps da 2700s
   #nit=2400 #25d with dt=900s 

   #compute start iteration and end iteration:
   ns0=$(date -d "$y0-${m0str}-01 00:00:00 GMT" +%s) #seconds since EPOCH for this chunk
   n0=$(( ns0 - nsstart ))
   n0=$(( n0 / dt + 1 ))
   nend=$(( n0 + nit -1 ))
   d0=$y0${m0str}01

   cat namelist.TEMPLATE \
                | sed "s,__DATE0__,$d0,g" \
                | sed "s,__RST__,$rst,g" \
                | sed "s,__TSD__,$lntsd,g" \
                | sed "s,__LNRST__,$lnrst,g" \
                | sed "s,__N0__,$n0,g" \
                | sed "s,__NEND__,$nend,g" \
                | sed "s,__EULER__,$euler,g" \
                > namelist_cfg
   cat namelist_top.TEMPLATE \
                | sed "s,__LNRST__,$lnrsttrc,g" \
                | sed "s,__RST__,$rst,g" \
                > namelist_top_cfg
   # NO NEED FOR cat namelist_ice.template, I think!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   if [ $stopflag -ne 0 ]
   then
      echo "stopflag=$stopflag Forced exit."
      exit
   fi

   echo "Launching $y0 $m0 at $(date +%s) seconds since 1970-01-01 00:00:00 on $NCORES cores"

   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   # __INSERT_LAUNCH_SCRIPT_HERE__
   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   cat > myscript_wrapper2.sh << EOFB
#!/bin/ksh
#
set -A map ./xios_server.exe ./nemo
exec_map=( 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 )
#
#
exec \${map[\${exec_map[\$SLURM_PROCID]}]} 
##
EOFB
   chmod u+x ./myscript_wrapper2.sh
   #
   srun --mem-bind=local --cpu-bind=v,map_cpu:00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e,0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e,0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e,00,0x10, ./myscript_wrapper2.sh
   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   # __INSERT_LAUNCH_SCRIPT_HERE__
   # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   echo "Finished $y0 $m0 at $(date +%s) seconds since 1970-01-01 00:00:00"

   #prepare archive directory
   mkdir -p $ARCHIVEDIR
   #prepare restart files:
   for file in eORCA1_*${nend}_restart_????.nc
   do
      fn=${file: -7:4} #file number
      mv $file $ARCHIVEDIR/restart_$fn.nc
   done
   for file in eORCA1_*${nend}_restart_ice_????.nc
   do
      fn=${file: -7:4} #file number
      mv $file $ARCHIVEDIR/restart_ice_$fn.nc
   done
   for file in eORCA1_*${nend}_restart_trc_????.nc
   do
      fn=${file: -7:4} #file number
      mv $file $ARCHIVEDIR/restart_trc_$fn.nc
   done

   #move outputs:
   mv eORCA1_*_${d0}_*.nc $ARCHIVEDIR
   bzip2 ocean.output && mv -f ocean.output.bz2 $ARCHIVEDIR
   mv -f time.step $ARCHIVEDIR

   # remove restarts of the previous year
   # so I dont delete the restart I need to use
   # leave just 2 per year (Jun, Dec)
   #case $m0 in 1|2|3|4|5|7|8|9|10|11) rm $ym/$m0str/restart*.nc && rm $ym/$m0str/restart_trc*.nc && rm $ym/$m0str/restart_ice*.nc;; esac

   #archive:
   fname=$y0/$m0str
   echo "Archiving in $fname ..."
   sbatch --export=RUNDIR=$PWD,ARCHIVEDIR=$ARCHIVEDIR,folder=$fname archiveFolder.slurm

   # remove restarts of the previous year to save space
   # leave just 2 per year (Jun, Dec)
   case $m0 in 1|2|3|4|5|7|8|9|10|11) rm $ym/$m0str/restart*.nc && rm $ym/$m0str/restart_trc*.nc && rm $ym/$m0str/restart_ice*.nc;; esac

 fi
 y0=$yp
 m0=$mp
 nm=$(( nm + 1 ))

done

#time_end=`date +%y%m%d%H%M%S`
duration=$SECONDS

#echo "Done $nmmax months in $(( (time_end-time_start) /60  )) minutes."
echo "Done $nmmax months in $(($SECONDS / 60)) minutes."


##resubmit:
if [ $y0 -le $yend ]
then
   echo 'Submitting' $y0 $m0 '...'
   sbatch --export=y0=$y0,m0=$m0 MultiMonthRunscript-Perpetual-11nodes.slurm
   echo "Done."
else
   echo "All done."
fi

