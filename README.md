First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it or to sign up.

To run in development:

- Copy the `config_sample.yml` file to `config.yml` and fill in the appropriate values.
- Run `rackup` at the command line

To run on heroku:

- Run `rake push_config` to store config
- Then `git push heroku master`

