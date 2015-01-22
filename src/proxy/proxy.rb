require 'net/http'
require 'optparse'
require 'uri'
require 'yaml'

$config_file = nil
OptionParser.new do |opts|
  opts.on('-c CONFIG_FILE', '--config_file=CONFIG_FILE', 'Location of the configuration file') do |c|
    $config_file = c
  end
end.parse!

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  begin
    Net::HTTP.get(URI.parse("http://#{next_host}:4567"))
  rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED
    502
  end
end

$last_index = 0
def next_host
  hosts = config.fetch('hosts', [])
  $last_index += 1
  $last_index = $last_index % hosts.size
  hosts[$last_index]
end

def config
  $config ||= YAML.load_file($config_file)
end
