# README

## Requirement
* Ruby 2.3.0+
* Rails 5.0.0.rc1
* PostgreSQL Database

## Deployment Steps
#### 0. Install required gems
```
bundle install
```

#### 1. Create Database
```
rake db:create
```

#### 2. Run Migrations
```
rake db:migrate
```

#### 3. Run Seed data file
```
rake db:seed
```

#### 4. Install npm dependencies
```
npm install
```

#### 5. Compile assets

* Development
```
gulp
```

* Production
```
gulp live
```

#### 4. Start Server
```
rails s
```