# load modules
shell.prefix("module load R/4.0.2; module load python/3.7.4-anaconda; ")

# configurations
configfile: "config/config.yaml"

# first rule runs by default
rule all:
  input:
    expand(
      [
        # project intersections
        "{output_dir}/project_eqtl_network.txt",
        "{output_dir}/project_network_sc.txt",
        # project counts per person
        "{output_dir}/counts.txt",
        # top 5 counts
        "{output_dir}/top5_counts.txt"
      ],
      output_dir = config['output_dir'])


# other rules
include: "rules/example_set_basic_3.smk"

