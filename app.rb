require 'sinatra'
require 'iron_worker_ng'
require 'iron_mq'
require 'iron_cache'
require 'yaml'
require 'uuid'
require 'rack-flash'

# bump.

enable :sessions, :logging, :dump_errors, :raise_errors, :show_exceptions
use Rack::Flash

set :public_folder, File.expand_path(File.dirname(__FILE__) + '/assets')

$: << '.'
require 'config'

ironmq = IronMQ::Client.new(SingletonConfig.config[:iron])
#ironmq.logger.level = Logger::DEBUG
ironcache = IronCache::Client.new(SingletonConfig.config[:iron])
ironworker = IronWorkerNG::Client.new(SingletonConfig.config[:iron])
set :ironmq, ironmq
set :ironcache, ironcache
set :ironworker, ironworker

ocm = Ocm::Orm.new(ironcache.cache("ironforce"))
set :ocm, ocm

require_relative 'models/contact'

post '/lead' do
  puts 'in lead'

  # Now queue up email worker
  begin
    task = settings.ironworker.tasks.create("lead_worker", {config: SingletonConfig.config}.merge(params))
    p task
  rescue => ex
    p ex
    p ex.code
    p ex.backtrace
    raise ex
  end

  flash[:notice] = "Submitted, thank you!"

  redirect "/"
end

get '/leads' do
  @contacts = settings.orm.get_list("lead_list")
  erb :contacts
end

get '*' do
  erb :index
end

