# eORCA1
Standard extended ORCA1 configuration

**_\*\* NB the code as it stands is a test configuration - the setup script has been tested and will checkout, compile and run the eORCA1 (NEMO 4.0.4) code on ARCHER2, but namelists and forcing files are intended for testing only_**

Configuration files for eORCA1

## Quick Start on ARCHER2:
git clone https://github.com/fabm-model/fabm.git
git clone git@gitlab.ecosystem-modelling.pml.ac.uk:edge/ersem.git
# then build FABM-ERSEM into FABAMDIR (likely ~/local/fabm)
# modules to be loaded for building on Archer2 are the same as in eORCA1/scripts/env/ucx_env
# then adjust to your paths and run:
cmake ~/git/fabm/src -DFABM_HOST=nemo -DFABM_ERSEM_BASE=~/git/ERSEM-edge/ -DFABM_EMBED_VERSION=ON -DFABM_INSTALL_PREFIX=~/local/fabm/nemo-prod-ERSEM-edge/lib -DCMAKE_Fortran_FLAGS:STRING="-O3"
make install -j4


```
git clone https://github.com/pmlmodelling/eORCA1.git
git checkout eORCA1_FABM
./eORCA1/scripts/setup/eORCA1_setup -w $PWD/test -x $PWD/test -s $PWD/eORCA1 -f $FABAMDIR
cd test/nemo/cfgs/eORCA1/EXP00
```
Edit the project code in  `runscript.slurm` then:
```
sbatch runscript.slurm
```
This will produce a 5 day mean output from the beginning of 2000, for 1 month. The run should take 5 minutes to complete once in the machine (configured to use the short queue in the runscript).

### Forcing data:

[eORCA1](http://gws-access.ceda.ac.uk/public/jmmp_collab/eORCA1)

_this is automatically transferred when the setup script is executed_

### Important:

NEMO v4.0.4 has a few ICE bugs in it. The repository's intended use is purely for testing at present. If you are wanting to pickup the bugfixes, either modify the setupscript to set `NEMO_VER=4.0.6` (namelists will need to be updated accordingly) or add a ticket to [Issues](https://github.com/NOC-MSM/eORCA1/issues) and I'll try an update ASAP.
