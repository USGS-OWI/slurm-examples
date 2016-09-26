# `slurm_makefile_example`

This example is for the case where a makefile guides the overall data analysis, 
with one step that we want to conduct on a cluster. The non-cluster step in this
very simple example is to create the jobs.csv file. The cluster step is to run 
one job for each row of jobs.csv.

In addition, we assume that the cluster process is unreliable: it can't be 
guaranteed to complete successfully every time, e.g., because it involves a HTTP
data transfer or messy data inputs (but here, artificially, it's unreliable 
because it's only "successful" when a random number exceeds a threshold). We'd 
like a makefile-slurm setup that can be run and rerun until every job has been 
run successfully, at which point `make` will say we're up to date.

The strategy we take is to create and maintain a status file, status.csv, that 
`make` updates before and after each Slurm attempt. The jobs in jobs.csv that 
have not yet been completed are noted in status.csv and are divided among the 
number of nodes we will use from the Slurm cluster. When status.csv finally says
that every job is complete, a final signalling file is written (jobs_done.txt) 
to indicate to us and to `make` that we're all set.

To run the example, change into this directory at your local command line and 
enter the following to create jobs.csv.

```
make jobs.csv
```

Then log on to your slurm cluster, copy this directory over to the cluster, `cd`
into this directory, and enter the following to run the jobs on the slurm 
cluster. (Or if you want to bypass the cluster for testing, set `SLURM = FALSE`
in the makefile and run the following from your local computer.)

```
make jobs_done.txt
```

You will probably need to run `make jobs_done.txt` several times because of the 
unreliability of the process. If not every job is done, you'll see an error with
the number of unfinished jobs, like this:

```
$ make jobs_done.txt
Rscript update_status.R "require_done=FALSE"
srun -n ${NPROCS} -p exper -A cida --time=01:00:00 Rscript run_jobs_unreliably.R
Rscript update_status.R "require_done=TRUE"
Error: 16 jobs are still incomplete
Execution halted
make: *** [jobs_done.txt] Error 1
```

When every job is done, `make` will happily refuse to do any more work:
```
$ make jobs_done.txt
make: 'jobs_done.txt' is up to date.
```
