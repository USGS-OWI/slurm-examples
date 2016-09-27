# Example makefile using Slurm

# Macros

NPROCS = 10
SLURM := $(shell command -v srun 2> /dev/null)

# Targets

all : jobs.csv jobs_done.txt

jobs.csv : create_jobs_list.R
	Rscript create_jobs_list.R "seed=27"

status.csv : jobs.csv
	Rscript write_status.R "nprocs=${NPROCS}"

jobs_done.txt : status.csv
	Rscript update_status.R "require_done=FALSE"
ifdef SLURM
	srun -n ${NPROCS} -p exper -A cida --time=01:00:00 Rscript run_jobs_unreliably.R
else
	Rscript run_jobs_unreliably.R
endif
	Rscript update_status.R "require_done=TRUE"
	touch $@
