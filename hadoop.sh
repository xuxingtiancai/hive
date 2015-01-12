    cmd = '%(hadoop)s jar %(streaming)s \
        -input %(infile)s \
        -output %(outfile)s \
        -jobconf mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
        -jobconf num.key.fields.for.partition=1 \
        -jobconf stream.num.map.output.key.fields=1 \
        -jobconf stream.map.input=typedbytes \
        -jobconf mapred.job.name=%(module)s_by_xuxing \
        -jobconf mapred.reduce.tasks=%(reduce_num)d \
        -jobconf mapred.job.map.capacity=%(map_capacity)s \
        -jobconf mapred.job.reduce.capacity=%(reduce_capacity)s \
        -inputformat org.apache.hadoop.mapred.SequenceFileAsBinaryInputFormat \
        -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
        -file %(filepath)s \
        -file lib/ArchiveLog_pb2.py \
        -file lib/typedbytes.py \
        -mapper "%(python)s %(filename)s -t map,combiner" \
        -reducer "%(python)s %(filename)s -t reduce" \
        -cacheArchive guowentao/python2.7.tar.gz#python27 \
        '%{
            'hadoop':hadoop,
            'infile': ' -input '.join(os.path.join(path, date) for path in infile.split(",")),
            'outfile': os.path.join(outfile, date),
            'streaming': streaming,
            'filepath': filepath,
            'filename': filename,
            'module' : module,
            'reduce_num':100,
            'map_capacity': '1000',
            'reduce_capacity': '100',
            'python' : 'python27/bin/python2.7',
        }
