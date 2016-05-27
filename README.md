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