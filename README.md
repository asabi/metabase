# Metabase Server With SSL and a Custom Domain

This script provides a simple way to run Metabase on NGINX.

You can find detailed instructions on how to get going in [this blog post](www.sabi.me):

## About the scripts:

`start.sh` This is the first script you need to run. It will use docker-compose to set up an NGINX proxy server and a Metabase server.

`stop.sh` is the script to stop the containers.

`renew_ssl.sh` This the script that creates and renews an SSL certificate with let's encrypt.


## Automating the SSL renual

Let's encrypt expires every 3 months, so you need to renew it. The easiest way is to automate the process:

Add the following to your cron (replace with your install location):

`30 03 01 Sep,Nov,Jan,Mar,May,Jul * /location/to/your/script/metabase/renew_ssl.sh & > /dev/null`

This 👆 will run the script every two months.

The commands are:

`crontab -e`

paste the above line, and save.

You can check if it saved properly by running:

`crontab -l`, you should see the scheduled job.