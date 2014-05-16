# == Class: logstash_reporter
#
# This class deploys and configures a puppet reporter to send reports to logstash
#
#
# === Parameters
#
# [*logstash_host*]
#   String.  Logstash host to write reports to
#   Default: 127.0.0.1
#
# [*logstash_port*]
#   Integer.  Port logstash is listening for tcp connections on
#   Default: 5999
#
# [*config_file*]
#   String.  Path to write the config file to
#   Default: /etc/puppet/logstash.yaml
#
#
# === Examples
#
# * Installation:
#     class { 'apache': }
#
#
# === Authors
#
# * John E. Vincent
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class logstash_reporter (
  $logstash_host  = '127.0.0.1',
  $logstash_port  = 5959,
  $config_file  = '/etc/puppetlabs/puppet/logstash.yaml',
  $puppet_config_file = '/etc/puppetlabs/puppet/puppet.conf',
  $config_owner = 'pe-puppet',
  $config_group = 'pe-puppet',
){
  
  augeas {'puppet_conf_master_logstash':
    context => "/files${puppet_config_file}/master",
    changes => ["set reports console,puppetdb,logstash","set report true", "set pluginsync true"],
  }
  
  augeas {'puppet_conf_agent_logstash':
    context => "/files${puppet_config_file}/agent",
    changes => ["set report true", "set pluginsync true"],
  }

  file { $config_file:
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => '0444',
    content => template('logstash_reporter/logstash.yaml.erb'),
  }

}

