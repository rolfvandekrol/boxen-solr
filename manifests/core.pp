define solr::core() {

  $solr_install_dir = "/opt/apache-solr-${solrver}"
  $solr_multicore = "${solr_install_dir}/example/multicore"

  #Create this core's config directory
  exec { "mkdir-p-${title}" :
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    command => "mkdir -p ${solr_multicore}/${title}",
    unless => "test -d ${solr_multicore}/${title}",
  }

  #Copy its config over
  file { "core-${title}-conf" :
          ensure => directory,
          recurse => true,
          path => "${solr_multicore}/${title}/conf",
          source => "puppet:///modules/solr/conf/",
          require => Exec["mkdir-p-${title}"],
  }

  #Finally, create the data directory where solr stores
  #its indexes with proper directory ownership/permissions.
  file { "${title}-data-dir" :
          ensure => directory,
          path => "${solr_multicore}/${title}/data",
          owner => "apache",
          group => "apache",
          before => File['solr.xml'],
  }
}