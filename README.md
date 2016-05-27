# README

## Requirement
* Ruby 2.3.0+
* Rails 5.0.0.rc1
* PostgreSQL Database

## Deployment Steps
#### Install required gems
```
bundle install
```
#### Set up your configuration
```
cp config/application.yml.example config/application.yml
```
Now edit config/application.yml with your development database credentials
#### Create Database
```
rake db:create
```
#### Run Migrations
```
rake db:migrate
```
#### Run Seed data file
```
rake db:seed
```
#### Install npm dependencies
```
cd client
```
```
npm install
```
#### Run the server
```
cd ..
```
```
foreman start -f Procfile.dev
```

## Things you need to know
We're using the ```react_on_rails``` gem so all javascript will live in `client/`.

If you write a new react component, it goes in `client/app/bundles/Doxly/components`. If you need to expose this component
so Rails (so it can be used with react_component), you need to add it into `client/app/bundles/Doxly/start/clientRegistration.jsx`