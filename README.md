# Meal Delivery API

## Environtment
#### - Rails version: 6.1.4.1
#### - Ruby Version: 2.7.2
#### - Bundle Version: 2.1.4

## Databases:
#### - MySql
#### - ElasticSearch

### Import Raw Data
There 2 endpoint to import Restaurant and User Data
1. User Import Endpoint ```/api/v1/import_user```
2. Restaurant Import Endpoint ```/api/v1/import_restaurant```
this request may take long time to execute

### Setup Backend Server
1. Clone this repository
2. Setup DB Credential
3. Run ```rails db:migrate```
4. Run Import API (this request may take long time to execute)
5. run server ```rails s```

### Unit Testing
1. In your project directory: type ```bundle install```
2. run ```rspec```
3. To view coverage, open index.html in ```{PROJECT DIRECTORY}/coverage/index.html```

### API Documentation
##### Documentation for this projects
```https://documenter.getpostman.com/view/1487291/UVByKqe5```


### Production URL
This project deployed in DigitalOcean using capistrano. The production URL ```159.65.13.11```
- Basic Authentication:
Username: ```user_id```
Password: ```hungry12345678```
