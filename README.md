# To Do Application

This application fulfils the requirements set out for the to do project:

- I can have my todo list displayed.
- I can manipulate my list (add/remove/modify entries).
- Assign priorities and due dates to the entries.
- I can sort my entry lists using due date and priority.
- I can mark an entry as completed.
- Minimal UI/UX design is needed.
- I need every client operation done using JavaScript, reloading the page is not an option.
- Write a RESTful API which will allow a third-party application to trigger actions on your app (same actions available on the webpage).
- You need to be able to pass credentials to both the webpage and the API.
- As complementary to the last item, one should be able to create users in the system via an interface, probably a signup/register screen.

## System Requirements

* Ruby 2.1.0
* RubyGems
* Bundler (`gem install bundler`)

## Installation

1. `bundle install`
2. `bundle exec rake db:migrate`
3. `rails s`

Then navigate to [http://localhost:3000](http://localhost:3000).

## Configuration

If you are not running the server on http://localhost:3000 you'll need to edit some files for things to work correctly:

* `config/environments/development.rb` - edit the `config.action_mailer.default_url_options` directive.
* `public/api/v1/api-docs.json` and `public/api/v1/tasks.json` - edit the `basePath` parameters.

## Running tests

Run `RAILS_ENV=test rake db:migrate && bundle exec rspec spec` to run the test suite.

## Registration

You must first register an account to use the application. You will be prompted to register when attempting to sign in.

## Using the API

The application exposes a RESTful API. Browse to the [API documentation](http://localhost:3000/api) within the browser to view interactive documentation.

You must supply your account token and e-mail address on every request to the API. These can be found on the [API documentation](http://localhost:3000/api) page.