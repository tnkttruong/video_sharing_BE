## Video Sharing BE

[Project overview](https://github.com/tnkttruong/video_sharing)

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
RAILS_ENV=test bundle exec rspec
```
## [API Document](https://video-sharing-api.dubbing.co/api-docs/index.html)

## Deployment

We are using AWS CodePipeline for our CI/CD pipeline. When a change is pushed to GitHub, CodePipeline is automatically triggered.

Once the pipeline is set up, the deployment process becomes:

1. **Commit and push changes**

   When you push your changes to your GitHub repository, this will automatically trigger the pipeline.

2. **CodeBuild builds the Docker image**

   AWS CodeBuild will automatically build a Docker image from your source code and push it to Amazon ECR. This happens in the build stage of your pipeline.

3. **CodeDeploy deploys the new image**

   AWS CodeDeploy will automatically update the ECS service to use the new Docker image. This happens in the deploy stage of your pipeline.

By this method, the deployment process is completely automated, reducing the chance of errors and increasing the speed at which new versions can be deployed.
