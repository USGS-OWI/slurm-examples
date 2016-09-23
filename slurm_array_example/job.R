#libraries can be simply sourced if your .Renviron
# points to a valid location of installed R libs
library(dataRetrieval)


#using array mode, you have access to the task ID
# which can be used to divide jobs
task_id = as.numeric(Sys.getenv('SLURM_ARRAY_TASK_ID', 'NA'))

if(is.na(task_id)){
  stop("ERROR Can not read task_id, NA returned")
}

#select the job based on task_id
jobs = read.csv('jobs.csv', colClasses = c('site_no'='character'))
nwis_id = jobs$site_no[task_id]


#get and write data based on the job selected
phos_data = readNWISqw(nwis_id, '00665')
write.csv(phos_data, paste0('nwis_', nwis_id, '.csv'), row.names=FALSE)

