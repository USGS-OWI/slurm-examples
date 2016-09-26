# worker script designed to mimic a process that can't be guaranteed to complete
# successfully every time. this script runs only those jobs assigned to this
# particular process.


# find the jobs assigned to this process
jobsTable <- read.csv('status.csv', header=TRUE, stringsAsFactors=FALSE)

# filter to just those jobs assigned to this t
procid <- as.numeric(Sys.getenv('SLURM_PROCID')) # or for array mode: procid = as.numeric(Sys.getenv('SLURM_ARRAY_TASK_ID', 'NA'))
if(!is.na(procid)) { # if() only necessary if we're ever not using Slurm
  jobsToRun <- jobsTable[jobsTable$procID == procid, 'jobID']
} else {
  jobsToRun <- jobsTable$jobID
}

# get the job configuration info
jobsConfig <- read.csv('jobs.csv', header=TRUE, stringsAsFactors=FALSE)

# run the jobs assigned to this process (with our artificial unreliability to
# mimic truly unreliable jobs, e.g., models or HTTP transfers that sometimes
# fail)
for(jobid in jobsToRun) {
  configrow <- jobsConfig[jobsConfig$jobID==jobid, ]
  success <- runif(1) > 0.3
  if(success) {
    output <- c(
      paste0('Successfully ran model #', jobid),
      paste0('arg1 = ', configrow$arg1),
      paste0('arg2 = ', configrow$arg2)
    )
    writeLines(output, con=sprintf('jobs_out/job_%03d.txt', jobid))
  }
}

