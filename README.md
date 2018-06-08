Summary

This project has Post, Author and Subscriber models. Every time a new post is created a callback runs to notify author's subscribers. The callback creates a background job.

The google pub-sub is used as job background. When the first job is executed it creates a mail delivery for every subscriber which is also done using background job.

Every time a job is processed librato is notified to increase the count and time spent in execution.

Active job backend uses two topics on google pub-sub to maintain active queue and morgue queue.

Please follow following steps to see the working.

1. install ruby 2.5.1 on your system if not present
2. Install Mysql if not present

3. Run following commands
gem install bundler
bundle install

4. Create database.yml with the help of database.yml.example

5. Create secrets.yml with the help of secrets.yml.example
All the credentials are provided in zip file.

6. Create google_pub_sub_credentials.json with the help of google_pub_sub_credentials.json.example
All the credentials are provided in zip file.

7. Run following commands

rails db:setup

8. Open a new tab and following command

rails s

9. Open a new tab and following command

bundle exec rake run_worker

10. Visit http://localhost:3000/posts/new and create a new post

11. Open https://my.appoptics.com/s/dashboards/664662 with credentials provided and see the updated metrics
