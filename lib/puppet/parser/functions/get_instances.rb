require 'socket'
require 'puppet/face'
require 'resolv'
require 'aws-sdk'

module Puppet::Parser::Functions
  newfunction(:get_instances, :type => :rvalue) do |args|
    # return 1 or more arguments for function as array
    envs = args[0].to_a
    #array to be returned
    instances = Array.new
    
    config_path = File.expand_path(File.dirname(boxen::config::configdir)+"/aws.yml")
    AWS.config(YAML.load(File.read(config_path)))

    # create s3 object to read instance configs
    s3 = AWS::S3.new
    #bucket should be some sort of hiera variable?
    bucket = s3.bucket['apigee-devconnect']
    #for each returned environment ...
    envs.each do |env|
      #read that environments configs
      #Dir.glob("#{Puppet[:vardir]}/yaml/instances/env")
      bucket.objects.with_prefix('site-config/#{env}/').each do |file|

        #Load each host as a hash
        tempfile = YAML::load_file(file).values

        #push onto a return array
        instances.push("dc-#{tempfile['env']}-#{tempfile['orgname']}")
      end
    end
    return instances
  end
end


