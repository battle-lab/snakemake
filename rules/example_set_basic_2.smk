battle_projects = ["eqtl", "prs", "network", "sc", "randomforest"]

rule all:
    input:
        "output/example/project_counts.txt",
        "output/example/project_eqtl_network.txt",
        "output/example/project_network_sc.txt"

rule sort:
    input:
        "data/example/project_{fnum}.txt"
    output:
        "output/example/project_{fnum}.sorted.txt"
    shell:
        "sort {input} > {output}"

rule intersect:
    input:
        f1="output/example/project_{fnum1}.sorted.txt",
        f2="output/example/project_{fnum2}.sorted.txt"
    output:
        "output/example/project_{fnum1}_{fnum2}.txt"
    shell:
        "comm -12 {input.f1} {input.f2} > {output}"

rule project_counts:
    input:
        expand("data/example/project_{fnum}.txt", fnum=battle_projects)
    output:
        "output/example/project_counts.txt"
    shell:
        """
        cat {input} | sort | uniq -c | sort -k1n  >  {output}
        """
