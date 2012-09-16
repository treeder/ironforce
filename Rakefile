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
  task :upload_email do
    client = IronWorkerNG::Client.new(@config['iron'])
    # Upload the code
    code = IronWorkerNG::Code::Base.new('workers/email_worker')
    client.codes.create(code)
  end
  task :upload_lead do
    client = IronWorkerNG::Client.new(@config['iron'])
    # Upload the code
    code = IronWorkerNG::Code::Base.new('workers/lead_worker')
    client.codes.create(code)
  end
  task :upload do
    Rake::Task["workers:upload_email"].invoke
    Rake::Task["workers:upload_lead"].invoke
  end

end
