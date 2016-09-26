

library(Rmpi)
library(snow)

mpirank <- mpi.comm.rank(0)    # just FYI
mpisize <- mpi.comm.size()

cat("Launching master (MPI_SIZE=", mpisize, " MPI_RANK=",     mpirank, ")\n")

if (mpirank == "0") {                   # are we master ?
   cat("Launching master (MPI_SIZE=", mpisize, " MPI_RANK=",     mpirank, ")\n")
   makeMPIcluster()
} else {                                # or are we a slave ?
   cat("Launching slave with (MPI_SIZE=", mpisize, " MPI_RANK=", mpirank, ")\n")
   #sink(file="/dev/null")
   slaveLoop(makeMPImaster())
   q()
}

## a trivial main body, but note how getMPIcluster() learns from the
## launched cluster how many nodes are available
cl <- getMPIcluster()

job_code = function(){
    #something long-running
    Sys.sleep(100)
}

res <- clusterCall(cl, job_code)
print(do.call(c,res))
stopCluster(cl)
