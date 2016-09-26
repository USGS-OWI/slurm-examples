# update the status file based on the job output files

# read in the existing status file
status <- read.csv('status.csv', header=TRUE, stringsAsFactors=FALSE)

# define a function to take a list of job IDs and return a vector of logicals,
# TRUE if the job is complete and FALSE otherwise. job number xxx is considered
# complete if a job_xxx.txt file exists in the jobs_out directory.
check_status <- function(jobIDs) {
  # create (if needed) and query the jobs_out folder for records of complete jobs
  if(!dir.exists('jobs_out')) dir.create('jobs_out')
  jobs_files <- dir('jobs_out')
  found_jobs <- as.numeric(substring(jobs_files, first=nchar('job_')+1, last=nchar(jobs_files)-nchar('.txt')))
  
  # return the status of each of the jobIDs
  ifelse(jobIDs %in% found_jobs, TRUE, FALSE)
}

# update with current status of each job. use jobsToCheck to only check jobs
# that weren't already marked done, e.g., if the files documenting completion
# sometimes disappear but you believe the job is already done if jobs.csv hasn't
# been updated more recently than status.csv and status.csv thinks it's done
jobsToCheck <- which(!status$done) # or TRUE if you want to check all jobs every time
if(length(jobsToCheck) > 0) {
  status$done[jobsToCheck] <- check_status(status$jobID[jobsToCheck])
}

# if require_done=TRUE, throw an error if we're not done with all jobs
if(any(!status$done)) {
  require_done <- as.logical(substring(grep("require_done=", commandArgs(), value=TRUE), 1+nchar("require_done=")))
  if(require_done) stop(paste0(length(which(!status$done)), ' jobs are still incomplete'))
}
