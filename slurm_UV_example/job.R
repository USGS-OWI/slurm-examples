library(parallel)

#spin up cluster using number of CPUs allocated on UV
cl = parallel::makeForkCluster(as.numeric(system('nproc', intern=TRUE)), outfile="")

#set random seed properly
parallel::clusterSetRNGStream(cl, 681357)

parallel::clusterEvalQ(cl, {R.version})

to_run_parallel = function(x){
    cat('Running:', x, '\n')
    Sys.sleep(100)
}

parallel::clusterApplyLB(cl, to_run_parallel)



