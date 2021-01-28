rule sort:
    input:
        expand("{input_dir}/project_{fnum}.txt", input_dir = config["input_dir"], fnum="{fnum}")
    output:
        "{output_dir}/project_{fnum}.sorted.txt"
    log:
        "{output_dir}/logs/sort/sort_{fnum}.log"
    shell:
        "sort {input} > {output}"

rule intersect:
    input:
        f1="{output_dir}/project_{fnum1}.sorted.txt",
        f2="{output_dir}/project_{fnum2}.sorted.txt"
    output:
        "{output_dir}/project_{fnum1}_{fnum2}.txt"
    log:
        "{output_dir}/logs/intersect/project_{fnum1}_{fnum2}.log"
    shell:
        "comm -12 {input.f1} {input.f2} > {output} 2> {log}"

rule project_counts:
    input:
        expand("{input_dir}/project_{fnum}.txt", input_dir = config["input_dir"], fnum=config["battle_projects"])
    output:
        "{output_dir}/counts.txt"
    params:
        sleep_time = "30s",
        exit_msg = "output saved in {output_dir}/counts.txt. exiting ..."
    log:
        "{output_dir}/logs/project_counts/project_counts.log"
    shell:
        """
        echo "counting projects per person ..."
        cat {input} | sort | uniq -c | sort -k1n  >  {output} 2> {log}
        echo "sleeping {params.sleep_time}..."
        sleep {params.sleep_time}
        echo "job done..."
        echo {params.exit_msg}
        """

rule top_counts:
    input: 
        "{output_dir}/counts.txt"
    output: 
        "{output_dir}/top{N}_counts.txt"
    log:
        "{output_dir}/logs/top_counts/top{N}_counts.log"
    shell:
        """
        sort -k1nr {input} | head -n {wildcards.N} > {output} 2> {log}
        """

