
post '/lead' do
  puts 'in lead'
  lead = Contact.new
  lead.name = params[:name]
  lead.email = params[:email]
  lead.company = params[:company]
  #lead.save!
  settings.orm.save(lead)
  puts "Saved lead: " + lead.inspect

  settings.orm.add_to_list("lead_list", lead)

  msg = {
      'id'=>lead.id.to_s,
      'name'=>lead.name,
      'email'=>lead.email,
      'company'=>lead.company
  }
  puts "Putting message on queue: " + msg.inspect

  settings.ironmq.messages.post(msg.to_json, :queue_name=>'lead')

  # Now queue up email worker
  task = settings.ironworker.tasks.create("email_worker",
                         SingletonConfig.config.merge(
                             to: lead.email,
                             subject: "Thanks for the Lead!",
                             body: "Thanks #{lead.name}!<br/>
<br/>
Company: #{lead.company}<br/>
Email: #{lead.email}<br/>
"

                         ))

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
