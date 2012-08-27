require 'uber_config'
require 'iron_worker_ng'

@config = UberConfig.load
p @config

task :push_config do
  require_relative 'config_pusher'
  cp = ConfigPusher.new
  cp.push
end

namespace :workers do
  task :upload_email_worker do
    client = IronWorkerNG::Client.new(@config['iron'])
    # Upload the code
    code = IronWorkerNG::Code::Base.new(:workerfile => 'workers/email_worker.worker')
    client.codes.create(code)
  end

end
