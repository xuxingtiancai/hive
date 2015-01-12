function creat() {
    echo "
        use ad_search;
        drop table ${module}_xuxing;
        create external table if not exists 
        ${module}_xuxing(
            query string , 
            search float,
            click float,
            revenue float
        )
        partitioned by(dt string comment 'hdfs://ns1/user/jd_ad/${outfile}') 
        row format delimited fields terminated by '\t'
    ;" | hive
}

function partition() {
    date=$1
    echo "
        use ad_search;
        alter table keyword_pv_revenue_xuxing
        add partition(dt='$date') location 'hdfs://ns1/user/jd_ad/${outfile}/$date';
        select * from keyword_pv_revenue_xuxing where dt='$date' limit 5;
    " | hive
}
