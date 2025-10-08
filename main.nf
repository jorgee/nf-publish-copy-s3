params.trial = 1
params.count = 10
params.size = '1M'
params.tasks = 2
params.vt = false

nextflow.preview.output = true

process create_random_file {
	cpus 2

    input:
    val num_task
    val count
    val size

    output:
    path 'upload-*'

    script:
    """
    for index in `seq $count` ; do
        dd if=/dev/random of=upload-${size}\${index}-${num_task}.data bs=1 count=0 seek=${size}
    done
    """
}

workflow {
    main:
    ch_tasks = Channel.of(1 .. params.tasks)
    ch_created_files = create_random_file(ch_tasks, params.count, params.size).collect().flatMap()
    
    publish:
    files = ch_created_files


}

output {
   files {
	path "data-${params.trial}-${params.count}-${params.size}-${params.vt}"
	}
}

