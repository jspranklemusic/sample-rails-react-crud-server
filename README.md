# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Creation Process
First, I needed to figure out the type of application I was going to create. I started by reading information about Job Hazard Analysis from the links in the PDF, as well as examined the sample JHA from the University of Washington. Then I needed to decide how to structure my data and relationships in a way that could be accessible and searched easily. I decided on:

### JobHazardAnalysis
`id`: Number <br>
`job_id`: Number (foreign key)  <br>
`date`: Number (UTC Timestamp)  <br>
`title`: String  <br>
`summary`: Text  <br>
`author_id`: Number (foreign key for authors)

### Task
`id`: Number  <br>
`description`: String  <br>
`jha_id`: Number (foreign key)  <br>

### Hazard
`task_id`: Number (foreign key)  <br>
`id`: Number  <br>
`description`: String  <br>

### SafeGuard
`id`: Number  <br>
`hazard_id`: Number (foreign key)  <br>
`description`: String  <br>

### Job
`id`: Number  <br>
`title`: String  <br>
`description`: String  <br>

## Model Creation
To take advantage of the relationship mapping, model generation, and route configuration in Rails, I ran the following commands: <br>
`rails g scaffold JobHazardAnalysis job:references title:string date:integer summary:text author:references` <br>
`rails g scaffold Task description:string jha references` <br>
`rails g scaffold Hazard task:references description:string `<br>
`rails g scaffold Safeguard hazard:references description:string` <br>
`rails g scaffold Job title:string description:string` <br>
`rails g scaffold Author first_name last_name email password `<br>

These commands create models with the names of __JobHazardAnalysis__, __Task__, __Hazard__, __Safeguard__, __Job__, and __Author__ in the `/app/models` folder, and controllers with methods for GET, PUT, POST, and DELETE in the `/app/controllers` folder.

## Issues I Encountered:
I didn't get the Rails associations right. To destroy the children of a parent, you must have dependent: destroy in the parent model.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
