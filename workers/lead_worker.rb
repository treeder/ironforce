# lead_worker does all the work after someone submits a form.
# First, it will post a message to a queue so Boomi can take it off and post to Salesforce.
# Second, it will send out an email to the user.

require 'iron_worker_ng'
require 'iron_mq'
require 'iron_cache'
require 'ocm'
require_relative 'models/contact'

puts "params: #{params.inspect}"

config = params[:config]

lead = Contact.new
lead.name = params[:name]
lead.email = params[:email]
lead.company = params[:company]

mq = IronMQ::Client.new(token: config[:iron][:token], project_id: config[:iron][:project_id])
ic = IronCache::Client.new(token: config[:iron][:token], project_id: config[:iron][:project_id])
iw = IronWorkerNG::Client.new(token: config[:iron][:token], project_id: config[:iron][:project_id])

# Save to db (IronCache)
ocm = Ocm::Orm.new(ic.cache("ironforce"))
ocm.save(lead)
ocm.append_to_list("lead_list", lead)
puts "Saved lead: " + lead.inspect

# Add to queue (IronMQ)
msg = {
    id: lead.id.to_s,
    name: lead.name,
    email: lead.email,
    company: lead.company
}
puts "Putting message on queue: " + msg.inspect
mq.queue('lead').post(msg.to_json)

puts "Queuing up email"
# now queue up email worker
iw.tasks.create('email_worker', config['email'].merge(
    to: lead.email,
    subject: "Thanks for the Lead!",
    body: "Thanks #{lead.name}!<br/>
<br/>
Company: #{lead.company}<br/>
Email: #{lead.email}<br/>
"))
