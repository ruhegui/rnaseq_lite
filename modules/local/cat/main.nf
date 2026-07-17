process CAT {
    tag "$meta.id"
    label 'process_low'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("${meta.id}_merged*fq.gz"), emit: files
    tuple val("${task.process}"), val("cat"), eval("cat --version | sed -n '1{s/cat //;p}'"), topic: versions, emit: versions_cat

    when:
    task.ext.when == null || task.ext.when

    script:
    if (meta.single_end) {
        def r1 = reads.join(' ')

        """
        cat ${r1} > ${meta.id}_merged.fq.gz
        """
    } else {
        def reads1 = []
        def reads2 = []

        reads.eachWithIndex { file, i ->
            (i % 2 == 0 ? reads1 : reads2) << file
        }

        def r1 = reads1.join(' ')
        def r2 = reads2.join(' ')

        """
        cat ${r1} > ${meta.id}_merged_1.fq.gz
        cat ${r2} > ${meta.id}_merged_2.fq.gz
        """
    }

    stub:
    if (meta.single_end) {
        """
        touch ${meta.id}_merged.fq.gz
        """
    } else {
        """
        touch ${meta.id}_merged_1.fq.gz
        touch ${meta.id}_merged_2.fq.gz
        """
    }
}