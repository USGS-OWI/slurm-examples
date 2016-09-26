# create the jobs list. this only needs to be done once.
seed <- as.numeric(substring(grep("seed=", commandArgs(), value=TRUE), 6))
set.seed(seed)
numjobs <- 100
df <- data.frame(jobID=seq_len(numjobs), arg1=sample(LETTERS, numjobs, replace=TRUE), arg2=sample(letters, numjobs, replace=TRUE))
write.csv(df, file='jobs.csv', row.names = F)
