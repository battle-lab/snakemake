# snakemake
This repository works as a template to start a Snakemake project. Along with a basic file structure and example codes, it contains a snakemake profile to submit jobs on [MARCC](https://www.marcc.jhu.edu/).

### How to install Snakemake on MARCC
```
##########################################################
### load required modules                              ###
##########################################################

# load anaconda module version >= 4.6.0
module load  anaconda

# load python
module load python/3.7.4-anaconda 

############################################################
### create and activate a custom conda environment       ###
### to install/update packages without admin privilege   ###
### following instructions from                          ###
### https://www.marcc.jhu.edu/python-environments/.      ###
### see section "Case B. Custom conda environments"      ###
############################################################

# go to a directory to create conda 
# NOTE: MARCC recommends creating conda environments inside ~/work/code/
cd /home-1/asaha6@jhu.edu/python_env/conda # remember to change the directory

# create reqs.yaml file with basic packages
printf "dependencies:\n\
  - python=3.7\n\
  - matplotlib\n\
  - scipy\n\
  - numpy\n\
  - nb_conda_kernels\n\
  - au-eoed::gnu-parallel\n\
  - h5py\n\
  - pip\n\
  - pip:\n\
    - sphinx" > reqs.yaml
    
# install conda environment
conda env update --file reqs.yaml -p ./my_conda_env

# activate conda environment
conda activate /home-net/home-1/asaha6@jhu.edu/python_env/conda/my_conda_env

##############################################################################
### install snakemake using the new enviroment following instructions from ###
### https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html      ###
##############################################################################

# install mamba
conda install -c conda-forge mamba

# install snakemake using mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake

# exit from current environment
conda deactivate

# activate snakemake 
conda activate snakemake

# now you may run snakemake commands. test if help works.
snakemake --help
```

### How to activate (and deactivate) Snakemake

```
module load  anaconda              # >= v4.6.0, use the version used during installation
module load python/3.7.4-anaconda  # >= v3.7, use the version used during installation
conda env list                     # you'll see all available environments
conda activate YOUR/SNAKEMAKE/ENV  # activate snakemake env
# conda deactivate                 # to exit/deactivate snakemake
```

### How to run Snakemake on MARCC
1. In your github account, create a new repository by using [this repository](https://github.com/battle-lab/snakemake) as a template. [Related tutorial](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template). You will keep your codes in this repository. No need to write any extra code for demo.
2.  Clone the new repository on marcc. [Related tutorial](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository).
    ```
    git clone https://github.com/USER-NAME/REPOSITORY-NAME
    ```
3. Make sure you are on a MARCC login node and Snakemake is activated. See the section above.
4.  Go to the repository directory on MARCC.
    ```
    cd PATH/TO/YOUR/REPO
    ```
5.  Run the following using maximum 2 cores.
    ```
    snakemake --profile profiles/marcc -j2
    ```
### How to configure jobs
Edit the global and job-specific configuration files to configure your jobs.

Global configuration file: [profiles/marcc/config.yaml](profiles/marcc/config.yaml).
```
restart-times: 0                  # if failed, the job will not be restarted
jobscript: "slurm-jobscript.sh"
cluster: "slurm-submit.py"
cluster-status: "slurm-status.py"
max-jobs-per-second: 1            # max job submission rate 1 job/sec
max-status-checks-per-second: 10
local-cores: 1
latency-wait: 60                  # wait time (sec) if output file not found
```


Job-specific configuration file: [profiles/marcc/cluster_config.yaml](profiles/marcc/cluster_config.yaml).
```
# default configuration for every rule (unless overridden)
__default__:
  partition: express
  nodes: 1
  ntasks: 1
  time: 10  # min
  output: "output/marcc_logs/{rule}/slurm-%j.out"
  error: "output/marcc_logs/{rule}/slurm-%j.err"
  job-name: "{rule}"

# configuration for "project_counts" rule -- overrides the default
project_counts:
  time: 15
  ntasks: 2
```

### How to customize the repository for a specific project
1. Add your scripts in the repository -- preferably in `src` folder (please create the folder).
2. Edit configuration variables in `config/config.yaml` file.
3. Add your Snakemake rules in `rules` folder.
4. Edit `Snakefile` to aggregate all rules and to define final outcomes of the project.
5. Edit `profiles/marcc/cluster_config.yaml` to allocate resources for each job.

NOTE: You may like to delete example rules in `rules` folder, example data in `data/example` folder.

### Snakemake-related resources
* [Snakemake tutorial](https://snakemake.readthedocs.io/en/stable/tutorial/tutorial.html) - Highly recommended!
* Useful arguments to run Snakemake are available [here](https://snakemake.readthedocs.io/en/stable/executing/cli.html).
* Open-source snakemake profiles to run jobs on different environments are available [here](https://github.com/Snakemake-Profiles).
* Snakemake-intro [slides](https://github.com/alorchhota/alorchhota.github.io/raw/master/static/talk/snakemake_2021.pptx).
* Snakemake in action: [Ashis' project](https://github.com/alorchhota/spice_analysis).
* Snakemake video tutorial:[Youtube link](https://youtu.be/VAohXxK0Ma8)
* How to deal with variable output (an unkown number of files) via checkpoints: [Stack Overflow](https://stackoverflow.com/questions/60792649/snakemake-variable-number-of-files)
