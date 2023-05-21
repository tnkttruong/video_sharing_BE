## Tech Stack

* Ruby on Rails - Server-side web application framework written in Ruby
* PostgreSQL - Open source object-relational database system
* Redis - In-memory data structure store, used as a database, cache and message broker
* Sidekiq - Simple, efficient background processing for Ruby
* Docker - Platform to develop, deploy, and run applications with containers
* Firebase Realtime Database - NoSQL cloud database to store and sync data between users in realtime
* AWS ECS, ECR, ELB - Amazon Web Services, used for deploying and scaling web applications and services
* GitHub Actions - CI/CD platform

## Prerequisites

Before setting up the project, make sure you have the following installed:

1. [Docker](https://docs.docker.com/get-docker/)
2. [Firebase Realtime Database](https://firebase.google.com/docs/database)
3. [YouTube Data API v3 key](https://developers.google.com/youtube/v3/getting-started)

## Installation & Configuration

1. Clone the repository to your local machine: 
    ```
    git clone git@github.com:tnkttruong/video_sharing_BE.git
    ```
2. Navigate into the cloned repository: 
    ```
    cd video_sharing_BE
    ```
3. Navigate to docker/development: 
    ```
    cd docker/development
    ```
4. Replace the respective values of the following variables with the information you created in the Prerequisites step `ENV['YOUTUBE_API_KEY']`, `ENV['FIREBASE_SECRET_KEY']` and `ENV['FIREBASE_URL']` at `config/environments/development.rb` and `config/environments/test.rb`.
5. Start the Docker container: 
    ```
    docker-compose up
    ```
6. Create the database: 
    ```
    docker-compose run api rake db:create
    ```
7. Run migrations: 
    ```
    docker-compose run api rake db:migrate
    ```
8. Seed the database: 
    ```
    docker-compose run api rake db:seed
    ```

## Running the Application

Once you have followed the installation and configuration steps, you can start the application by running the following command in your terminal:

```
bin/dev
```

Run test
```
bundle exec rspec
```
## Deployment

To deploy the application, follow these steps:

1. Build the Docker image:
    ```
    docker buildx build --platform=linux/amd64 --progress=plain -t video_sharing_api .
    ```

2. Tag the Docker image with your ECR URI and your chosen tag or version:
    ```
    docker tag video_sharing_api YOUR_ECR_URI:YOUR_TAG/VERSION
    ```

3. Push the Docker image to your ECR repository:
    ```
    docker push YOUR_ECR_URI:YOUR_TAG/VERSION
    ```

4. Create a new Task definition with your ECR URI and your chosen tag or version.

5. Update the ECS service to use the latest Task definition.