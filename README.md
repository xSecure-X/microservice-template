
# microservice-template
===========================================

`git clone git@github.com:xSecure-X/microservice-template.git`

## Steps to get the application Up and Running

* Install docker https://www.docker.com/

### Run the following commands:
1. `docker-compose build`
2. `docker-compose up`
3. `http://localhost:3000/`


## How to Run rails commands inside a docker container

To run the rails generate migration command within a Docker container, you can follow these steps:

Open a terminal or command prompt and navigate to the root directory of your Rails application where the docker-compose.yml file is located.

Run the following command to enter into the running Rails container:

`docker-compose run web bash`
This command starts a new shell session within the web container.

Once you're inside the container's shell, you can run the migration generation command:

`rails generate migration CreateUsers`
This command generates a new migration file in the db/migrate directory of your Rails application.

Exit the container's shell by typing exit and pressing Enter.
