# Installs solr via Homebrew.
#
# Usage:
#
#     include solr
class solr {
  include homebrew
  include java

  
  notify { $env:
  }

  homebrew::formula { 'solr':
    before => Package['boxen/brews/solr']
  }

  package { 'boxen/brews/solr':
    ensure  => '4.1.0-boxen1',
    require => Class['java']
  }
  
  $instances = get_instances("local")
  # solr::core { $instances: }
}
