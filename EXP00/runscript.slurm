#!/bin/bash
#SBATCH --job-name=nemo_test
#SBATCH --time=00:40:00
#SBATCH --nodes=2
#SBATCH --ntasks=43
#SBATCH --account=n01-pml
#SBATCH --partition=standard
#SBATCH --qos=standard
##BATCH --reservation=shortqos
##BATCH --qos=short
# Created by: mkslurm -S 4 -s 16 -m 2 -C  39 -c  4 -t 00:10:00 -a n01-pml -j nemo_test
module restore /work/n01/shared/acc/n01_modules/ucx_env
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
#
cat > myscript_wrapper2.sh << EOFB
#!/bin/ksh
#
set -A map ./xios_server.exe ./nemo
exec_map=( 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 )
#
exec \${map[\${exec_map[\$SLURM_PROCID]}]} 
##
EOFB
chmod u+x ./myscript_wrapper2.sh
#
srun --mem-bind=local --cpu-bind=v,map_cpu:00,0x10,0x20,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x40,0x44,0x48,0x4c,0x50,0x54,0x58,0x5c,0x60,0x64,0x68,0x6c,0x70,0x74,0x78,0x7c,00,0x10,0x20,0x24,0x28,0x2c,0x30,0x34,0x38,0x3c,0x40,0x44,0x48,0x4c,0x50,0x54,0x58, ./myscript_wrapper2.sh
