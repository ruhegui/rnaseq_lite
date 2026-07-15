
process CAT {
    tag "$meta.id"
    label 'process_low'    

    input:
    tuple val(meta), path(R1), path(R2)

    output:
    tuple val(meta), path("${meta.id}_merged_1.fq.gz"), path("${meta.id}_merged_2.fq.gz"), emit: files
    tuple val("${task.process}"), val("cat"), eval("cat --version | sed -n '1{s/cat //;p}'"), topic: versions, emit: versions_cat

    when:
    task.ext.when == null || task.ext.when

    script:
    def r1 = R1.join(' ')
    def r2 = R2.join(' ')


    """
    cat ${r1} > "${meta.id}_merged_1.fq.gz"
    cat ${r2} > "${meta.id}_merged_2.fq.gz"
    """

    
    stub:
    """
    touch "${meta.id}_merged_1.fq.gz"
    touch "${meta.id}_merged_2.fq.gz"
    """
}
