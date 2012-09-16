post '/lead' do

  # Queue up task for lead_worker
  task = settings.ironworker.tasks.create("lead_worker", {config: SingletonConfig.config}.merge(params))

  flash[:notice] = "Submitted, thank you!"
  redirect "/"
end

get '/leads' do
  @contacts = settings.ocm.get_list("lead_list")
  erb :contacts
end

get '*' do
  erb :index
end
