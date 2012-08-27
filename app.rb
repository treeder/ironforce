require 'sinatra'
require 'iron_worker_ng'
require 'iron_mq'
require 'iron_cache'
require 'yaml'
require 'uuid'
require 'rack-flash'
require 'sinatra/base'

# bump.

enable :sessions
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

require_relative 'models/cache_orm'
orm = CacheOrm.new(ironcache.cache("leads"))
set :orm, orm

require_relative 'models/idable'
require_relative 'models/contact'

require_relative 'controllers/main'

