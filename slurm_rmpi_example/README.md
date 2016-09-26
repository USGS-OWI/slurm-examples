##Install Rmpi

I've been successful with this command combo
```
module load mpi/openmpi-1.5.5-gcc
R -e "install.packages('Rmpi', repos = 'http://cran.rstudio.com', configure.args = '--with-Rmpi-include=/cxfs/projects/root/opt/mpi/gcc/openmpi-1.5.5/include --with-Rmpi-libpath=/cxfs/projects/root/opt/mpi/gcc/openmpi-1.5.5/lib --with-Rmpi-type=OPENMPI')"
```