# checks the job status, creates/updates status.csv, and optionally throws an error if status is incomplete

# read the command-line arguments
nprocs <- as.numeric(substring(grep("nprocs=", commandArgs(), value=TRUE), 1+nchar("nprocs=")))

# combine the to-do list and the done list of jobs into a status file
status <- read.csv('jobs.csv', header=TRUE, stringsAsFactors = FALSE)[, 'jobID', drop=FALSE]
status$done <- FALSE # assume done for now; update_status will get called before we try to run anything

# add a column assigning undone jobs to specific processes. make it so there are
# roughly the same number of tasks assigned to each process, but order the 
# assignment randomly to make it probable that no one process will get stuck 
# with all the long jobs. use procIDs ranging from 0 to nprocs-1 to match the
# slurm indexing convention
njobs <- length(which(!status$done))
status$procID <- NA
status$procID[!status$done] <- sample(rep(seq_len(nprocs)-1, length.out=njobs), size=njobs)

# write to a file
write.csv(status, 'status.csv', row.names=FALSE)

