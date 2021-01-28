rule sort:
    input:
        "data/example/project_1.txt"
    output:
        "output/example/project_1.sorted.txt"
    shell:
        "sort {input} > {output}"

rule sort_2:
    input:
        "data/example/project_2.txt"
    output:
        "output/example/project_2.sorted.txt"
    shell:
        "sort {input} > {output}"

rule intersect:
    input:
        "output/example/project_1.sorted.txt",
        "output/example/project_2.sorted.txt"
    output:
        "output/example/project_1_2.txt"
    shell:
        "comm -12 {input[0]} {input[1]} > {output}"
