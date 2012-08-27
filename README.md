## Overview

This is a demo of an application that will post data to a message queue, IronMQ, in order to handle variable
loads. Boomi is then used to transform these messages and push them to the Salesforce API as leads.
A job is also queued up for IronWorker to send confirmation emails.

## Getting Started

First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it or to sign up.

To run in development:

- Copy the `config_sample.yml` file to `config.yml` and fill in the appropriate values.
- Upload the email worker with `rake workers:upload_email_worker`
- Run `rackup` at the command line

To run on heroku:

- Run `rake push_config` to store config
- Then `git push heroku master`

