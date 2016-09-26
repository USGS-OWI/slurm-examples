
#I like to use environment variables to determine the 
# worker "rank" (which worker node) and the 
#  cluster size (number of workers)

mpirank = as.numeric(Sys.getenv('SLURM_PROCID'))
mpisize = as.numeric(Sys.getenv('SLURM_NPROCS'))


## Code to do something

cat(sprintf('I am node number: %i out of %i nodes\n', mpirank, mpisize))

## save or output 